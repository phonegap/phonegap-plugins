/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2011, IBM Corporation
 */
package org.apache.cordova.plugins.barcodescanner;

import net.rim.device.api.ui.UiApplication;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.apache.cordova.json4j.JSONArray;

/**
 * The BarcodeScanner plugin interface.
 *
 * The BarcodeScanner class can invoke the following actions:
 *
 *      scan: Launches a UI showing a live video feed from the camera and scans
 *            for barcodes.  If a barcode is detected and decoded the text is
 *            returned.
 *      encode: Encodes text data into a barcode image.
 */
public class BarcodeScanner extends Plugin {

    private static String ACTION_SCAN = "scan";
    private static String ACTION_ENCODE = "encode";
    static String TAG = "BarcodeScanner";

    private ScanAction scanner = null;
    private Thread scanThread = null;
    private Object lock = new Object();

    private UiApplication uiApp = UiApplication.getUiApplication();

    /**
     * Executes the requested action and returns a PluginResult.
     *
     * @param action
     *            The action to execute.
     * @param callbackId
     *            The callback ID to be invoked upon action completion.
     * @param args
     *            JSONArry of arguments for the action.
     * @return A PluginResult object with a status and message.
     */
    public PluginResult execute(String action, JSONArray args, String callbackId) {
        PluginResult result = null;

        if (ACTION_SCAN.equals(action)) {

            synchronized (lock) {
                // Only allow one active invocation of the scanner.
                if (scanner == null || !scanner.isDisplayed()) {
                    scanner = new ScanAction(callbackId, uiApp);

                    // Ensure that UI changes are done on event thread.
                    scanThread = new Thread(scanner);
                    scanThread.start();

                    result = new PluginResult(PluginResult.Status.NO_RESULT);
                    result.setKeepCallback(true);
                } else {
                    result = new PluginResult(PluginResult.Status.ERROR,
                            "Scanner already on display stack.");
                }
            }
        } else if (ACTION_ENCODE.equals(action)) {
            EncodeAction encoder = new EncodeAction();
            result = encoder.encode(args);
        } else {
            result = new PluginResult(PluginResult.Status.INVALID_ACTION,
                    TAG + ": Invalid action:" + action);
        }

        return result;
    }

    /**
     * Called when Plugin is paused.
     */
    public void onPause() {
        synchronized (lock) {
            if (scanner != null) {
                scanner.stop();
                scanner = null;
            }
        }
    }

}
