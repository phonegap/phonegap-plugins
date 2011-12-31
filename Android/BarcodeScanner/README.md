# Barcode Scanner plugin for Phonegap #
Originally by Matt Kane
Updates by Simon MacDonald

## Adding the Plugin to your project ##

1. Add the 'LibraryProject' into Eclipse. File -> New Android Project -> create project from existing source.
2. In the new project you've just added to Eclipse go to the project properties. Select the Android section and at the bottom of the dialog check the "Is Library" checkbox.
3. In your application go into the project properties. In the Android section under library click the Add button and select the library you created in step 2.
4. To install the plugin, move barcodescanner.js to your project's www folder and include a reference to it in your html files.
5. Create a folder called 'com/phonegap/plugins/barcodescanner' within your project's src folder.
6. And copy the BarcodeScanner.java file into that new folder.

`mkdir <your_project>/src/com/phonegap/plugins/barcodescanner`

`cp ./src/com/phonegap/plugins/barcodescanner/BarcodeScanner.java <your_project>/src/com/phonegap/plugins/barcodescanner`

7. In your res/xml/plugins.xml file add the following line:

    `<plugin name="BarcodeScanner" value="com.phonegap.plugins.barcodescanner.BarcodeScanner"/>`

8. Add the following activity to your AndroidManifest.xml file. It should be added inside the &lt;application/&gt; tag.

    `<!-- ZXing activities -->
    <activity android:name="com.google.zxing.client.android.CaptureActivity"
              android:screenOrientation="landscape"
              android:configChanges="orientation|keyboardHidden"
              android:theme="@android:style/Theme.NoTitleBar.Fullscreen"
              android:windowSoftInputMode="stateAlwaysHidden">
      <intent-filter>
        <action android:name="com.phonegap.plugins.barcodescanner.SCAN"/>
        <category android:name="android.intent.category.DEFAULT"/>
      </intent-filter>
    </activity>
    <activity android:name="com.google.zxing.client.android.encode.EncodeActivity" android:label="@string/share_name">
      <intent-filter>
        <action android:name="com.phonegap.plugins.barcodescanner.ENCODE"/>
        <category android:name="android.intent.category.DEFAULT"/>
      </intent-filter>
    </activity>`

## Using the plugin ##
The plugin creates the object `window.plugins.barcodeScanner` with the method `scan(success, fail)`. 
The following barcode types are currently supported:

* QR_CODE
* DATA_MATRIX
* UPC_E
* UPC_A
* EAN_8
* EAN_13
* CODE_128
* CODE_39
* CODE_93
* CODABAR
* ITF
* RSS14
* PDF417
* RSS_EXPANDED

`success` and `fail` are callback functions. Success is passed an object with data, type and cancelled properties. Data is the text representation of the barcode data, type is the type of barcode detected and cancelled is whether or not the user cancelled the scan.

A full example could be:

    window.plugins.barcodeScanner.scan( function(result) {
            alert("We got a barcode\n" +
                      "Result: " + result.text + "\n" +
                      "Format: " + result.format + "\n" +
                      "Cancelled: " + result.cancelled);
        }, function(error) {
		    alert("Scanning failed: " + error);
	    }
	);

## Encoding a Barcode ##
The plugin creates the object `window.plugins.barcodeScanner` with the method `encode(type, data, success, fail)`. 
Supported encoding types:

* TEXT_TYPE
* EMAIL_TYPE
* PHONE_TYPE
* SMS_TYPE

A full example could be:

        window.plugins.barcodeScanner.encode(BarcodeScanner.Encode.TEXT_TYPE, "http://www.nytimes.com", function(success) {
  	        alert("encode success: " + success);
  	      }, function(fail) {
  	        alert("encoding failed: " + fail);
  	      }
  	    );
	
## Licence ##

The MIT License

Copyright (c) 2010 Matt Kane

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
