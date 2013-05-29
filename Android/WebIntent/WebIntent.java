package com.borismus.webintent;

import java.util.HashMap;
import java.util.Map;

import org.apache.cordova.DroidGap;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.text.Html;

import org.apache.cordova.api.CordovaPlugin;
import org.apache.cordova.api.PluginResult;
import org.apache.cordova.api.CallbackContext;

/**
 * WebIntent is a PhoneGap plugin that bridges Android intents and web
 * applications:
 *
 * 1. web apps can spawn intents that call native Android applications. 2.
 * (after setting up correct intent filters for PhoneGap applications), Android
 * intents can be handled by PhoneGap web applications.
 *
 * @author boris@borismus.com
 *
 */
public class WebIntent extends CordovaPlugin {

    private String onNewIntentCallback = null;

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action
     *            The action to execute.
     * @param args
     *            JSONArray of arguments for the plugin.
     * @param callbackContext
     *            The callbackContext used when calling back into JavaScript.
     * @return boolean
     */
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
        try {
            if (action.equals("startActivity")) {
                if (args.length() != 1) {
                    PluginResult res = new PluginResult(PluginResult.Status.INVALID_ACTION);
                    callbackContext.sendPluginResult(res);
                    return false;
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
                callbackContext.success();
                return true;

            } else if (action.equals("hasExtra")) {
                if (args.length() != 1) {
                    PluginResult res = new PluginResult(PluginResult.Status.INVALID_ACTION);
                    callbackContext.sendPluginResult(res);
                    return false;
                }
                Intent i = ((DroidGap)this.cordova.getActivity()).getIntent();
                String extraName = args.getString(0);
                PluginResult res = new PluginResult(PluginResult.Status.OK, i.hasExtra(extraName));
                callbackContext.sendPluginResult(res);
                return true;

            } else if (action.equals("getExtra")) {
                if (args.length() != 1) {
                    PluginResult res = new PluginResult(PluginResult.Status.INVALID_ACTION);
                    callbackContext.sendPluginResult(res);
                    return false;
                }
                Intent i = ((DroidGap)this.cordova.getActivity()).getIntent();
                String extraName = args.getString(0);

                if (i.hasExtra(extraName)) {
                    PluginResult res = new PluginResult(PluginResult.Status.OK, i.hasExtra(extraName));
                    callbackContext.sendPluginResult(res);
                    return true;

                } else {
                    PluginResult res = new PluginResult(PluginResult.Status.ERROR);
                    callbackContext.sendPluginResult(res);
                    return false;
                }

            } else if (action.equals("getUri")) {
                if (args.length() != 0) {
                    PluginResult res = new PluginResult(PluginResult.Status.INVALID_ACTION);
                    callbackContext.sendPluginResult(res);
                    return false;
                }

                Intent i = ((DroidGap)this.cordova.getActivity()).getIntent();
                String uri = i.getDataString();

                callbackContext.success(uri);
                return true;

            } else if (action.equals("onNewIntent")) {
                if (args.length() != 0) {
                    PluginResult res = new PluginResult(PluginResult.Status.INVALID_ACTION);
                    callbackContext.sendPluginResult(res);
                    return false;
                }

                this.onNewIntentCallback = callbackContext;
                PluginResult res = new PluginResult(PluginResult.Status.NO_RESULT);
                res.setKeepCallback(true);
                callbackContext.sendPluginResult(res);
                return true;

            } else if (action.equals("sendBroadcast"))
            {
                if (args.length() != 1) {
                    PluginResult res = new PluginResult(PluginResult.Status.INVALID_ACTION);
                    callbackContext.sendPluginResult(res);
                    return false;
                }

                // Parse the arguments
                JSONObject obj = args.getJSONObject(0);

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

                sendBroadcast(obj.getString("action"), extrasMap);
                callbackContext.success();
                return true;

            }

            PluginResult res = new PluginResult(PluginResult.Status.INVALID_ACTION);
            callbackContext.sendPluginResult(res);
            return false;

        } catch (JSONException e) {
            callbackContext.error(e.getMessage());
            return false;
        }
    }

    @Override
    public void onNewIntent(Intent intent) {
        if (this.onNewIntentCallback != null) {
            this.onNewIntentCallback.success(intent.getDataString());
        }
    }

    void startActivity(String action, Uri uri, String type, Map<String, String> extras) {
        Intent i = (uri != null ? new Intent(action, uri) : new Intent(action));

        if (type != null && uri != null) {
            i.setDataAndType(uri, type); //Fix the crash problem with android 2.3.6
        } else {
            if (type != null) {
                i.setType(type);
            }
        }

        for (String key : extras.keySet()) {
            String value = extras.get(key);
            // If type is text html, the extra text must sent as HTML
            if (key.equals(Intent.EXTRA_TEXT) && type.equals("text/html")) {
                i.putExtra(key, Html.fromHtml(value));
            } else if (key.equals(Intent.EXTRA_STREAM)) {
                // allowes sharing of images as attachments.
                // value in this case should be a URI of a file
                i.putExtra(key, Uri.parse(value));
            } else if (key.equals(Intent.EXTRA_EMAIL)) {
                // allows to add the email address of the receiver
                i.putExtra(Intent.EXTRA_EMAIL, new String[] { value });
            } else {
                i.putExtra(key, value);
            }
        }
        ((DroidGap)this.cordova.getActivity()).startActivity(i);
    }

    void sendBroadcast(String action, Map<String, String> extras) {
        Intent intent = new Intent();
        intent.setAction(action);
        for (String key : extras.keySet()) {
            String value = extras.get(key);
            intent.putExtra(key, value);
        }

        ((DroidGap)this.cordova.getActivity()).sendBroadcast(intent);
    }
}
