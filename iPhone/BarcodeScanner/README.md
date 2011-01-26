# Barcode Scanner plugin for Phonegap #
By Matt Kane

## Adding the Plugin to your project ##
Copy the .h and .mm file to the Plugins directory in your project. Copy the .js file to your www directory and reference it from your html file(s). You also need to add the ZXing library to your project.

## Adding ZXing to your project ##
First, [download the ZXing zip file](http://code.google.com/p/zxing/), unpack it, and put it somewhere safe such as your Documents folder. You'll need to whole package, not just the iphone folder. Then add it to your project, using the instructions in the zxing-1.x/iphone/README file. 

## Using the plugin ##
The plugin creates the object `window.plugins.barcodeScanner` with one method `scan(types, success, fail)`
`types` is a comma-separated list of barcode types that the scanner should accept. If you pass null then any
barcode type will be accepted. Currently only `QR_CODE` is supported, but that should change soon.

`success` and `fail` are callback functions. Success is passed the decoded barcode as a string.
A full example could be:

    window.plugins.barcodeScanner.scan( BarcodeScanner.Type.QR_CODE, function(result) {
            alert("We got a barcode: " + result);
        }, function(error) {
		    alert("Scanning failed: " + error);
	    }
	);


## BUGS AND CONTRIBUTIONS ##
The latest bleeding-edge version is available [on GitHub](http://github.com/ascorbic/phonegap-plugins/tree/master/iPhone/)
If you have a patch, fork my repo and send me a pull request. Submit bug reports on GitHub, please.
	
## Licence ##

The MIT License

Copyright (c) 2011 Matt Kane

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

