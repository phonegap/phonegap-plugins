/**
 *  SpeechRecognizer.java
 *  Speech Recognition PhoneGap plugin (Android)
 *
 *  @author Colin Turner
 *
 *  Copyright (c) 2011, Colin Turner
 *
 *  MIT Licensed
 */
package com.phonegap.plugins.speech;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import org.json.JSONArray;
import org.json.JSONObject;

import org.apache.cordova.api.CordovaPlugin;
import org.apache.cordova.api.CallbackContext;
//import org.apache.cordova.api.PluginResult.Status;

import android.util.Log;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.speech.RecognizerIntent;

/**
 * Style and such borrowed from the TTS and PhoneListener plugins
 */
public class SpeechRecognizer extends CordovaPlugin {
    private static final String LOG_TAG = SpeechRecognizer.class.getSimpleName();
    public static final String ACTION_INIT = "init";
    public static final String ACTION_SPEECH_RECOGNIZE = "startRecognize";
    public static final String NOT_PRESENT_MESSAGE = "Speech recognition is not present or enabled";

    private CallbackContext cbContext;
    public String callback;
    private String speechRecognizerCallbackId = "";
    private boolean recognizerPresent = false;

    /* (non-Javadoc)
     * @see com.phonegap.api.Plugin#execute(java.lang.String, org.json.JSONArray, java.lang.String)
     */
    //@Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
        
    	this.cbContext= callbackContext;
        
    	// Dispatcher
        if (ACTION_INIT.equals(action)) {
            
            if (DoInit())
                return true;
            else
            	this.cbContext.error("Speech Not Initialized or Unavailable");
                return false;
            
        }
        else if (ACTION_SPEECH_RECOGNIZE.equals(action)) {
            // recognize speech
            if (!recognizerPresent) {
                callbackContext.error(NOT_PRESENT_MESSAGE);
            	return false;
            }
            if (!this.speechRecognizerCallbackId.equals("")) {
            	callbackContext.error("Speech recognition is in progress.");
            	return false;
            }

            
            startSpeechRecognitionActivity(args);
                       
        }
        else {
            // Invalid action
        	this.cbContext.error("Unknown action: " + action);
            return false;
        }
       return true;
    }

    /**
     * Initialize the speech recognizer by checking if one exists.
     */
    private boolean DoInit() {
        this.recognizerPresent = IsSpeechRecognizerPresent();
        return this.recognizerPresent;
    }

    /**
     * Checks if a recognizer is present on this device
     */
    private boolean IsSpeechRecognizerPresent() {
        PackageManager pm = cordova.getActivity().getPackageManager();
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
        }
        catch (Exception e) {
            Log.e(LOG_TAG, String.format("startSpeechRecognitionActivity exception: %s", e.toString()));
        }

        Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.ENGLISH);
        if (maxMatches > 0)
            intent.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, maxMatches);
        if (!prompt.equals(""))
            intent.putExtra(RecognizerIntent.EXTRA_PROMPT, prompt);
        cordova.startActivityForResult(this, intent, reqCode);
    }

    /**
     * Handle the results from the recognition activity.
     */
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {
            // Fill the list view with the strings the recognizer thought it could have heard
            ArrayList<String> matches = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
            float[] confidence = data.getFloatArrayExtra(RecognizerIntent.EXTRA_CONFIDENCE_SCORES);

            if (confidence != null) {
                Log.d(LOG_TAG, "confidence length "+ confidence.length);
                Iterator<String> iterator = matches.iterator();
                int i = 0;
                while(iterator.hasNext()) {
                    Log.d(LOG_TAG, "Match = " + iterator.next() + " confidence = " + confidence[i]);
                    i++;
                }
            } else {
                Log.d(LOG_TAG, "No confidence" +
                        "");
            }

            ReturnSpeechResults(requestCode, matches);
        }
        else {
            // Failure - Let the caller know
            this.cbContext.error(Integer.toString(resultCode));
        }

        super.onActivityResult(requestCode, resultCode, data);
    }

    private void ReturnSpeechResults(int requestCode, ArrayList<String> matches) {
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

        this.cbContext.success(sb.toString());
    }
    
}