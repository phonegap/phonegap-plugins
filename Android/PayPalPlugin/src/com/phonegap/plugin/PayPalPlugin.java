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

import android.util.Log;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.apache.cordova.api.PluginResult.Status;

public class PayPalPlugin extends Plugin {
	private static mpl PluginMpl;
	protected static Plugin thisPlugin;

	@Override
	public PluginResult execute(String action, JSONArray data, String callbackId) {
		Log.d("PayPalPlugin", "Plugin Called");
		
		PluginResult result = null;

		try {
			if (action.equals("construct")) {
				thisPlugin = this;
				PluginMpl = new mpl(this.ctx.getContext(), data.getString(0));
//				PluginMpl = new mpl(this.ctx, PayPal.ENV_NONE, "");
				result = new PluginResult(Status.OK);
				
			} else if (action.equals("prepare")) {
				PluginMpl.prepare(data.getInt(0));
				result = new PluginResult(Status.OK);
				
			} else if (action.equals("getStatus")) {
				String status  = PluginMpl.getStatus();
				JSONObject jobj = new JSONObject();
				jobj.put("str", status);
				result = new PluginResult(Status.OK, jobj);
				
			} else if (action.equals("setPaymentInfo")) {
				PluginMpl.setPaymentInfo(data.getString(0));
				result = new PluginResult(Status.OK);
				
			} else if (action.equals("pay")) {
				PluginMpl.pay(data.getInt(0));
				result = new PluginResult(Status.OK);
				
			} else {
				result = new PluginResult(Status.ERROR);
			}

		} catch (JSONException e) {
			Log.d("DirectoryListPlugin", "Got JSON Exception "+ e.getMessage());
			result = new PluginResult(Status.JSON_EXCEPTION);
		}
		return result;
	}
}
