/* PayPal PhoneGap Plugin - Map JavaScript API calls to mpl library
 *
 * Copyright (C) 2011, Appception, Inc.. All Rights Reserved.
 * Copyright (C) 2011, Mobile Developer Solutions All Rights Reserved.
 * Copyright (C) 2012, Bucka IT, Tomaz Kregar s.p. All Rights Reserved.
 */

package com.phonegap.plugin;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.util.Log;

import org.apache.cordova.api.CallbackContext;
import org.apache.cordova.api.CordovaPlugin;
import org.apache.cordova.api.PluginResult;
import org.apache.cordova.api.PluginResult.Status;

public class PayPalPlugin extends CordovaPlugin {
	private static mpl PluginMpl;
	protected static CordovaPlugin thisPlugin;

	public boolean execute(String action, JSONArray data, CallbackContext callbackContext) {
		Context context = cordova.getActivity();
		Log.d("PayPalPlugin", "Plugin Called");

		try {
			Log.d("PayPalPlugin", action);
			if (action.equals("construct")) {
				
				thisPlugin = this;
				PluginMpl = new mpl(context, data.getString(0));
				Log.d("PayPalPlugin", "2");
				callbackContext.success();
			} else if (action.equals("prepare")) {
				Log.d("PayPalPlugin", "prepare");
				PluginMpl.prepare(data.getInt(0));
				callbackContext.success();
			} else if (action.equals("getStatus")) {
				String status  = PluginMpl.getStatus();
				callbackContext.success(status);
			} else if (action.equals("setPaymentInfo")) {
				PluginMpl.setPaymentInfo(data.getString(0));
				callbackContext.success();
			} else if (action.equals("pay")) {
				PluginMpl.pay(data.getInt(0));
			} else {
				callbackContext.error("Action not found.");
				return false;
			}

		} catch (JSONException e) {
			Log.d("DirectoryListPlugin", "Got JSON Exception "+ e.getMessage());
			callbackContext.error(e.getMessage());
			return false;
		}
		return true;
	}
}
