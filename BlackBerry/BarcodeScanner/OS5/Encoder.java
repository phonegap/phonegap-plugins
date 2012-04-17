/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2011, IBM Corporation
 */
package org.apache.cordova.plugins.barcodescanner;

import java.util.Hashtable;

import net.rim.device.api.system.Bitmap;

import org.apache.cordova.plugins.barcodescanner.google.zxing.BarcodeFormat;
import org.apache.cordova.plugins.barcodescanner.google.zxing.EncodeHintType;
import org.apache.cordova.plugins.barcodescanner.google.zxing.MultiFormatWriter;
import org.apache.cordova.plugins.barcodescanner.google.zxing.WriterException;
import org.apache.cordova.plugins.barcodescanner.google.zxing.common.BitMatrix;

/**
 * BlackBerry OS 5 specific class containing barcode encoding related methods.
 * This class depends on the open source ZXing code also existing within the
 * application. Unlike OS 6, OS 5 does not provide ZXing built-in.
 */
class Encoder {

    static String QR_CODE = BarcodeFormat.QR_CODE.toString();

    /**
     * Static method which encodes a string and returns the result as a Bitmap.
     *
     * @param format
     *            type of barcode format to generate.
     * @param text
     *            the text to encode.
     * @param width
     *            desired width in pixels of the resulting bitmap.
     * @param height
     *            desired height in pixels of the resulting bitmap.
     * @return a Bitmap containing the generated barcode for the specified text.
     * @throws WriterException
     */
    static Bitmap createBitmap(String format, String text, int width,
            int height) throws WriterException {
        Hashtable hints = new Hashtable();
        // Assuming UTF-8 since text is passed via JSON.
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");

        MultiFormatWriter writer = new MultiFormatWriter();
        BitMatrix result = writer.encode(text, BarcodeFormat.valueOf(format),
            width, height, hints);

        width = result.getWidth();
        height = result.getHeight();

        // Create a new bitmap which will be filled pixel by pixel from the
        // generated BitMatrix.
        Bitmap bitmap = new Bitmap(width, height);

        // An integer array to hold a row of bitmap pixels at a time.
        int[] pixels = new int[width];

        // Loop through the generated BitMatrix and fill the Bitmap.
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                // Pixel needs to be black (0xFF000000) or white (0xFFFFFFFF)
                pixels[x] = result.get(x, y) ? 0xFF000000 : 0xFFFFFFFF;
            }
            bitmap.setARGB(pixels, 0, width, 0, y, width, 1);
        }

        return bitmap;
    }

}
