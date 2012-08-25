/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2011, IBM Corporation
 */
package org.apache.cordova.plugins.barcodescanner;

import java.util.Hashtable;

import net.rim.device.api.system.Characters;
import net.rim.device.api.ui.Color;
import net.rim.device.api.ui.UiApplication;
import net.rim.device.api.ui.container.FullScreen;
import net.rim.device.api.ui.decor.BackgroundFactory;

import org.apache.cordova.CordovaExtension;
import org.apache.cordova.api.PluginResult;
import org.apache.cordova.json4j.JSONException;
import org.apache.cordova.json4j.JSONObject;
import org.apache.cordova.util.Logger;

/**
 * Handles the common code for the barcode scan action. Implements life cycle
 * management of a UI screen and invokes the OS specific implementation for the
 * actual UI management.
 */
class ScanAction extends FullScreen implements Runnable {

    private String callbackId;
    private Hashtable hints = new Hashtable();
    private Scanner scanner;
    private UiApplication uiApp;

    ScanAction(String callbackId, UiApplication uiApp) {
        this.callbackId = callbackId;
        this.uiApp = uiApp;

        // Setting the background to black removes a flash of a white screen
        // before the scanner screen loads.
        setBackground(BackgroundFactory.createSolidBackground(Color.BLACK));
    }

    /**
     * @see net.rim.device.api.ui.Screen#close()
     */
    public void close() {
        stop();

        super.close();
    }

    /**
     * @see java.lang.Runnable#run()
     */
    public void run() {

        // Create an instance of the OS specific scanner implementation.
        scanner = new Scanner(this);

        // Must start the scanner before pushing to the screen. Starting
        // the scanner will cause a permission prompt to occur.
        // If the screen is pushed first then the permission prompt
        // gets put in the background and the scan will hang the UI.
        scanner.startScan(hints);

        uiApp.invokeLater(new Runnable() {
            public void run() {
                uiApp.pushScreen(ScanAction.this);
            }
        });
    }

    /**
     * @see net.rim.device.api.ui.Screen#keyChar(char, int, int)
     */
    protected boolean keyChar(char key, int status, int time) {
        if (key == Characters.ESCAPE) {
            stop();
        }

        // Store the retrieved properties in a JSON object.
        JSONObject barcodeInfo = new JSONObject();
        try {
            barcodeInfo.put("text", null);
            barcodeInfo.put("format", null);
            barcodeInfo.put("cancelled", true);
        } catch (JSONException e) {
            Logger.error("JSONException: " + e.getMessage());
            return super.keyChar(key, status, time);
        }

        CordovaExtension.invokeSuccessCallback(callbackId, new PluginResult(
                PluginResult.Status.OK, barcodeInfo));

        return super.keyChar(key, status, time);
    }

    /**
     * Helper routine to handle error condition reporting and stop the scan UI.
     *
     * @param text
     *            the error text to return.
     */
    void error(final String text) {
        stop();

        CordovaExtension.invokeErrorCallback(callbackId, new PluginResult(
                PluginResult.Status.ERROR, text));
    }

    /**
     * Stops the OS specific scanner implementation and pops the screen.
     */
    synchronized void stop() {
        scanner.stopScan();

        if (isDisplayed()) {
            uiApp.invokeLater(new Runnable() {
                public void run() {
                    try {
                        uiApp.popScreen(ScanAction.this);
                    } catch (IllegalArgumentException e) {
                        Logger.log(BarcodeScanner.TAG
                                + ": Caught illegal argument exception: "
                                + e.getMessage());
                    }
                }
            });
        }
    }

    /**
     * Helper routine to handle success condition reporting and stop the scan
     * UI.
     *
     * @param format
     *            the type of barcode that was decoded.
     * @param text
     *            the decoded barcode text to return.
     */
    void success(final String format, final String text) {
        stop();

        // Store the retrieved properties in a JSON object.
        JSONObject barcodeInfo = new JSONObject();
        try {
            barcodeInfo.put("format", format);
            barcodeInfo.put("text", text);
            barcodeInfo.put("cancelled", false);
        } catch (JSONException e) {
            Logger.error("JSONException: " + e.getMessage());
            return;
        }

        CordovaExtension.invokeSuccessCallback(callbackId, new PluginResult(
                PluginResult.Status.OK, barcodeInfo));
    }
}
