/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2005-2011, Nitobi Software Inc.
 * Copyright (c) 2010-2011, IBM Corporation
 */
package com.phonegap.plugins.childbrowser;

import net.rim.device.api.browser.field.ContentReadEvent;
import net.rim.device.api.browser.field2.BrowserField;
import net.rim.device.api.browser.field2.BrowserFieldConfig;
import net.rim.device.api.browser.field2.BrowserFieldHistory;
import net.rim.device.api.browser.field2.BrowserFieldListener;
import net.rim.device.api.script.ScriptEngine;
import net.rim.device.api.system.Characters;
import net.rim.device.api.ui.UiApplication;
import net.rim.device.api.ui.container.MainScreen;
import net.rim.device.api.ui.container.VerticalFieldManager;

import org.w3c.dom.Document;

import com.phonegap.PhoneGapExtension;
import com.phonegap.api.PluginResult;
import com.phonegap.json4j.JSONException;
import com.phonegap.json4j.JSONObject;
import com.phonegap.util.Logger;

/**
 * A custom browser screen.  Contains an optional navigation bar at the top of
 * the screen with a scrollable browser field below it.
 */
public class CustomBrowser extends MainScreen {
    // Event types that can be returned to caller.
    static final int CLOSE_EVENT = 0;
    static final int LOCATION_CHANGED_EVENT = 1;

    private BrowserField browserField = null;
    private String callbackId;
    private NavigationBar navBar = null;

    /**
     * Constructor to create a custom browser which uses all the available
     * height and width on the device.
     *
     * @param callbackId
     *            the call back identifier.
     */
    CustomBrowser(String callbackId) {
        super(USE_ALL_HEIGHT | USE_ALL_WIDTH);
        this.callbackId = callbackId;
    }

    /**
     * On browser close, notify the caller of the close event.
     *
     * @see net.rim.device.api.ui.Screen#close()
     */
    public void close() {
        ChildBrowser.clearBrowser();
        try {
            JSONObject obj = new JSONObject();
            obj.put("type", CLOSE_EVENT);

            sendUpdate(obj, false);
        } catch (JSONException e) {
            Logger.log(ChildBrowser.TAG + "JSONException " + e.getMessage());
        }

        super.close();
    }

    /**
     * OS5 Non-touchscreen devices have an issue where UI elements cannot regain
     * focus after a BrowserField acquires focus when NAVIGATION_MODE_POINTER is
     * used. On these devices invokeAction() is called when the navigation wheel
     * is clicked outside of the BrowserField. So, in order to set focus to the
     * navigation bar on these devices, this method is overridden and focus is
     * set to the navigation bar should the event occur.
     *
     * @see net.rim.device.api.ui.Screen#invokeAction(int)
     */
    public boolean invokeAction(final int action) {
        if (action == ACTION_INVOKE && navBar != null) {
            UiApplication.getUiApplication().invokeLater(new Runnable() {
                public void run() {
                    navBar.setFocus();
                }
            });
            return true;
        }

        return super.invokeAction(action);
    }

    /**
     * Override the handling of the back button to navigate back in history.
     * Also, display the stop load button in the navigation bar if it is active.
     *
     * @see net.rim.device.api.ui.Screen#keyChar(char, int, int)
     */
    protected boolean keyChar(char key, int status, int time) {
        boolean consumedByChild = super.keyChar(key, status, time);
        if (!consumedByChild && key == Characters.ESCAPE && browserField != null) {
            BrowserFieldHistory history = browserField.getHistory();
            if (history != null && history.canGoBack()) {
                if (navBar != null) {
                    navBar.setRefreshActive(false);
                }
                UiApplication.getUiApplication().invokeLater(new Runnable() {
                    public void run() {
                        browserField.setFocus();
                        browserField.back();
                    }
                });
                return true;
            }
        }
        return consumedByChild;
    }

