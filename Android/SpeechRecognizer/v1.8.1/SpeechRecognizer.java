/**
 *  SpeechRecognizer.java
 *  Speech Recognition PhoneGap plugin (Android)
 *
 *  @author Colin Turner
 *  @author Guillaume Charhon
 *  
 *  Copyright (c) 2011, Colin Turner, Guillaume Charhon
 * 
 *  MIT Licensed
 */
package com.urbtek.phonegap;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;
import com.phonegap.api.PluginResult.Status;

import android.util.Log;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.speech.RecognizerIntent;

class HintReceiver extends BroadcastReceiver {
	com.urbtek.phonegap.SpeechRecognizer speechRecognizer;
	String callBackId = "";
    @Override
    public void onReceive(Context context, Intent intent) {
        
        if (getResultCode() != Activity.RESULT_OK) {
            return;
        }
        // the list of supported languages. 
        ArrayList<CharSequence> hints = getResultExtras(true).getCharSequenceArrayList(RecognizerIntent.EXTRA_SUPPORTED_LANGUAGES);
        
        // Convert the map to json
        JSONArray languageArray = new JSONArray(hints);
        PluginResult result = new PluginResult(PluginResult.Status.OK, languageArray);
        result.setKeepCallback(false);
        //speechRecognizer.callbackId = "";
        speechRecognizer.success(result, "");      
    }
    
    public void setSpeechRecognizer(SpeechRecognizer speechRecognizer){
    	this.speechRecognizer = speechRecognizer;
    }
    
    public void setCallBackId(String id){
    	this.callBackId = id;
    }
}

/**
 * Style and such borrowed from the TTS and PhoneListener plugins
 */

public class SpeechRecognizer extends Plugin {
    private static final String LOG_TAG = SpeechRecognizer.class.getSimpleName();
    public static final String ACTION_INIT = "init";
    public static final String ACTION_SPEECH_RECOGNIZE = "startRecognize";
    public static final String NOT_PRESENT_MESSAGE = "Speech recognition is not present or enabled";
    
    public String callbackId = "";
    private boolean recognizerPresent = false;

    /* (non-Javadoc)
     * @see com.phonegap.api.Plugin#execute(java.lang.String, org.json.JSONArray, java.lang.String)
     */
    @Override
    public PluginResult execute(String action, JSONArray args, String callbackId) {
        // Dispatcher
        if (ACTION_INIT.equals(action)) {
            // init
            if (doInit())
                return new PluginResult(Status.OK);
            else
                return new PluginResult(Status.ERROR, NOT_PRESENT_MESSAGE);
        }
        else if (ACTION_SPEECH_RECOGNIZE.equals(action)) {
            // recognize speech
            if (!recognizerPresent) {
                return new PluginResult(PluginResult.Status.ERROR, NOT_PRESENT_MESSAGE);
            }

            if (!this.callbackId.isEmpty()) {
                return new PluginResult(PluginResult.Status.ERROR, "Speech recognition is in progress.");
            }
            
            this.callbackId = callbackId;           
            startSpeechRecognitionActivity(args);
            PluginResult res = new PluginResult(Status.NO_RESULT);
            res.setKeepCallback(true);              
            return res;
        }
        else if("getSupportedLanguages".equals(action)){
        	// save the call back id
        	//this.callbackId = callbackId;
        	// Get the list of supported languages
        	getSupportedLanguages();
        	// wait for the intent callback
        	PluginResult res = new PluginResult(Status.NO_RESULT);
        	res.setKeepCallback(true);   
        	return res;
        }
        else {
            // Invalid action
            String res = "Unknown action: " + action;
            return new PluginResult(PluginResult.Status.INVALID_ACTION, res);
        }
    }
    
    /**
     * Request the supported languages
     */
    private void getSupportedLanguages() {
    	// Create and launch get languages intent
    	Intent intent = new Intent(RecognizerIntent.ACTION_GET_LANGUAGE_DETAILS);
    	HintReceiver hintReceiver = new HintReceiver();
    	hintReceiver.setSpeechRecognizer(this);
    	//hintReceiver.setCallBackId(this.callbackId);
    	ctx.getApplicationContext().sendOrderedBroadcast(intent, null, hintReceiver, null, Activity.RESULT_OK, null, null);
	}

	/**
     * Initialize the speech recognizer by checking if one exists.
     */
    private boolean doInit() {
        this.recognizerPresent = isSpeechRecognizerPresent();
        return this.recognizerPresent;
    }
    
    /**
     * Checks if a recognizer is present on this device
     */
    private boolean isSpeechRecognizerPresent() {
        PackageManager pm = ctx.getPackageManager();
        List<ResolveInfo> activities = pm.queryIntentActivities(new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH), 0);
        return !activities.isEmpty();
    }


    
    /**
     * Fire an intent to start the speech recognition activity.
     * 
     * @param args Argument array with the following string args: [req code][number of matches][prompt string]
     */
    
    private void startSpeechRecognitionActivity(JSONArray args) {
        int reqCode = 42;   //Hitchhiker?
        int maxMatches = 0;
        String prompt = "";
        String language = "";
        
        try {
            if (args.length() > 0) {
                // Request code - passed back to the caller on a successful operation
                String temp = args.getString(0);
                reqCode = Integer.parseInt(temp);               
            }
            if (args.length() > 1) {
                // Maximum number of matches, 0 means the recognizer decides
                String temp = args.getString(1);
                maxMatches = Integer.parseInt(temp);                
            }
            if (args.length() > 2) {
                // Optional text prompt
                prompt = args.getString(2);
            }
            if (args.length() > 3){
            	// Optional language specified
            	language = args.getString(3);
            }
        }
        catch (Exception e) {
            Log.e(LOG_TAG, String.format("startSpeechRecognitionActivity exception: %s", e.toString()));
        }
        
        Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
        // If specific language
        if(!language.equals("")){
        	intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, language);
        }
        
        if (maxMatches > 0)
            intent.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, maxMatches);
        if (!(prompt.length() == 0))
            intent.putExtra(RecognizerIntent.EXTRA_PROMPT, prompt);
        ctx.startActivityForResult(this, intent, reqCode);
    }
    
    /**
     * Handle the results from the recognition activity.
     */
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {
            // Fill the list view with the strings the recognizer thought it could have heard
            ArrayList<String> matches = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
            speechResults(requestCode, matches);
            
        }
        else if(resultCode == Activity.RESULT_CANCELED){
            // cancelled by user
            speechFailure("Cancelled");
        } else {
        	speechFailure("Unknown error");
        }

        super.onActivityResult(requestCode, resultCode, data);
    }
    
    private void speechResults(int requestCode, ArrayList<String> matches) {
        boolean firstValue = true;
        StringBuilder sb = new StringBuilder();
        sb.append("{\"speechMatches\": {");
        sb.append("\"requestCode\": ");
        sb.append(Integer.toString(requestCode));
        sb.append(", \"speechMatch\": [");
        
        Iterator<String> iterator = matches.iterator();
        while(iterator.hasNext()) {
            String match = iterator.next();
            
            if (firstValue == false)
                sb.append(", ");
            firstValue = false;         
            sb.append(JSONObject.quote(match));
        }
        sb.append("]}}");

        PluginResult result = new PluginResult(PluginResult.Status.OK, sb.toString());
        result.setKeepCallback(false);
        this.success(result, this.callbackId);      
        this.callbackId = "";       
    }
    
    private void speechFailure(String message) {
        PluginResult result = new PluginResult(PluginResult.Status.ERROR, message);
        result.setKeepCallback(false);
        this.error(result, this.callbackId);        
        this.callbackId = "";       
    }    
}
