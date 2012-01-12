# PhoneGap Print-Plugin #
by Ian Tipton (github.com/itip).

Print from iOS devices to AirPrint compatible printers.


## Adding the Plugin to your project ##

Using this plugin requires [iPhone PhoneGap](http://github.com/phonegap/phonegap-iphone).

1. Make sure your PhoneGap Xcode project has been [updated for the iOS 4 SDK](http://wiki.phonegap.com/Upgrade-your-PhoneGap-Xcode-Template-for-iOS-4), and you are using PhoneGap version 1 or higher.
2. Add the .h and .m files to your Plugins folder in your project
3. Add the .js files to your "www" folder on disk, and add reference(s) to the .js files as <link> tags in your html file(s)
4. Update the PhoneGap.plist file: Find PhoneGap.plist in your project, expand the "Plugins" section, click on "+" on the last line to add a new line. Add a new value with a key of 'printPlugin' and a value of 'PrintPlugin'
5. Although printing is only supported on iOS 4.2+, if your app can be installed on earlier versions of iOS then see the 'Supporting devices running below iOS < 4.2' below.
6. See the sample index.html file for an example use of the plugin.

## RELEASE NOTES ##

### 20110813 ###
* Initial release
* Allows the printing of an HTML string to AirPrint compatible printers.


## Using the plugin ##

The plugin creates the object window.plugins.printPlugin with two methods:

### window.plugins.printPlugin.isPrintingAvailable( settings ) ###
__settings__ A set of key/value pairs that configure the AirPrint request. All settings are optional.

* __success__<br />
  default: function(result) {}

  A function to be called if the request succeeds. The function gets passed a status message.

* __failure__<br />
  default: function(result) {}

  A function to be called if the request fails. The function gets passed a status message.

```javascript
window.plugins.printPlugin.isPrintingAvailable({
  success: function() {
    alert("Printing is available");
  },
  failure: function() {
    alert("Printing NOT available");
  }
});
```

### window.plugins.printPlugin.print( settings ) ###
__settings__ A set of key/value pairs that configure the AirPrint request. All settings are optional.

* __html__<br />
  default: <empty string>

  An HTML string which will be loaded into it's own UIWebView for printing. Assets are all loaded using the same document root as PhoneGap.

* __outputType__<br />
  default: UIPrintInfoOutputGeneral

  The output type, which is an indication of the type of content the application is drawing or providing. Possible values are:
  - UIPrintInfoOutputGeneral
  - UIPrintInfoOutputPhoto
  - UIPrintInfoOutputGrayscale

  http://developer.apple.com/library/ios/documentation/UIKit/Reference/UIPrintInfo_Class/Reference/Reference.html#//apple_ref/occ/instp/UIPrintInfo/outputType

* __jobName__<br />
  default: <empty string>

  The name of the print job is displayed in the Print Center when the job is printing. The default job name when an empty string is specified is the application name.

* __duplex__<br />
  default: UIPrintInfoDuplexLongEdge

  Some printers can print either duplex (double-sided) or single-sided. If double-sided is selected, a printer can either print flipping the back page along the long edge of the paper or along the short edge. Possible values are:
  - UIPrintInfoDuplexNone
  - UIPrintInfoDuplexLongEdge
  - UIPrintInfoDuplexShortEdge

  http://developer.apple.com/library/ios/documentation/UIKit/Reference/UIPrintInfo_Class/Reference/Reference.html#//apple_ref/occ/instp/UIPrintInfo/duplex

* __orientation__<br />
  default: UIPrintInfoOrientationPortrait

  An application can set this property to a value thats appropriate to the printable content or it can put up a user interface that enables users to pick the printing orientation. Possible values are:
  - UIPrintInfoOrientationPortrait
  - UIPrintInfoOrientationLandscape

  http://developer.apple.com/library/ios/documentation/UIKit/Reference/UIPrintInfo_Class/Reference/Reference.html#//apple_ref/occ/instp/UIPrintInfo/orientation

* __showsPageRange__<br />
  default: true

  A Boolean value that determines whether the printing options include a page-range control.

* __presentFromRect__<br />
  default: [0,0,0,0]

  Presents the iPad printing user interface in a popover view that can be animated from any area in a view. Values specified as x, y, width, and height.

* __success__<br />
  default: function(result) {}

  A function to be called if the request succeeds. The function gets passed a status message.

* __failure__<br />
  default: function(result) {}

  A function to be called if the request fails. The function gets passed a status message.


```javascript
var el = $('#printBtn'), offset = el.offset(), data = $('#printContent').html();

window.plugins.printPlugin.print({
  html: data,
  jobName: 'BaseballCardSummary',
  duplex: 'UIPrintInfoDuplexShortEdge',
  showsPageRange: false,
  presentFromRect: [
    offset.left,
    offset.top,
    el.outerWidth(),
    el.outerHeight()
  ],
  success: function(result) {
    alert('Document has successfully printed.');
  }
});
```


## LICENSE ##

### Supporting devices running below iOS < 4.2 ###
In order to compile this for versions of iOS earlier than 4.2 (when printing was introduced) then you will need to add -weak_framework UIKit to the project settings under "Other Linker Flags". See the Stack Overflow article for more information: http://stackoverflow.com/questions/4297723/ios-add-printing-but-keep-compatibility-with-ios-3.

### Testing in the iOS Simulator ###
There's no need to waste lots of paper when testing - if you're using the iOS simulator, select File->Open Printer Simulator to open some dummy printers (print outs will appear as PDF files).

If you have issues with the app crashing with `EXC_BAD_ACCESS` on iOS Simulator you may have a weak linking issue. With your project highlighted in the left column in XCode go to Targets > Your Project > Build Settings > Linking > Other Linker Flags and replace `-weak_library` with `-weak-lSystem`
For more information see: http://stackoverflow.com/questions/6738858/use-of-blocks-crashes-app-in-iphone-simulator-4-3-xcode-4-2-and-4-0-2

### Adding Page Breaks to Printouts ###
Use the 'page-break-before' property to specify a page break, e.g.

```javascript
<p>
First page.
</p>

<p style="page-break-before: always">
Second page.
</p>
```

See W3Schools for more more information: http://www.w3schools.com/cssref/pr_print_pagebb.asp

Note: you will need to add an extra top margin to new pages.


### Printing on Real Printers ###
Printing is only supported on AirPrint-enabled printers or with the use of third-party software on your computer. The following pages contain more information:
 - AirPrint-enabled printers: http://www.apple.com/ipad/features/airprint.html
 - Enabling AirPrint on your computer: http://reviews.cnet.com/8301-19512_7-20023976-233.html, or http://www.ecamm.com/mac/printopia/


## LICENSE ##

The MIT License

Copyright (c) 2011 Ian Tipton

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
