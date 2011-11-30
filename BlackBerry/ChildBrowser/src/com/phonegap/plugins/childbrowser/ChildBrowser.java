/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2005-2011, Nitobi Software Inc.
 * Copyright (c) 2010-2011, IBM Corporation
 */
package com.phonegap.plugins.childbrowser;

import net.rim.blackberry.api.browser.Browser;
import net.rim.blackberry.api.browser.BrowserSession;
import net.rim.device.api.ui.UiApplication;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;
import com.phonegap.json4j.JSONArray;
import com.phonegap.json4j.JSONException;
import com.phonegap.json4j.JSONObject;
import com.phonegap.util.Logger;

/**
 * The ChildBrowser plug-in. This class provides the ability to load external
 * web sites in a custom view or the devices browser.  URLs loaded by this
 * plugin are not restricted by the whitelist.
 *
 *      showWebPage  - Open a URL in a custom browser view.
 *      close        - Close a previously opened custom browser.
 *      openExternal - Load a URL in the device's browser.
 */
public class ChildBrowser extends Plugin {
    protected final static String TAG = "ChildBrowser: ";

    // Supported actions
    private final static String ACTION_SHOW_WEBPAGE = "showWebPage";
    private final static String ACTION_CLOSE = "close";
    private final static String ACTION_EXTERNAL = "openExternal";

    private String callbackId = null;
    private static CustomBrowser browser = null;

    private UiApplication uiApp = UiApplication.getUiApplication();

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action
     *            The action to execute.
     * @param args
     *            JSONArry of arguments for the plugin.
     * @param callbackId
     *            The callback id used when calling back into JavaScript.
     * @return A PluginResult object with a status and message.
     */
    public PluginResult execute(String action, JSONArray args, String callbackId) {
        PluginResult result;

        if (ACTION_SHOW_WEBPAGE.equals(action)) {
            this.callbackId = callbackId;
            result = showWebPage(args);
        } else if (ACTION_CLOSE.equals(action)) {
            result = closeBrowser();
        } else if (ACTION_EXTERNAL.equals(action)) {
            result = openExternal(args);
        } else {
            result = new PluginResult(PluginResult.Status.INVALID_ACTION, TAG
                    + "Invalid action: " + action);
        }

        return result;
    }

    static synchronized void clearBrowser() {
        browser = null;
    }

    /**
     * Close a custom browser screen.
     *
     * @return a PluginResult
     */
    private synchronized PluginResult closeBrowser() {
        JSONObject obj = null;

        if (browser != null && browser.isDisplayed()) {
            uiApp.invokeAndWait(new Runnable() {
                public void run() {
                    try {
                        uiApp.popScreen(browser);
                    } catch (IllegalArgumentException e) {
                        Logger.log(ChildBrowser.TAG
                                + ": Caught illegal argument exception: "
                                + e.getMessage());
                    }
                }
            });
            browser = null;

            obj = new JSONObject();
            try {
                obj.put("type", CustomBrowser.CLOSE_EVENT);
            } catch (JSONException e) {
                return new PluginResult(PluginResult.Status.JSON_EXCEPTION);
            }
        }

        return new PluginResult(PluginResult.Status.OK, obj);
    }

    /**
     * Load an URL in the device's browser application.
     *
     * @param args
     *            JSONArry of arguments for the action.
     * @return a PluginResult
     */
    private PluginResult openExternal(JSONArray args) {
        try {
            String url = args.getString(0);

            BrowserSession session = Browser.getDefaultSession();
            session.displayPage(url);
        } catch (JSONException e) {
            return new PluginResult(PluginResult.Status.JSON_EXCEPTION);
        }

        return new PluginResult(PluginResult.Status.OK, "");
    }

    /**
     * Display the specified URL in a custom browser screen.
     *
     * @param args
     *            JSONArry of arguments for the action.
     * @return a PluginResult
     */
    private synchronized PluginResult showWebPage(JSONArray args) {
        PluginResult result;

        if (browser == null) {
            try {
                boolean showLocationBar = true;
                String url = args.getString(0);
                JSONObject options = args.getJSONObject(1);

                // Determine whether to show or hide navigation bar.
                if (options != null) {
                    showLocationBar = options.optBoolean("showLocationBar",
                            true);
                }

                browser = new CustomBrowser(callbackId);
                if (browser.init(showLocationBar)) {
                    uiApp.invokeLater(new Runnable() {
                        public void run() {
                            uiApp.pushScreen(browser);
                        }
                    });

                    browser.loadURL(url);

                    // Must keep the callback for browser URL load and close
                    // events.
                    result = new PluginResult(PluginResult.Status.OK, "");
                    result.setKeepCallback(true);
                } else {
                    result = new PluginResult(PluginResult.Status.ERROR, TAG
                            + "Failed to initialize CustomBrowser.");
                }
            } catch (JSONException e) {
                return new PluginResult(PluginResult.Status.JSON_EXCEPTION);
            }
        } else {
            result = new PluginResult(PluginResult.Status.ERROR,
                    "ChildBrowser is already open.");
        }

        return result;
    }
}
