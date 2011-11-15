# Barcode Scanner plugin for Phonegap #

Originally by Matt Kane

Modifications by IBM

## Using the plugin ##

The plugin requires the AVFoundation Framework, which is only available under
iOS 4.x and greater.  The plugin tests to make sure AVFoundation Framework
is available before using it, so you should be able to link this into an
application targeting iOS 3.x or earlier (though the barcode scanning will
not work).

The plugin creates the object `window.plugins.barcodeScanner` with two methods:

    scan(success, fail)
    encode(type, data, success, fail, options)

## `scan()` method ##

The `scan` function is invoked as follows:

    scan(success, fail)

`success` and `fail` are callback functions.

`success()` is passed an object with the following properties:

* `text` - the scanned text as a string
* `format` - the format of the barcode scanned as a string
* `cancelled` - indication of whether the scan was cancelled as a boolean

`fail()` is passed a string containing an error message, if the scan failed

A full example could be:

    window.plugins.barcodeScanner.scan(
        function(result) {
            if (result.cancelled)
                alert("the user cancelled the scan")
            else
                alert("we got a barcode: " + result.text)
        },
        function(error) {
            alert("scanning failed: " + error)
        }
    )

## `encode()` method ##

The `encode` function is not supported on iOS.

## barcode formats supported ##

The following barcode types are supported; the names come from the
Barcode formats constants in the zxing code.

* QR_CODE
* DATA_MATRIX
* UPC_E
* UPC_A
* EAN_8
* EAN_13
* CODE_128
* CODE_39

## Adding the plugin to your project ##

* Copy the .h, .cpp and .mm files to the Plugins directory in your project.
* Copy the .js file to your www directory and reference it from your html file(s).
* In the `Supporting Files` directory of your project, add a new plugin
by editing the file `PhoneGap.plist` and in the `Plugins` dictionary adding
the following key/value pair:
 * key: `com.phonegap.barcodeScanner`
 * value: `PGBarcodeScanner`
* Add the following libraries to your Xcode project, if not already there:
 * AVFoundation.framework
 * AssetsLibrary.framework
 * CoreVideo.framework
 * libiconv.dylib
 * to add these libraries, select your target, and then display the Build Phases.
   Under Link Binary With Libraries, click the add button and then
   select the frameworks above.  To support being able to link against
   iOS 3.x, these libraries should be marked as Optional, not Required.

* You may need to set the compile options for zxing-all-in-one.cc to turn off optimization.

## Building ##

Note that you only need to follow the instructions below if you are intending
on **making changes** to the zxing code.  If you just want
to **use** the barcode scanner plugin, you don't need to build.  All the build
step does is rebuild the `zxing-all-in-one` files.

To make life a little easier for folks using this plugin, all the of zxing
code is combined into a single file, rather than dealing with Xcode subprojects.
To build the `zxing-all-in-one.cpp` and
corresponding `.h` file, cd into the `build` directory and run `make`.

## Testing ##

Under the `test` directory is a test case you can use to test the plugin.
It has two parts - a desktop web page, and a phonegap app.

To build the test applications, follow the instructions in the `README.md` file
in the `test` directory.

## Licence ##

This plugin includes source code from the [zxing](http://code.google.com/p/zxing/)
project, which is licensed under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).

The other code in this plugin is licensed as below:

PhoneGap is available under *either* the terms of the modified BSD license *or* the
MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
