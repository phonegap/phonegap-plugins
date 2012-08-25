/**
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) Matt Kane 2010
 * Copyright (c) 2011, IBM Corporation
 */

package com.phonegap.plugins.barcodescanner;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;

/**
 * This calls out to the ZXing barcode reader and returns the result.
 */
public class BarcodeScanner extends Plugin {
    private static final String TEXT_TYPE = "TEXT_TYPE";
    private static final String EMAIL_TYPE = "EMAIL_TYPE";
    private static final String PHONE_TYPE = "PHONE_TYPE";
    private static final String SMS_TYPE = "SMS_TYPE";

    public static final int REQUEST_CODE = 0x0ba7c0de;

    public String callback;

    /**
     * Constructor.
     */
    public BarcodeScanner() {
    }

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action        The action to execute.
     * @param args          JSONArray of arguments for the plugin.
     * @param callbackId    The callback id used when calling back into JavaScript.
     * @return              A PluginResult object with a status and message.
     */
    public PluginResult execute(String action, JSONArray args, String callbackId) {
        this.callback = callbackId;

        if (action.equals("encode")) {
            JSONObject obj = args.optJSONObject(0);
            if (obj != null) {
                String type = obj.optString("type");
                String data = obj.optString("data");
                
                // If the type is null then force the type to text
                if (type == null) {
                    type = TEXT_TYPE;
                }
                
                if (data == null) {
                    return new PluginResult(PluginResult.Status.ERROR, "User did not specify data to encode");                                            
                }
                
                encode(type, data);                    
            } else {
                return new PluginResult(PluginResult.Status.ERROR, "User did not specify data to encode");                    
            }
        }
        else if (action.equals("scan")) {
            scan();
        } else {
            return new PluginResult(PluginResult.Status.INVALID_ACTION);
        }
        PluginResult r = new PluginResult(PluginResult.Status.NO_RESULT);
        r.setKeepCallback(true);
        return r;
    }


    /**
     * Starts an intent to scan and decode a barcode.
     */
    public void scan() {
        Intent intentScan = new Intent("com.phonegap.plugins.barcodescanner.SCAN");
        intentScan.addCategory(Intent.CATEGORY_DEFAULT);

        this.ctx.startActivityForResult((Plugin) this, intentScan, REQUEST_CODE);
    }

    /**
     * Called when the barcode scanner intent completes
     *
     * @param requestCode       The request code originally supplied to startActivityForResult(),
     *                          allowing you to identify who this result came from.
     * @param resultCode        The integer result code returned by the child activity through its setResult().
     * @param intent            An Intent, which can return result data to the caller (various data can be attached to Intent "extras").
     */
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                JSONObject obj = new JSONObject();
                try {
                    obj.put("text", intent.getStringExtra("SCAN_RESULT"));
                    obj.put("format", intent.getStringExtra("SCAN_RESULT_FORMAT"));
                    obj.put("cancelled", false);
                } catch(JSONException e) {
                    //Log.d(LOG_TAG, "This should never happen");
                }
                this.success(new PluginResult(PluginResult.Status.OK, obj), this.callback);
            } if (resultCode == Activity.RESULT_CANCELED) {
                JSONObject obj = new JSONObject();
                try {
                    obj.put("text", "");
                    obj.put("format", "");
                    obj.put("cancelled", true);
                } catch(JSONException e) {
                    //Log.d(LOG_TAG, "This should never happen");
                }
                this.success(new PluginResult(PluginResult.Status.OK, obj), this.callback);
            } else {
                this.error(new PluginResult(PluginResult.Status.ERROR), this.callback);
            }
        }
    }

    /**
     * Initiates a barcode encode. 
     * @param data  The data to encode in the bar code
     * @param data2 
     */
    public void encode(String type, String data) {
        Intent intentEncode = new Intent("com.phonegap.plugins.barcodescanner.ENCODE");
        intentEncode.putExtra("ENCODE_TYPE", type);
        intentEncode.putExtra("ENCODE_DATA", data);
        
        this.ctx.startActivity(intentEncode);
    }
}