/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 * 
 * Copyright (c) 2011, IBM Corporation
 */

package com.phonegap.plugins.speech;

import java.util.Locale;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.speech.tts.TextToSpeech;
import android.speech.tts.TextToSpeech.OnInitListener;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;

public class TTS extends Plugin implements OnInitListener {
	
	private static final String LOG_TAG = "TTS";
	private static final int STOPPED = 0;
	private static final int INITIALIZING = 1;
	private static final int STARTED = 2;
	private TextToSpeech mTts = null;
	private int state = STOPPED;
	
	private String startupCallbackId = "";
	
	@Override
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		PluginResult.Status status = PluginResult.Status.OK;
		String result = "";

		
		try {
			if (action.equals("speak")) {
				String text = args.getString(0);
				if (isReady()) {
					mTts.speak(text, TextToSpeech.QUEUE_ADD, null);
			        return new PluginResult(status, result);
				} else {
					JSONObject error = new JSONObject();
					error.put("message","TTS service is still initialzing.");
					error.put("code", TTS.INITIALIZING);
			        return new PluginResult(PluginResult.Status.ERROR, error);
				}
		    }  
			else if (action.equals("silence")) {
				if (isReady()) {
					mTts.playSilence(args.getLong(0), TextToSpeech.QUEUE_ADD, null);
			        return new PluginResult(status, result);
				} else {
					JSONObject error = new JSONObject();
					error.put("message","TTS service is still initialzing.");
					error.put("code", TTS.INITIALIZING);
			        return new PluginResult(PluginResult.Status.ERROR, error);
				}
		    }
			else if (action.equals("startup")) {
				if (mTts == null) {
					this.startupCallbackId = callbackId;
					state = TTS.INITIALIZING;
		            mTts = new TextToSpeech(ctx.getContext(), this);
		            //mTts.setLanguage(Locale.US);			
				}								
				PluginResult pluginResult = new PluginResult(status, TTS.INITIALIZING);
				pluginResult.setKeepCallback(true);
		        return pluginResult;
		    }
			else if (action.equals("shutdown")) {
				if (mTts != null) {
					mTts.shutdown();
				}
		        return new PluginResult(status, result);
		    }
			else if (action.equals("getLanguage")) {
				if (mTts != null) {
					result = mTts.getLanguage().toString();
			        return new PluginResult(status, result);
				}
		    }
			else if (action.equals("isLanguageAvailable")) {
				if (mTts != null) {
					Locale loc = new Locale(args.getString(0));
					int available = mTts.isLanguageAvailable(loc);
					result = (available < 0) ? "false" : "true";
			        return new PluginResult(status, result);
				}
		    }
			else if (action.equals("setLanguage")) {
				if (mTts != null) {
					Locale loc = new Locale(args.getString(0));
					int available = mTts.setLanguage(loc);
					result = (available < 0) ? "false" : "true";
			        return new PluginResult(status, result);
				}
		    }
			return new PluginResult(status, result);
		} catch (JSONException e) {
			e.printStackTrace();
			return new PluginResult(PluginResult.Status.JSON_EXCEPTION);
		}
	}

	/**
	 * Is the TTS service ready to play yet?
	 * 
	 * @return
	 */
	private boolean isReady() {
		return (state == TTS.STARTED) ? true : false;
	}

	/**
	 * Called when the TTS service is initialized.
	 * 
	 * @param status 
	 */
	public void onInit(int status) {
		if (status == TextToSpeech.SUCCESS) {
            state = TTS.STARTED;
    		PluginResult result = new PluginResult(PluginResult.Status.OK, TTS.STARTED);
    		result.setKeepCallback(false);
    		this.success(result, this.startupCallbackId);
        }
        else if (status == TextToSpeech.ERROR) {
            state = TTS.STOPPED;
    		PluginResult result = new PluginResult(PluginResult.Status.ERROR, TTS.STOPPED);
    		result.setKeepCallback(false);
    		this.error(result, this.startupCallbackId);
        }
	}
	
	/** 
	 * Clean up the TTS resources
	 */
	public void onDestroy() {
		if (mTts != null) {
			mTts.shutdown();
		}
	}
}
