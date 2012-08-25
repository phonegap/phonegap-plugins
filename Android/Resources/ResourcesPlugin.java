package com.phonegap.plugin.resources;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.apache.cordova.api.PluginResult.Status;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ResourcesPlugin extends Plugin {
    /*
     * (non-Javadoc)
     * 
     * @see com.phonegap.api.Plugin#isSynch(java.lang.String)
     */
    @Override
    public boolean isSynch(String action) {
        if (action.equals("getStringResources")) {
            return true;
        }
        return false;
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.phonegap.api.Plugin#execute(java.lang.String,
     * org.json.JSONArray, java.lang.String)
     */
    @Override
    public PluginResult execute(String action, JSONArray args, String callbackId) {
        PluginResult result = null;

        if (action.equals("getStringResources")) {

            JSONObject obj = null;
            JSONArray resourceNames = null;
            String pkg = null;

            try {
                obj = args.getJSONObject(0);
                if (obj != null) {
                    resourceNames = obj.has("resources") ? obj.getJSONArray("resources") : null;
                    pkg = obj.has("package") ? obj.getString("package") : ctx.getPackageName();
                }

                if (resourceNames != null && resourceNames.length() > 0 && pkg != null) {

                    JSONObject JSONresult = new JSONObject();

                    JSONObject resources = new JSONObject();

                    for (int nbElem = 0; nbElem < resourceNames.length(); nbElem++) {
                        resources.put(resourceNames.getString(nbElem),
                                this.getStringResource(resourceNames.getString(nbElem), pkg));
                    }

                    JSONresult.put("resources", resources);

                    result = new PluginResult(Status.OK, JSONresult);
                }

            } catch (JSONException jsonEx) {
                result = new PluginResult(Status.JSON_EXCEPTION);
            }
        }

        return result;
    }


    /**
     * Gets the string resource for a given package
     * 
     * @param name
     *            the name
     * @param packageName
     *            the package name
     * @return the string resource
     */
    private String getStringResource(String name, String packageName) {
        String resource = null;
        int id = ctx.getResources().getIdentifier(name, "string", packageName);
        if (id != 0) {
            resource = ctx.getContext().getString(id);
   
        } 

        return resource;
    }


}
