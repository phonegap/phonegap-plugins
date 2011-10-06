# Barcode Scanner plugin for Phonegap #
By Matt Kane

## Adding the Plugin to your project ##
This plugin requires the end user to install [the ZXing Barcode Scanner app](http://code.google.com/p/zxing/)
If the user doesn't have the app install they will be promped to install it the first time the plugin is used.

1. To install the plugin, move `barcodescanner.js` to your project's www folder and include a reference to it 
in your html files. 
2. Create a folder called 'src/com/beetight/barcodescanner' within your project's src/com/ folder.
3. And copy the java file into that new folder.

    mkdir -p <your_project>/src/com/beetight/barcodescanner
    cp ./BarcodeScanner.java <your_project>/src/com/beetight/barcodescanner
    
4. Add a plugin line to `res/xml/plugins.xml`

    `<plugin name="BarcodeScanner" value="com.beetight.barcodescanner.BarcodeScanner"/>`

## Using the plugin ##
The plugin creates the object `window.plugins.barcodeScanner` with one method `scan(types, success, fail, options)`
`types` is a comma-separated list of barcode types that the scanner should accept. If you pass null then any
barcode type will be accepted. The following types are currently available:

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

Take a look in the javascript file for the list, as well as some convenience constants.

`success` and `fail` are callback functions. Success is passed the decoded barcode as a string. `options` allows
you to change the strings used in the dialog box which is displayed if the user doesn't have Barcode Scanner 
installed. The defaults are:

    {
        installTitle = "Install Barcode Scanner?",
        installMessage = "This requires the free Barcode Scanner app. Would you like to install it now?",
        yesString = "Yes",
        noString = "No"
    }

A full example could be:

    window.plugins.barcodeScanner.scan( BarcodeScanner.Type.QR_CODE, function(result) {
            alert("We got a barcode: " + result);
        }, function(error) {
		    alert("Scanning failed: " + error);
	    }, {yesString: "Install"}
	);

## Encoding a Barcode ##
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
      }, {yesString: "Install"}
    );

	
## BUGS AND CONTRIBUTIONS ##
The latest bleeding-edge version is available [on GitHub](http://github.com/ascorbic/phonegap-plugins/tree/master/Android/)
If you have a patch, fork my repo baby and send me a pull request. Submit bug reports on GitHub, please.
	
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




	