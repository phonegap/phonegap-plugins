package com.simonmacdonald.prefs;

import java.util.Iterator;
import java.util.Map;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.preference.PreferenceManager;
import android.util.Log;

public class AppPreferences extends Plugin {

    private static final String LOG_TAG = "AppPrefs";
    private static final int NO_PROPERTY = 0;
    private static final int NO_PREFERENCE_ACTIVITY = 1;

    @Override
    public PluginResult execute(String action, JSONArray args, String callbackId) {
        PluginResult.Status status = PluginResult.Status.OK;
        String result = "";

        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this.cordova.getActivity());

        try {
            if (action.equals("get")) {
                String key = args.getString(0);
                if (sharedPrefs.contains(key)) {
                    Object obj = sharedPrefs.getAll().get(key);
                    return new PluginResult(status, obj.toString());
                } else {
                    return createErrorObj(NO_PROPERTY, "No such property called " + key);
                }
            } else if (action.equals("set")) {
                String key = args.getString(0);
                String value = args.getString(1);
                if (sharedPrefs.contains(key)) {
                    Editor editor = sharedPrefs.edit();
                    if ("true".equals(value.toLowerCase()) || "false".equals(value.toLowerCase())) {
                        editor.putBoolean(key, Boolean.parseBoolean(value));
                    } else {
                        editor.putString(key, value);
                    }
                    return new PluginResult(status, editor.commit());
                } else {
                    return createErrorObj(NO_PROPERTY, "No such property called " + key);
                }
            } else if (action.equals("load")) {
                JSONObject obj = new JSONObject();
                Map prefs = sharedPrefs.getAll();
                Iterator it = prefs.entrySet().iterator();
                while (it.hasNext()) {
                    Map.Entry pairs = (Map.Entry)it.next();
                    obj.put(pairs.getKey().toString(), pairs.getValue().toString());
                }
                return new PluginResult(status, obj);
            } else if (action.equals("show")) {
                String activityName = args.getString(0);
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setClassName(this.cordova.getActivity(), activityName);
                try {
                    this.cordova.getActivity().startActivity(intent);
                } catch (ActivityNotFoundException e) {
                    return createErrorObj(NO_PREFERENCE_ACTIVITY, "No preferences activity called " + activityName);
                }
            }
        } catch (JSONException e) {
            status = PluginResult.Status.JSON_EXCEPTION;
        }
        return new PluginResult(status, result);
    }

    private PluginResult createErrorObj(int code, String message) throws JSONException {
        JSONObject errorObj = new JSONObject();
        errorObj.put("code", code);
        errorObj.put("message", message);
        return new PluginResult(PluginResult.Status.ERROR, errorObj);
    }

}
