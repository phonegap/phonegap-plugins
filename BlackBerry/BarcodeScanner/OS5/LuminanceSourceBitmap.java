/*
 * Copyright 2009 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * This class is based off of a file provided in the ZXing javame implementation:
 *
 *     javame/src/com/google/zxing/client/j2me/LCDUIImageLuminanceSource.java
 *
 * The class was renamed to LuminanceSourceBitmap and minor modifications were
 * made (denoted by BB: prefix in comment) to allow the file to work on
 * BlackBerry.
 */
// BB: Package the file local to the plugin.
package org.apache.cordova.plugins.barcodescanner;

import org.apache.cordova.plugins.barcodescanner.google.zxing.LuminanceSource;

//BB: Use Bitmap instead of Image
import net.rim.device.api.system.Bitmap;

/**
 * A LuminanceSource based on Java ME's Image class. It does not support
 * cropping or rotation.
 *
 * @author dswitkin@google.com (Daniel Switkin)
 * @author Sean Owen
 */
public final class LuminanceSourceBitmap extends LuminanceSource {
    // BB: Use Bitmap instead of Image
    private final Bitmap image;
    private int[] rgbData;

    public LuminanceSourceBitmap(Bitmap image) {
        super(image.getWidth(), image.getHeight());
        this.image = image;
    }

    // Instead of multiplying by 306, 601, 117, we multiply by 256, 512, 256, so that
    // the multiplies can be implemented as shifts.
    //
    // Really, it's:
    //
    // return ((((pixel >> 16) & 0xFF) << 8) +
    //         (((pixel >>  8) & 0xFF) << 9) +
    //         (( pixel        & 0xFF) << 8)) >> 10;
    //
    // That is, we're replacing the coefficients in the original with powers of two,
    // which can be implemented as shifts, even though changing the coefficients slightly
    // alters the conversion. The difference is not significant for our purposes.
    public byte[] getRow(int y, byte[] row) {
        if (y < 0 || y >= getHeight()) {
            throw new IllegalArgumentException(
                    "Requested row is outside the image: " + y);
        }
        int width = getWidth();
        if (row == null || row.length < width) {
            row = new byte[width];
        }

        if (rgbData == null || rgbData.length < width) {
            rgbData = new int[width];
        }
        // BB: Use getARGB as replacement for getRGB
        image.getARGB(rgbData, 0, width, 0, y, width, 1);
        for (int x = 0; x < width; x++) {
            row[x] = toLuminance(rgbData[x]);
        }
        return row;
    }

    public byte[] getMatrix() {
        int width = getWidth();
        int height = getHeight();
        int area = width * height;
        byte[] matrix = new byte[area];

        int[] rgb = new int[area];
        // BB: Use getARGB as replacement for getRGB
        image.getARGB(rgb, 0, width, 0, 0, width, height);
        for (int y = 0; y < height; y++) {
            int offset = y * width;
            for (int x = 0; x < width; x++) {
                matrix[offset + x] = toLuminance(rgb[offset + x]);
            }
        }
        return matrix;

    }

    public boolean isRotateSupported() {
        return true;
    }

    public LuminanceSource rotateCounterClockwise() {
        return new CCRotatedLuminanceSourceBitmap(image);
    }

    static byte toLuminance(int pixel) {
        return (byte) ((((pixel & 0x00FF0000) >> 16) +
                        ((pixel & 0x0000FF00) >> 7) +
                         (pixel & 0x000000FF)) >> 2);
    }

    /**
     * A variant on {@link LuminanceSourceBitmap} that acts as if the input
     * is rotated 90 degrees counter-clockwise.
     */
    private static final class CCRotatedLuminanceSourceBitmap extends
            LuminanceSource {
        // BB: Use Bitmap instead of Image
        private final Bitmap image;
        private int[] rgbData;

        private CCRotatedLuminanceSourceBitmap(Bitmap image) {
            super(image.getHeight(), image.getWidth());
            this.image = image;
        }

        public byte[] getRow(int y, byte[] row) {
            int height = getHeight();
            if (y < 0 || y >= height) {
                throw new IllegalArgumentException(
                        "Requested row is outside the image: " + y);
            }
            int width = getWidth();
            if (row == null || row.length < width) {
                row = new byte[width];
            }

            if (rgbData == null || rgbData.length < width) {
                rgbData = new int[width];
            }
            // BB: Use getARGB as replacement for getRGB
            image.getARGB(rgbData, 0, height, height - 1 - y, 0, 1, width);
            for (int x = 0; x < width; x++) {
                row[x] = toLuminance(rgbData[x]);
            }
            return row;
        }

        public byte[] getMatrix() {
            int width = getWidth();
            int height = getHeight();
            int area = width * height;
            byte[] matrix = new byte[area];

            int[] rgb = new int[area];
            // BB: Use getARGB as replacement for getRGB
            image.getARGB(rgb, 0, width, 0, 0, width, height);
            // This flips x/y in the target to result in a rotated image
            int offset = height * (width - 1);
            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    matrix[offset - height * x + y] = toLuminance(rgb[y * width + x]);
                }
            }
            return matrix;
        }
    }

}
