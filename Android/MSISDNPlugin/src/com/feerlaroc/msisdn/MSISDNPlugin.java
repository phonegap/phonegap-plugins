package com.feerlaroc.msisdn;

import org.json.JSONArray;

import android.content.Context;
import android.telephony.TelephonyManager;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;

public class MSISDNPlugin extends Plugin {
    /** Called when the activity is first created. */
    @Override
    public PluginResult execute(String action, JSONArray args, String callbackId) {
        PluginResult.Status status = PluginResult.Status.OK;
        String result = "";

        if (action.equals("getSimNumber")) {
            TelephonyManager telephonyManager = (TelephonyManager)this.ctx.getSystemService(Context.TELEPHONY_SERVICE);
            result = telephonyManager.getLine1Number();
        }
        else {
            status = PluginResult.Status.INVALID_ACTION;
        }
        return new PluginResult(status, result);
    }
}