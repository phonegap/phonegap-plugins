# BarcodeScanner plugin for Cordova #

The BarcodeScanner plugin provides the ability to scan and decode barcodes as well as encode text into a barcode image.

## Background Information ##

Before going into detail about how to use this plugin, some history of BlackBerry support needs to be understood.  When you build a BlackBerry WebWorks (Cordova) application you are building an application specific to a version of the BlackBerry OS.  It is impossible to build a single application binary that executes on OS 5 and when running on OS 6 makes use of new API added added in that version.

The above is relevant to this plugin because OS 6 introduced native API support for barcode scanning through the inclusion of the ZXing (http://code.google.com/p/zxing/) code and wrapper API around it.  OS 5 does not include the ZXing code.  Additionally, the OS 5 (and even OS 6) native API limits the UI (live video overlays) and camera (focus control) functionality available to applications.  This limits the usability and accuracy of barcode scanner implementations based on OS 5 API.

Due to the above history and limitations, this plugin provides two possible implementations.  Each of them have there own pros and cons.

1. Build an application that supports BlackBerry OS 5, OS 6 and OS 7.

    Choosing this implementation will allow a single binary to be easily built and deployed on all OS versions supported by BlackBerry WebWorks.  The open source ZXing code is separately built and included in the application which allows the ZXing implementation to easily be updated but does increase the size of the application.  The biggest down side of this implementation is that it appears to be impossible to focus (auto or manual) the camera which makes detecting some barcodes difficult.

2. Build an application that supports BlackBerry OS 6 and OS 7 only.

    Makes use of the native barcode scanner API available in OS 6 and 7 which effectively focuses the camera on devices that support auto focus.  Provides the same look and feel that the user expects from other barcode scanning applications on the device.  Native API uses an older version of the ZXing code so some barcode formats are not supported.  Choosing this implementation removes the ability to execute the application on OS 5 devices.  This implementation also does not return the format of barcode read upon successful scan.

If your application needs to support versions OS 5 and greater consider providing your application as two separate binaries.  One binary built against the OS 5 implementation and one built against the OS 6 (and greater) implementation.

## Adding the Plugin to your project ##

Using this plugin requires [Cordova BlackBerry-WebWorks](http://github.com/apache/incubator-cordova-blackberry-webworks).  To install and enable the plugin in your project perform the following steps:

1. Copy barcodescanner.js to your project and include a reference to it in your html file after cordova.js.

    &lt;script type="text/javascript" charset="utf-8" src="cordova.js"&gt;&lt;/script&gt;

    &lt;script type="text/javascript" charset="utf-8" src="barcodescanner.js"&gt;&lt;/script&gt;

2. Add the common plugin source to your cordova.jar in your projects ext folder.  The cordova.jar file is a jar of source code.  Open cordova.jar with your favorite archive manager or use the jar command to create a directory called "org/apache/cordova/plugins/barcodescanner" inside the jar and copy `BarcodeScanner.java`, `EncodeAction.java`, `ScanAction.java` into it.

3. Add the OS specific code to the cordova.jar file.

    *For an OS 5 based build:* Copy `AdvancedMultimediaManager.java`, `Encoder.java`, `LuminanceSourceBitmap.java`, and `Scanner.java` from the OS5 directory to "org/apache/cordova/plugins/barcodescanner" in cordova.jar.  Copy the prebuilt ZXing jar `zxingcore.jar` from the OS5 directory to the root (same level in hierarchy as com folder and library.xml) of cordova.jar.

    *For an OS 6 based build:* Copy `Encoder.java` and `Scanner.java` from the OS6 directory to "org/apache/cordova/plugins/barcodescanner" in cordova.jar.

4. If you had to unjar cordova.jar to add the plugin source, recreate the cordova.jar by creating a jar archive which has the com folder and library.xml (and zxingcore.jar for OS 5) at its root.  Make sure the resulting cordova.jar is in your projects ext folder and is the only cordova.jar in the folder.

5. In your projects plugins.xml file add the following line:

    &lt;plugin name="BarcodeScanner" value="org.apache.cordova.plugins.barcodescanner.BarcodeScanner"/&gt;

If you have chosen to use the OS 6 based implementation AND you are using a version of the BlackBerry WebWorks SDK prior to v2.2 then additional steps are required. You will need to change the library that the BlackBerry WebWorks tools build against.  Follow the steps below to setup your environment to build against OS 6.

1. If you do not have v6.0 of the BlackBerry JDE, download it from the link below and install it:

    http://us.blackberry.com/developers/javaappdev/javadevenv.jsp

2. Make a copy of the net_rim_api.jar in your BlackBerry WebWorks SDK lib directory.  This file is from OS 5 and is needed when building against OS 5.

3. Copy the net_rim_api.jar from the lib folder where you installed the v6.0 BlackBerry JDE to your BlackBerry WebWorks SDK lib folder.

4. Now when you build your application it will be built against a v6.0 library and will have access to the additional API provided in that version.

## Using the plugin ##

### Scanning for Barcodes ###

Invoking the barcode scanning API will launch a new screen with a live video feed coming from the camera.  The code constantly scans the feed for a detected barcode and returns when a barcode is successfully decoded, an error occurs or the user clicks the back button.

The plugin exposes the barcode scanning API as:

    window.plugins.barcodeScanner.scan(success, fail)
        Where:
            success: Callback function on successful barcode decode.
                     Decoded text is passed as a string argument
            fail:    Callback function on error.
                     Error message passed as string argument.

`success()` is passed an object with the following properties:

* text - the scanned text as a string
* format - the format of the barcode scanned as a string (OS 5 impl only)
* cancelled - indication of whether the scan was cancelled as a boolean

An example invocation:

    window.plugins.barcodeScanner.scan(
        function(result) {
            if (result.cancelled === true) {
                alert("The scan was cancelled");
            } else {
                alert("Decoded barcode text: " + result.text);
            }
        }, function(error) {
            alert("Failed to scan barcode: " + error);
        }
    );

Barcode types supported for decoding is dependent on the implementation chosen.  Using the OS 6 implementation provides support for the following barcode types:

* Code 128
* Code 39
* Data Matrix
* EAN-13
* EAN-8
* ITF
* PDF-417
* QR Code
* UPC-A
* UPC-E

The OS 5 implementation uses an updated version of ZXing and supports the following barcode types in addition to the ones listed above:

* Aztec
* Codabar
* Code 93
* RSS-14

### Encoding text into a Barcode image ###

The barcode encoding API provides the ability to encode a piece of data into a barcode image.  The plugin currently only supports encoding into a QR Code barcode.  The encoding API supports encoding plain text as well as certain types of data.  Using one of the supported types provides additional formatting of the data so that the data type can be recognized by a barcode scanner reading the resulting image.  The following data types defined by `BarcodeScanner.EncodeFormat` are supported:

* CONTACT - A contacts details.
* LOCATION - Geolocation latitude, longitude.
* EMAIL - Email address.
* PHONE - Phone number.
* SMS  - Phone number and message to send.
* TEXT - Plain text.

The plugin exposes the barcode encoding API as:

    window.plugins.barcodeScanner.encode(format, data, success, fail, options)
        Where:
            format:  The BarcodeScanner.EncodeFormat of the specified data.
            data:    The data to encode. Must be a string for EMAIL, PHONE,
                     SMS and TEXT types. Must be a BarcodeContact for CONTACT
                     type and BarcodeLocation for LOCATION type.
            success: Callback function on successful barcode encode.
                     File URI or base64 string is passed as argument.
            fail:    Callback function on error.
                     Error message passed as string argument.
            options: Encoding options.

The options parameter allows customization of the output.  The following options are supported:

* width - Desired width of image. Default 200.
* height - Desired height of image. Default 200.
* destinationType - Determines the format of the returned value.
 * `BarcodeScanner.DestinationType.DATA_URL` - Base64 string containing the image. Default.

An example invocation to encode text (url) into a 300 x 300 pixel image:

    window.plugins.barcodeScanner.encode(
        BarcodeScanner.EncodeFormat.TEXT,
        "http://www.ibm.com",
        function(success) {
            alert("encode success: " + success);
        },
        function(fail) {
            alert("encoding failed: " + fail);
        },
        {width: 300, height: 300}
    );

## RELEASE NOTES ##

### 20111026 ###
* Initial release
* See the .js file for API docs

## BUGS AND CONTRIBUTIONS ##

Patches welcome! Send a pull request.  Requires a [CLA](https://files.pbworks.com/download/qH1OfztZ1d/phonegap/31724031/NitobiPhoneGapCLA.pdf).

Post issues in the [PhoneGap Google Groups](http://groups.google.com/group/phonegap), include in the subject heading - "BarcodeScannerPlugin" or on [Github](http://github.com/phonegap/phonegap-plugins/issues)
(preferred)

## LICENSE ##

The OS 5 implementation of this plugin includes compiled source code from the [zxing](http://code.google.com/p/zxing/) project, which is licensed under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).

The other code in this plugin is licensed as below:

The MIT License

Copyright (c) 2011 IBM

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
