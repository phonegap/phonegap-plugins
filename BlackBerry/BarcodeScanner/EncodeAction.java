/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2011, IBM Corporation
 */
package org.apache.cordova.plugins.barcodescanner;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import net.rim.device.api.io.Base64OutputStream;
import net.rim.device.api.system.Bitmap;
import net.rim.device.api.system.PNGEncodedImage;

import org.apache.cordova.api.PluginResult;
import org.apache.cordova.json4j.JSONArray;
import org.apache.cordova.json4j.JSONException;

/**
 * Handles the common code for the barcode encode action. Implements argument
 * processing and text encoding formatting and generation of return data. An OS
 * specific implementation is used to perform the actual encoding of text.
 */
class EncodeAction {

    // Types of text content which can be encoded in a barcode.
    private static String ENCODE_CONTACT = "CONTACT";
    private static String ENCODE_EMAIL = "EMAIL";
    private static String ENCODE_LOCATION = "LOCATION";
    private static String ENCODE_PHONE = "PHONE";
    private static String ENCODE_SMS = "SMS";
    private static String ENCODE_TEXT = "TEXT";

    // Common argument parameters.
    private static final int ARG_ENCODE_TYPE = 0;
    private static final int ARG_ENCODE_DEST = 1;
    private static final int ARG_ENCODE_WIDTH = 2;
    private static final int ARG_ENCODE_HEIGHT = 3;

    // Argument containing data for ENCODE_EMAIL, ENCODE_PHONE, ENCODE_SMS,
    // ENCODE_TEXT content type.
    private static final int ARG_ENCODE_TEXT = 4;

    // Arguments containing data for ENCODE_CONTACT content type.
    private static final int ARG_ENCODE_CONTACT_ADDRESS = 4;
    private static final int ARG_ENCODE_CONTACT_BIRTHDAY = 5;
    private static final int ARG_ENCODE_CONTACT_EMAIL = 6;
    private static final int ARG_ENCODE_CONTACT_NAME = 7;
    private static final int ARG_ENCODE_CONTACT_NICKNAME = 8;
    private static final int ARG_ENCODE_CONTACT_NOTE = 9;
    private static final int ARG_ENCODE_CONTACT_TELEPHONE = 10;
    private static final int ARG_ENCODE_CONTACT_URL = 11;

    // Arguments containing data for ENCODE_LOCATION content type.
    private static final int ARG_ENCODE_LOCATION_LAT = 4;
    private static final int ARG_ENCODE_LOCATION_LONG = 5;

    /** Return the result as a Base-64 encoded string. */
    private static final int DESTINATION_DATA_URL = 0;

    /** Return the result as a file URI. */
    private static final int DESTINATION_FILE_URI = 1;

    /**
     * Parses the passed in arguments and formats the arguments into a text
     * string that can be encoded. Calls the OS specific implementation to
     * encode the text string then passes the result (based64 encoded string or
     * file URI) back to the caller.
     *
     * @param args
     *            JSON array of arguments containing encoding options and data.
     * @return a success or error result.
     */
    PluginResult encode(JSONArray args) {
        String text = null;

        // Default the width and height of barcode image to 200x200.
        int width = 200;
        int height = 200;

        int destination = DESTINATION_DATA_URL;

        // Parse the arguments specified.
        if (args != null && args.length() > 0) {
            // Default to simple text encoding if not specified.
            String encodeType = ENCODE_TEXT;
            try {
                if (!args.isNull(ARG_ENCODE_TYPE)) {
                    encodeType = args.getString(ARG_ENCODE_TYPE).toUpperCase();
                }

                if (!args.isNull(ARG_ENCODE_DEST)) {
                    int destType = args.getInt(ARG_ENCODE_DEST);
                    if (destType == DESTINATION_FILE_URI) {
                        destination = DESTINATION_FILE_URI;
                    }
                }

                if (!args.isNull(ARG_ENCODE_WIDTH)) {
                    int tmp = args.getInt(ARG_ENCODE_WIDTH);
                    if (tmp > 0) {
                        width = tmp;
                    }
                }

                if (!args.isNull(ARG_ENCODE_HEIGHT)) {
                    int tmp = args.getInt(ARG_ENCODE_HEIGHT);
                    if (tmp > 0) {
                        height = tmp;
                    }
                }

                text = getEncodeText(encodeType, args);

            } catch (JSONException e) {
                return new PluginResult(PluginResult.Status.JSON_EXCEPTION,
                        "One of the barcodescanner encode options is not valid JSON.");
            }
        }

        // Ensure there is something to encode.
        if (text == null || text.length() == 0) {
            return new PluginResult(PluginResult.Status.ERROR,
                    "User did not specify data to encode");
        }

        Bitmap bitmap = null;
        try {
            // Invoke OS specific encoder to encode the data.
            bitmap = Encoder.createBitmap(Encoder.QR_CODE, text, width,
                    height);
        } catch (Exception e) {
            return new PluginResult(PluginResult.Status.ERROR, e.getMessage());
        }

        // Return the encoding in the proper format, either a base64 encoded
        // string or a file URI to where the image is stored.
        PluginResult result = null;
        if (destination == DESTINATION_DATA_URL) {
            String imageData = null;
            try {
                imageData = encodeImage(bitmap);
                result = new PluginResult(PluginResult.Status.OK, imageData);
            } catch (IOException e) {
                result = new PluginResult(PluginResult.Status.IO_EXCEPTION,
                        e.getMessage());
            }
        }

        return result;
    }

