/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2011, IBM Corporation
 */
package org.apache.cordova.plugins.barcodescanner;

import java.util.Hashtable;

import javax.microedition.media.MediaException;
import javax.microedition.media.Player;

import net.rim.device.api.system.Bitmap;

import org.apache.cordova.util.Logger;

import net.rim.device.api.barcodelib.BarcodeDecoder;
import net.rim.device.api.barcodelib.BarcodeDecoderListener;
import net.rim.device.api.barcodelib.BitmapLuminanceSource;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.LuminanceSource;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.ReaderException;
import com.google.zxing.Result;
import com.google.zxing.common.LocalBlockBinarizer;

/**
 * BlackBerry OS 6 specific class containing barcode scanning related methods.
 * Uses the built-in implementation of ZXing provided in OS 6.
 */
class Scanner {
    private net.rim.device.api.barcodelib.BarcodeScanner scanner;
    private ScanAction scannerScreen;
    private String barcodeFormat = null;

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
     * elements and starts the scanner.
     *
     * @param hints Hashtable of hints to pass to the scanner.
     */
    void startScan(Hashtable hints) {

        // If information about the format of barcode that was decoded is
        // necessary then use FormatBarcodeDecoder instead of BarcodeDecoder.
        // FormatBarcodeDecoder decoder = new FormatBarcodeDecoder(hints);
        BarcodeDecoder decoder = new BarcodeDecoder(hints);

        BarcodeDecoderListener decoderListener = new BarcodeDecoderListener() {
            public void barcodeDecoded(String rawText) {
                scannerScreen.success(barcodeFormat, rawText);
            }
        };

        try {
            scanner = new net.rim.device.api.barcodelib.BarcodeScanner(decoder,
                    decoderListener);
            scanner.getVideoControl().setDisplayFullScreen(true);
            scannerScreen.add(scanner.getViewfinder());
            scanner.startScan();
        } catch (Exception e) {
            scannerScreen.error(BarcodeScanner.TAG + ": " + e.getMessage());
        }
    }

    /**
     * Stops the scanner thread and frees resources associated with the live
     * video feed.
     */
    void stopScan() {
        if (scanner != null) {
            try {
                scanner.stopScan();
                Player player = scanner.getPlayer();

                // Need to close the player to free resources.
                if (player != null && player.getState() != Player.CLOSED) {
                    player.close();
                }
            } catch (MediaException me) {
                Logger.log(BarcodeScanner.TAG + ": " + me.getMessage());
            }
        }
    }

    /**
     * This class is a bit of a hack in order to determine what type of barcode
     * format was detected.  The BarcodeDecoderListener class simply passes
     * back the decoded text and does not inform which format was decoded.  This
     * class can be used in lieu of BarcodeDecoder if format information is
     * required but it does carry some risk as described in the comment for the
     * decode() method.
     */
    private class FormatBarcodeDecoder extends BarcodeDecoder {
        private MultiFormatReader reader;

        FormatBarcodeDecoder(Hashtable hints) {
            super(hints);
            reader = new MultiFormatReader();
            reader.setHints(hints);
        }

        /**
         * The OS 6 API does not document the methods provided by BarcodeDecoder
         * but by looking at the OS 7 API documentation and through
         * experimentation it was determined that the decode() API is called to
         * decode barcodes. Even though this class extends BarcodeDecoder it is
         * not possible to invoke its decode() method since it is not exposed in
         * the OS 6 API (though it is in OS 7). The risk of implementing our own
         * decode here is that enhancements made in future OS may not be picked
         * up.
         *
         * @param bitmap
         *            the image to decode.
         * @return a Result object if a barcode was successfully decoded,
         *         otherwise, null.
         */
        public Object decode(Bitmap bitmap) {
            LuminanceSource source = new BitmapLuminanceSource(bitmap);

            // This really should be HybridBinarizer but its not available
            // in OS 6.
            BinaryBitmap binBitmap = new BinaryBitmap(new LocalBlockBinarizer(
                    source));

            Result result = null;
            try {
                result = reader.decodeWithState(binBitmap);
            } catch (ReaderException e) {
                Logger.log("Decode with state failed: " + e.getMessage());
            }

            if (result != null) {
                setBarcodeFormat(result);
            }

            return result;
        }

        /**
         * The BlackBerry API have names for the barcode formats without the
         * underscore character whereas the ZXing 1.7 release uses underscores.
         * This method returns a string version of the format to match ZXing 1.7.
         * @param result
         */
        private void setBarcodeFormat(Result result) {
            BarcodeFormat format = result.getBarcodeFormat();

            if (format == BarcodeFormat.DATAMATRIX) {
                barcodeFormat = "DATA_MATRIX";
            } else if (format == BarcodeFormat.PDF417) {
                barcodeFormat = "PDF_417";
            } else {
                String tmp = format.toString();
                if (tmp.equals("RSS14")) {
                    barcodeFormat = "RSS_14";
                } else {
                    barcodeFormat = tmp;
                }
            }
        }
    }
}
