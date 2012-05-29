package com.phonegap.plugin.macaddress;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.net.wifi.WifiManager;

/**
 * The Class MacAddressPlugin.
 */
public class MacAddressPlugin extends Plugin {

    @Override
    public boolean isSynch(String action) {
        if (action.equals("getMacAddress")) {
            return true;
        }
        return false;
    }
    
    /* (non-Javadoc)
     * @see org.apache.cordova.api.Plugin#execute(java.lang.String, org.json.JSONArray, java.lang.String)
     */
    @Override
    public PluginResult execute(String action, JSONArray args, String callbackId) {
        PluginResult result = null;


        if (action.equals("getMacAddress")) {

            String macAddress = this.getMacAddress();
 
            if (macAddress != null) {
                JSONObject JSONresult = new JSONObject();
                try {
                    JSONresult.put("mac", macAddress);
                    result = new PluginResult(PluginResult.Status.OK, JSONresult);
                } catch (JSONException jsonEx) {
         
                    result = new PluginResult(PluginResult.Status.JSON_EXCEPTION);
                }

            }
        }
        
        return result;
    }

    /**
     * Gets the mac address.
     * 
     * @return the mac address
     */
    private String getMacAddress() {
        String macAddress = null;
        WifiManager wm = (WifiManager) this.ctx.getSystemService(Context.WIFI_SERVICE);
        macAddress = wm.getConnectionInfo().getMacAddress();

        if (macAddress == null || macAddress.length() == 0) {
            macAddress = "00:00:00:00:00:00";
        }

        return macAddress;
    }
}