    /**
     * Parses the arguments based on the specified format type to build a string
     * that can be properly encoded.
     *
     * @param type
     *            the type of data to encode.
     * @param args
     *            the arguments passed to the encode method.
     * @return a formatted string ready to be encoded.
     * @throws JSONException
     */
    private String getEncodeText(String type, JSONArray args)
            throws JSONException {
        String text = null;

        // Build the string for a contact as specified in the NTT DoCoMo
        // document for MECARD.
        // http://www.nttdocomo.co.jp/english/service/imode/make/content/barcode/function/application/addressbook/index.html
        if (ENCODE_CONTACT.equals(type)) {
            StringBuffer contactData = new StringBuffer();
            contactData.append("MECARD:");

            String data = args.getString(ARG_ENCODE_CONTACT_ADDRESS);
            if (data != null) {
                contactData.append("ADR:").append(data.trim()).append(';');
            }

            data = args.getString(ARG_ENCODE_CONTACT_BIRTHDAY);
            if (data != null) {
                contactData.append("BDAY:").append(data.trim()).append(';');
            }

            data = args.getString(ARG_ENCODE_CONTACT_EMAIL);
            if (data != null) {
                contactData.append("EMAIL:").append(data.trim()).append(';');
            }

            data = args.getString(ARG_ENCODE_CONTACT_NAME);
            if (data != null) {
                contactData.append("N:").append(data.trim()).append(';');
            }

            data = args.getString(ARG_ENCODE_CONTACT_NICKNAME);
            if (data != null) {
                contactData.append("NICKNAME:").append(data.trim()).append(';');
            }

            data = args.getString(ARG_ENCODE_CONTACT_NOTE);
            if (data != null) {
                contactData.append("NOTE:").append(data.trim()).append(';');
            }

            data = args.getString(ARG_ENCODE_CONTACT_TELEPHONE);
            if (data != null) {
                contactData.append("TEL:").append(data.trim()).append(';');
            }

            data = args.getString(ARG_ENCODE_CONTACT_URL);
            if (data != null) {
                contactData.append("URL:").append(data.trim()).append(';');
            }

            if (contactData.length() > 0) {
                contactData.append(';');
                text = contactData.toString();
            }
        } else if (ENCODE_EMAIL.equals(type)) {
            text = "mailto:" + args.getString(ARG_ENCODE_TEXT);
        } else if (ENCODE_LOCATION.equals(type)) {
            String latitude = args.getString(ARG_ENCODE_LOCATION_LAT);
            String longitude = args.getString(ARG_ENCODE_LOCATION_LONG);
            if (latitude != null && longitude != null) {
                text = "geo:" + latitude + ',' + longitude;
            }
        } else if (ENCODE_PHONE.equals(type)) {
            text = "tel:" + args.getString(ARG_ENCODE_TEXT);
        } else if (ENCODE_SMS.equals(type)) {
            text = "sms:" + args.getString(ARG_ENCODE_TEXT);
        } else if (ENCODE_TEXT.equals(type)) {
            text = args.getString(ARG_ENCODE_TEXT);
        }

        return text;
    }

    /**
     * Converts the specified Bitmap contents to a Base64-encoded string.
     *
     * @param bitmap
     *            Bitmap to convert.
     * @return Bitmap contents as a Base64-encoded String
     */
    private String encodeImage(Bitmap bitmap) throws IOException {
        String imageData = null;

        PNGEncodedImage image = PNGEncodedImage.encode(bitmap);
        byte[] bytes = image.getData();

        ByteArrayOutputStream byteArrayOS = null;

        try {
            // encode file contents using BASE64 encoding
            byteArrayOS = new ByteArrayOutputStream();
            Base64OutputStream base64OS = new Base64OutputStream(byteArrayOS);
            base64OS.write(bytes);
            base64OS.flush();
            base64OS.close();
            imageData = byteArrayOS.toString();
        } finally {
            if (byteArrayOS != null)
                byteArrayOS.close();
        }

        return imageData;
    }

}
