/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2011, IBM Corporation
 */
package org.apache.cordova.plugins.barcodescanner;

import java.util.Hashtable;

import javax.microedition.media.Manager;
import javax.microedition.media.MediaException;
import javax.microedition.media.Player;
import javax.microedition.media.control.VideoControl;

import net.rim.device.api.system.Bitmap;
import net.rim.device.api.system.Display;
import net.rim.device.api.ui.Field;

import org.apache.cordova.plugins.barcodescanner.google.zxing.BinaryBitmap;
import org.apache.cordova.plugins.barcodescanner.google.zxing.LuminanceSource;
import org.apache.cordova.plugins.barcodescanner.google.zxing.MultiFormatReader;
import org.apache.cordova.plugins.barcodescanner.google.zxing.Result;
import org.apache.cordova.plugins.barcodescanner.google.zxing.common.HybridBinarizer;
import org.apache.cordova.util.Logger;

/**
 * BlackBerry OS 5 specific class containing barcode scanning related methods.
 * This class depends on the open source ZXing code also existing within the
 * application. Unlike OS 6, OS 5 does not provide ZXing built-in.
 */
class Scanner {
    private AdvancedMultimediaManager multimediaManager;
    private Player player = null;
    private ScanAction scannerScreen;
    private ScreenShot screenShot = null;
    private VideoControl videoControl = null;

    /**
     * Constructor which saves reference to the class providing the common
     * UI framework and scanner life cycle management.
     *
     * @param scannerScreen
     */
    Scanner(ScanAction scannerScreen) {
        this.scannerScreen = scannerScreen;
    }

    /**
     * Sets up the live video feed from the camera, initializes the UI
     * elements and starts the scanner thread.
     *
     * @param hints Hashtable of hints to pass to the scanner.
     */
    void startScan(Hashtable hints) {

        try {
            // Create a player that will show live video from the camera.
            player = Manager.createPlayer("capture://video");
            player.realize();

            multimediaManager = new AdvancedMultimediaManager();
            multimediaManager.setExposure(player);
            multimediaManager.setFlash(player);
            multimediaManager.setFocus(player);

            // Initialize the video control UI element.
            videoControl = (VideoControl) player.getControl("VideoControl");
            if (videoControl != null) {
                Field videoField = (Field) videoControl.initDisplayMode(
                        VideoControl.USE_GUI_PRIMITIVE,
                        "net.rim.device.api.ui.Field");

                videoControl.setDisplayFullScreen(true);
                videoControl.setVisible(true);

                // Add the live video feed to the UI.
                scannerScreen.add(videoField);

                player.start();
            } else {
                scannerScreen.error("Creation of videoControl failed");
                return;
            }
        } catch (Exception e) {
            scannerScreen.error(BarcodeScanner.TAG + ": " + e.getMessage());
            return;
        }

        // The scanner implementation in this class uses screen shots to
        // capture an image for analysis.  The screen shot API requires
        // permission from the user.  Perform a screen shot here to force a
        // permission prompt before the UI tries to load.
        Bitmap bitmap = new Bitmap(Display.getWidth(), Display.getHeight());
        Display.screenshot(bitmap);

        screenShot = new ScreenShot(hints);
        screenShot.start();
    }

    /**
     * Stops the scanner thread and frees resources associated with the live
     * video feed.
     */
    void stopScan() {
        try {
            if (screenShot != null && screenShot.isAlive()) {
                screenShot.stop();
                screenShot = null;
            }
            if (player != null) {
                player.stop();
                if (player.getState() != Player.CLOSED) {
                    player.close();
                    player = null;
                }
            }
        } catch (MediaException me) {
            Logger.log(BarcodeScanner.TAG + ": " + me.getMessage());
        }
    }

    /**
     * Provides the implementation of the scanner processing thread.
     */
    private class ScreenShot extends Thread {
        private MultiFormatReader reader;
        volatile boolean done = false;

        ScreenShot(Hashtable hints) {
            reader = new MultiFormatReader();
            reader.setHints(hints);
        }

        public void run() {
            // The live video field takes a few seconds to show up on the
            // display.  There does not appear to be an API to be notified
            // when the screen is fully loaded.  (It would need to be some point
            // after paint() is finished.)  The sleep here is a bit of a hack
            // but serves two purposes:
            //     1. Delays screen shots until live video field is visibile.
            //     2. Delays zoom until live video field is visible. Trying to
            //        zoom before the field is visible results in the max zoom
            //        being detected as 100 (no zoom).
            // The risk here is that the sleep time is likely device dependent.
            // The value (3s) is based on behavior noticed on a Torch.
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                Logger.log(BarcodeScanner.TAG + ": " + e.getMessage());
            }

            // Its possible that the scan was cancelled during sleep time so
            // only zoom if still scanning.
            if (!done) {
                multimediaManager.setZoom(player);
            }

            Bitmap bitmap = new Bitmap(Display.getWidth(), Display.getHeight());

            // Loop continuously until a barcode is decoded or the thread is
            // stopped.
            while (!done) {
                try {
                    // Take a screen shot of the display.  This method is used
                    // instead of using the camera snapshot because the camera
                    // snapshot method causes an audible shutter sound.  The
                    // drawback of this method is that on some phones
                    // auto-focusing does not adjust.
                    Display.screenshot(bitmap);

                    LuminanceSource source = new LuminanceSourceBitmap(bitmap);
                    BinaryBitmap binBitmap = new BinaryBitmap(
                            new HybridBinarizer(source));

                    Result result = reader.decodeWithState(binBitmap);

                    // decodeWithState() will throw an exception if no barcode
                    // was found so getting to this point means a barcode was
                    // decoded.
                    done = true;
                    scannerScreen.success(result.getBarcodeFormat().toString(),
                            result.getText());
                } catch (Exception e) {
                    // Ignore exception and continue scanning.
                }
            }
        }

        /**
         * Stops the scanning loop in the threads run method.
         */
        public void stop() {
            done = true;
        }
    }

}