    /**
     * Sets up the custom browser screen. Initializes configuration and adds
     * elements to the screen.
     *
     * @param showNavBar
     *            boolean value indicating whether to display navigation bar or
     *            not.
     * @return true if init succeeds, false otherwise.
     */
    boolean init(boolean showNavBar) {
        // Setup a browser configuration which will produce a BrowserField with
        // desired features.
        BrowserFieldConfig config = new BrowserFieldConfig();
        config.setProperty(BrowserFieldConfig.ALLOW_CS_XHR, Boolean.TRUE);
        config.setProperty(BrowserFieldConfig.ENABLE_COOKIES, Boolean.TRUE);
        config.setProperty(BrowserFieldConfig.ENABLE_GEARS, Boolean.FALSE);
        config.setProperty(BrowserFieldConfig.INITIAL_SCALE, new Float(1.0));
        config.setProperty(BrowserFieldConfig.JAVASCRIPT_ENABLED, Boolean.TRUE);
        config.setProperty(BrowserFieldConfig.NAVIGATION_MODE,
                BrowserFieldConfig.NAVIGATION_MODE_POINTER);
        config.setProperty(BrowserFieldConfig.MDS_TRANSCODING_ENABLED,
                Boolean.FALSE);
        // config.setProperty(BrowserFieldConfig.USER_SCALABLE, Boolean.FALSE);
        // config.setProperty(BrowserFieldConfig.VIEWPORT_WIDTH, new Integer(
        // Display.getWidth()));

        browserField = new BrowserField(config);

        // Add a listener to the BrowserField which sends LOCATION_CHANGED_EVENT
        // on document load and manages the elements in the navigation bar if it
        // is active.
        browserField.addListener(new BrowserFieldListener() {
            public void documentCreated(BrowserField browserField,
                    ScriptEngine scriptEngine, Document document)
                    throws Exception {
                if ((browserField != null) && (document != null)) {
                    String url = document.getBaseURI();
                    if (navBar != null) {
                        navBar.setURL(url);
                        navBar.setRefreshActive(false);
                    }
                    try {
                        JSONObject obj = new JSONObject();
                        obj.put("type", LOCATION_CHANGED_EVENT);
                        obj.put("location", url);

                        sendUpdate(obj, true);
                    } catch (JSONException e) {
                        Logger.log(ChildBrowser.TAG + "JSONException: "
                                + e.getMessage());
                    }
                }
                super.documentCreated(browserField, scriptEngine, document);
            };

            public void documentLoaded(BrowserField browserField,
                    Document document) throws Exception {
                if (navBar != null) {
                    navBar.setURL(browserField.getDocumentUrl());
                    navBar.setRefreshActive(true);
                }
                super.documentLoaded(browserField, document);
            };

            public void downloadProgress(BrowserField browserField,
                    ContentReadEvent event) throws Exception {
                super.downloadProgress(browserField, event);
            };
        });

        // Create and add the navigation bar if necessary.
        if (showNavBar) {
            navBar = new NavigationBar(browserField);
            if (!navBar.init()) {
                return false;
            }
            add(navBar);
        }

        // Create a VerticalFieldManager which will contain the BrowserField.
        // Enables scrolling in all directions, manages the back button to
        // navigate browser history and manages display of elements in
        // navigation bar if it is active.
        VerticalFieldManager vfm = new VerticalFieldManager(VERTICAL_SCROLL
                | HORIZONTAL_SCROLL | HORIZONTAL_SCROLLBAR | VERTICAL_SCROLLBAR) {
            protected boolean keyChar(char key, int status, int time) {
                if (key == Characters.ESCAPE && browserField != null) {
                    BrowserFieldHistory history = browserField.getHistory();
                    if (history != null && history.canGoBack()) {
                        if (navBar != null) {
                            navBar.setRefreshActive(false);
                        }
                        UiApplication.getUiApplication().invokeLater(
                                new Runnable() {
                                    public void run() {
                                        browserField.setFocus();
                                        browserField.back();
                                    }
                                });
                        return true;
                    }
                }

                return super.keyChar(key, status, time);
            }

            protected void onFocus(int direction) {
                if (navBar != null) {
                    navBar.showFullNav(true);
                }
                super.onFocus(direction);
            }
        };
        vfm.add(browserField);

        add(vfm);

        return true;
    }

    /**
     * Load the specified URL in the browser.
     *
     * @param url
     *            the URL to load.
     */
    void loadURL(String url) {
        if (url != null && url.length() > 0) {
            if (!url.startsWith("http")) {
                url = "http://" + url;
            }

            if (navBar != null) {
                navBar.setURL(url);
            }
            browserField.requestContent(url);
        }
    }

    /**
     * Create a new plugin result and send it back to JavaScript
     *
     * @param obj
     *            a JSONObject containing event payload information
     */
    private void sendUpdate(JSONObject obj, boolean keepCallback) {
        if (callbackId != null) {
            PluginResult result = new PluginResult(PluginResult.Status.OK, obj);
            result.setKeepCallback(keepCallback);
            PhoneGapExtension.invokeSuccessCallback(callbackId, result);
        }
    }
}
