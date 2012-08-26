/**
 * HeadsetWatcher plugin for Cordova/Phonegap
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) Triggertrap Ltd. 2012
 * 
 */


package com.triggertrap;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.apache.cordova.api.PluginResult.Status;
import org.json.JSONArray;
import org.json.JSONObject;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;

public class HeadsetWatcher extends Plugin {

	private String callback;
	public HeadsetBroadcastReceiver headsetReceiver;
	@Override
	public PluginResult execute(String action, JSONArray data, String callbackId) {
		this.callback = callbackId;
		headsetReceiver = new HeadsetBroadcastReceiver(this);
		PluginResult result = new PluginResult(Status.NO_RESULT);
		this.cordova.getActivity().registerReceiver(headsetReceiver, new IntentFilter(Intent.ACTION_HEADSET_PLUG));
		result.setKeepCallback(true);
		return result;
	}
	
	public void changed(int state) {

		JSONObject status = new JSONObject();
		try {
			status.put("plugged", state == 1 ? true : false);
		} catch (Exception ex) {
			Log.e("Headset", "JSON error " + ex.toString());
			return;
		}
		PluginResult result = new PluginResult(PluginResult.Status.OK, status);
		result.setKeepCallback(true);
		this.success(result, this.callback);
	}

	public class HeadsetBroadcastReceiver extends BroadcastReceiver
    {     
        protected HeadsetWatcher watcher; 
        
        public HeadsetBroadcastReceiver(HeadsetWatcher watcher) {
        	super();
        	this.watcher = watcher; 
        }
        
        @Override        
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            Log.d("ACTION_HEADSET_PLUG Received", action);
            if( (action.compareTo(Intent.ACTION_HEADSET_PLUG))  == 0) {
                int headsetState = intent.getIntExtra("state", 0); 
                watcher.changed(headsetState);
            }           
 
        }

    }

	
}

