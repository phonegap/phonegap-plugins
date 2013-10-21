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

## Creating and using custom UI overlay XIB

You can customize the scanning UI by creating a new overlay in XCode4. The basic gist of this is that you need to create a interface file that contains
at the bare minumum a transparent view that is connected to the PGbcsViewController's overlayView outlet.  For more detailed instructions, see below.

* File -> New File
* Select "User Interface" > "View" and click "Next"
* Select "iPhone" for device family and click "Next"
* Enter a file name and click "Create", for example "BarcodeOverlay"
   * I normally place xib files within the application's resource folder, though it shouldn't matter much where it is within the project.
* Set the main view to be transparent so that you can see the camera layer.
* Select the "File's Owner" and click on the "Identity Inspector" icon, or on your keyboard press OPTION-CMD-3
* Change the "Class' from NSObject to PGbcsViewController
* Add any UI elements to the view that you want in your overlay.
* Ensure the main view object is selected.
* Click the "Connections Inspector" or on your keyboard press OPTION-CMD-6
* Drag form the circle beside "New Referencing Outlet" to the "File's Owner" object
* Select "overlayView" from the popup.
* Add a Button to your view and ensure it's selected.
* Click the "Connections Inspector" or on your keyboard press OPTION-CMD-6
* Drag from the circle beside "Touch Up Inside" to the "File's Owner" object.
  * Note, if no "Touch Up Inside" option is available, drag from the circle next to "Selector" to the "File Owner" object.
* Select "cancelButtonPressed:" from the popup.
* Save the interface file and use it by passing the overlay file name (minus the xib extension) in as an argument to the `scan` function:

    window.plugins.barcodeScanner.scan(success, fail, ["BarcodeOverlay"])

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

## Compile Errors for Automagic Reference Counting (ARC) ##

For people developing on Mac OS X >= 10.7 (Lion) and using XCode >= 4.2, the
option of using "Automatic Reference Counting" (ARC) is available.  For more
information on ARC, see the documentation for it at the [clang documentation site](http://clang.llvm.org/docs/AutomaticReferenceCounting.html).

Unfortunately, the native code for BarcodeScanner (the .cpp, .mm, etc files) is
not compatible with ARC.  If you try to compile the native code with ARC
enabled, you will see compile errors referencing ARC, such as:

    /some/file.mm:40:1: error: 'NSXyzSomething' is unavailable: not available in automatic reference counting mode

You will need to ensure you are not compiling the
plugin native code with ARC to avoid these compile errors.
There are several ways to do this:

* Set the project compiler to "LLVM GCC 4.2", instead of "Apple LLVM 3.0"; ARC is
only supported when you use Apple LLVM. To set the project compiler,
in your Project, under
"Build Settings", and then under "Build Options", there is a setting for
"Compiler for C/C++/Objective-C". Change that value to "LLVM GCC 4.2".

* Set the project compiler to "Apple LLVM 3.0", but disable ARC.
To disable ARC, in your Project, under "Build Settings", and then under
"Apple LLVM compiler 3.0 - Language", in the setting
"Objective-C Automatic Reference Counting", change the setting to "No".

* Disable ARC on a per-file basis.  To disable ARC for a file,
in your Target, in the "Build Phases", and then in the "Compile Sources" section,
double-click each .m/.mm/.cpp/.c/etc file, and add the compiler flag
"-fno-objc-arc" (no quotes).

Also note that when you create a new Xcode project, you will be given the
option of enabling ARC or not for the project.  The option appears as a check
box in one of the dialogs you are presented with while creating the project.
You can keep that check box unselected (unchecked) and then not having to worry
about ARC issues for the project.  If you enable ARC for the project (checked),
you will have to disable ARC for the plugin natives using one of the methods above.

Further note that if you do **not** enable ARC during the project creation,
the "Objective-C Automatic Reference Counting" setting under the
"Apple LLVM compiler 3.0 - Language" section (second bullet above) will not
appear.

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
