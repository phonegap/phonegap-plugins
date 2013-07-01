/**
 * CardIOPGPlugin.js
 * card.io phonegap plugin
 * @Copyright 2013 Cubet Technologies http://www.cubettechnologies.com
 * @author Robin <robin@cubettech.com>
 * @Since 28 June, 2013
 */

package com.cubettech.plugins.cardio;

import io.card.payment.CardIOActivity;

import org.apache.cordova.api.CallbackContext;
import org.apache.cordova.api.CordovaPlugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


import android.content.Intent;


@SuppressWarnings("deprecation")
public class CardIOPGPlugin extends CordovaPlugin   {

	public CallbackContext callbackContext;
    public static JSONArray mCreditcardNumber=null;
    public static String cardIOAPIKey;
    public static Boolean expiry;
    public static Boolean cvv;
    public static Boolean zip;
	  

	@Override
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
		// TODO Auto-generated method stub
		this.callbackContext = callbackContext;
		
		try {
			//set configurations
			JSONObject config = args.getJSONObject(0);
			cardIOAPIKey = config.getString("apiKey");
			expiry = config.getBoolean("expiry");
			cvv = config.getBoolean("cvv");
			zip = config.getBoolean("zip");
						
			Intent scanIntent = new Intent(cordova.getActivity(), CardIOMain.class);
	        cordova.getActivity().startActivity(scanIntent);
		    
			PluginResult cardData = new PluginResult(PluginResult.Status.NO_RESULT);
			cardData.setKeepCallback(true);
			callbackContext.sendPluginResult(cardData);
			return true;
			
		} catch (JSONException e) {
			PluginResult res = new PluginResult(PluginResult.Status.JSON_EXCEPTION);
			callbackContext.sendPluginResult(res);
			return false;
		} 


        
	}
	
	@Override
	public void onResume(boolean multitasking) {
		// TODO Auto-generated method stub
		super.onResume(multitasking);
		
		//send plugin result if success
		JSONArray mImagepath = mCreditcardNumber;
		if(mImagepath!=null)
		{
			PluginResult cardData = new PluginResult(PluginResult.Status.OK, mCreditcardNumber);
			cardData.setKeepCallback(false);
			callbackContext.sendPluginResult(cardData);
			mCreditcardNumber = null;
		} else {
			PluginResult cardData = new PluginResult(PluginResult.Status.NO_RESULT);
			cardData.setKeepCallback(false);
			callbackContext.sendPluginResult(cardData);
		}

	}
}
