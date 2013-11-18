package com.borismus.webintent;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.net.Uri;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;

/**
 * WebIntent is a PhoneGap plugin that bridges Android intents and web applications:
 *  
 * 1. web apps can spawn intents that call native Android applications. 
 * 2. (after setting up correct intent filters for PhoneGap applications), Android
 * 	  intents can be handled by PhoneGap web applications.
 * 
 * @author boris@borismus.com
 *
 */
public class WebIntent extends Plugin {

	/**
	 * Executes the request and returns PluginResult.
	 * 
	 * @param action 		The action to execute.
	 * @param args 			JSONArray of arguments for the plugin.
	 * @param callbackId	The callback id used when calling back into JavaScript.
	 * @return 				A PluginResult object with a status and message.
	 */
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		try {
			if (action.equals("startActivity")) {
				if(args.length() != 1) {
					return new PluginResult(PluginResult.Status.INVALID_ACTION);
				}
				
				// Parse the arguments
				JSONObject obj = args.getJSONObject(0);
				String type = obj.has("type") ? obj.getString("type") : null;
				Uri uri = obj.has("url") ? Uri.parse(obj.getString("url")) : null;
				JSONObject extras = obj.has("extras") ? obj.getJSONObject("extras") : null;
				Map<String, String> extrasMap = new HashMap<String, String>();
				
				// Populate the extras if any exist
				if (extras != null) {
					JSONArray extraNames = extras.names();
					for (int i = 0; i < extraNames.length(); i++) {
						String key = extraNames.getString(i);
						String value = extras.getString(key);
						extrasMap.put(key, value);
					}
				}
				
				startActivity(obj.getString("action"), uri, type, extrasMap);
				return new PluginResult(PluginResult.Status.OK);
				
			} else if (action.equals("hasExtra")) {
				if (args.length() != 1) {
					return new PluginResult(PluginResult.Status.INVALID_ACTION);
				}
				Intent i = this.ctx.getIntent();
				String extraName = args.getString(0);
				return new PluginResult(PluginResult.Status.OK, i.hasExtra(extraName));
				
			} else if (action.equals("getExtra")) {
				if (args.length() != 1) {
					return new PluginResult(PluginResult.Status.INVALID_ACTION);
				}
				Intent i = this.ctx.getIntent();
				String extraName = args.getString(0);
				if (i.hasExtra(extraName)) {
					return new PluginResult(PluginResult.Status.OK, i.getStringExtra(extraName));
				} else {
					return new PluginResult(PluginResult.Status.ERROR);
				}
			}
			return new PluginResult(PluginResult.Status.INVALID_ACTION);
		} catch (JSONException e) {
			e.printStackTrace();
			return new PluginResult(PluginResult.Status.JSON_EXCEPTION);
		}
	}
	
	void startActivity(String action, Uri uri, String type, Map<String, String> extras) {
		Intent i = (uri != null ? new Intent(action, uri) : new Intent(action));
		if (type != null) {
			i.setType(type);
		}
		for (String key : extras.keySet()) {
			String value = extras.get(key);
			i.putExtra(key, value);
		}
		this.ctx.startActivity(i);
	}
}
