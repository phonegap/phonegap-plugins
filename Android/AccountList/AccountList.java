package com.seltzlab.mobile;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.accounts.Account;
import android.accounts.AccountManager;

import org.apache.cordova.api.CordovaPlugin;
import org.apache.cordova.api.CallbackContext;

public class AccountList extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("accounts")) {
            this.accounts(callbackContext, args);
            return true;
        }
        return false;
    }

    private void accounts(CallbackContext callbackContext, JSONArray args) {

        try {
            JSONObject obj  = new JSONObject();
            obj.put("type", "all");

            if (args.length() > 0) {
                obj = args.getJSONObject(0);
            }
            AccountManager am = AccountManager.get(this.cordova.getActivity());
            Account[] accounts;
            if (!obj.getString("type").equals("all")) {
                accounts = am.getAccountsByType(obj.getString("type"));
            } else {
                accounts = am.getAccounts();
            }

            JSONArray res = new JSONArray();
            for (int i = 0; i < accounts.length; i++) {
                Account a = accounts[i];
                if (a.type.equals("com.google")) {
                    res.put(a.name);
                }
            }
            callbackContext.success(res.toString());
        } catch (JSONException e) {
            callbackContext.error(e.getMessage());
        }
    }

}
