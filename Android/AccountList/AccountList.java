package com.seltzlab.mobile;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.accounts.Account;
import android.accounts.AccountManager;

import org.apache.cordova.DroidGap;
import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;

public class AccountList extends Plugin {

	@Override
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		
		try {
			JSONObject obj = args.getJSONObject(0);
			
			AccountManager am = AccountManager.get(cordova.getActivity());
			
			Account[] accounts;
			if (obj.has("type"))
				accounts = am.getAccountsByType(obj.getString("type"));
			else
				accounts = am.getAccounts();
			
			JSONArray res = new JSONArray();
			for (int i = 0; i < accounts.length; i++) {
				Account a = accounts[i];
				res.put(a.name);
			}
		
			return new PluginResult(PluginResult.Status.OK, res);
			
		} catch (JSONException e) {
			return new PluginResult(PluginResult.Status.JSON_EXCEPTION);
		}
	}
	
}
