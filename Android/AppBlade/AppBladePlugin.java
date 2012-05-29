/**
 * 
 */
package com.phonegap.helloworld;

import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;

import android.util.Log;

import com.phonegap.api.Plugin;

import android.app.Activity;

import com.appblade.framework.AppBlade;

/**
 * @author micheletitolo
 *
 */
public class AppBladePlugin extends Plugin {
	public static final String SETUP="setupAppBlade";
	public static final String CHECKAPPROVAL="checkAuthentication";
	/* (non-Javadoc)
	 * @see org.apache.cordova.api.Plugin#execute(java.lang.String, org.json.JSONArray, java.lang.String)
	 */
	@Override
	public PluginResult execute(String action, JSONArray data, String callbackId) {
		PluginResult result = null;
		if (SETUP.equals(action)) {
			String token = data.optString(2);
			String secret = data.optString(1);
			String uuid = data.optString(0);
			String issuance = data.optString(3);
			
			AppBlade.register(this.ctx.getApplicationContext(), token, secret, uuid, issuance);
			result = new PluginResult(PluginResult.Status.OK);
		}
		else if (CHECKAPPROVAL.equals(action))
		{
	        // PhoneGap runs on its own thread. So we need one to display an alert and do our UI on.
	        this.ctx.runOnUiThread(new Runnable() {
	            
	            public void run() {
	                AppBlade.authorize((Activity) AppBladePlugin.this.ctx);
	            }
	        });
			result = new PluginResult(PluginResult.Status.OK);
		}
		else {
			result = new PluginResult(PluginResult.Status.INVALID_ACTION);
		}
		
		return result;
	}

}
