package com.ocrapiservice;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;


import android.content.ContentResolver;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Log;

public class OcrApiServicePlugin extends Plugin {

	public static final String NATIVE_ACTION_STRING="convert"; 

	private String imageUri = "";
	private String language = "";
	private String apikey = ""; 
	private OcrService apiClient;
	
	 public PluginResult execute(String action, JSONArray data, String callbackId) { 
		 if (NATIVE_ACTION_STRING.equals(action)) { 
		       try { 
		    	   // Retrieve parameters
		    	   imageUri = data.getString(0); 
		    	   language = data.getString(1);
		    	   apikey = data.getString(2);
		    	   
		    	   // Load the http client and perform the conversion
		    	   apiClient = new OcrService(apikey);
		    	   
		    	   String filePath = getFilePathFromResourcePath(imageUri);
		    	   Log.d("filePath : " , filePath);
		    	   apiClient.convertToText(language, filePath);
		    	   if (!checkRequestSucceed())
		    		   throw new Exception(apiClient.getResponseText());
		    	   		    	   
		    	   // return the text as success
		    	   String recognizedText = apiClient.getResponseText();
		    	   return new PluginResult(PluginResult.Status.OK, recognizedText); 

		       } 
		       catch (Exception ex) { 
		             return new PluginResult(PluginResult.Status.ERROR, ex.getMessage()); 
		       } 
		       
		      
		 } 
		 
		 return null; 
	 } 
	 
	 // check if the request has succeeded
	 private boolean checkRequestSucceed(){
		 if (apiClient.getResponseCode() == 200)
			 return true;
		 else 
			 return false;
	 }
	 
	 // Convert a resource path to a file path
	 private String getFilePathFromResourcePath(String resourcePath){
		 String filePath = "";
		 // Discussion about the warning
		 // http://simonmacdonald.blogspot.fr/2012/07/phonegap-android-plugins-sometimes-we.html
		 ContentResolver cr = this.cordova.getContext().getContentResolver();
		 String [] projection = {MediaStore.Images.Media.DATA};
		 Cursor cur = cr.query(Uri.parse(resourcePath), projection, null, null, null);
		 if(cur != null)
		 {
		    cur.moveToFirst();
		    filePath = cur.getString(0);
		 } 
		 
		 return filePath;
	 }


}
