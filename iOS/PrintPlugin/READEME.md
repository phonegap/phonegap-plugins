Notes added 2-26-2012 
Add PrintPlugin PrintPlugin to Cordova.plist under Plugins
Test on real hardware not Simulator



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

The plugin creates the object window.plugins.pgPrint with two methods:

### isPrintingAvailable ###

Printing is only available on devices capable of multi-tasking (iPhone 3GS, iPhone 4 etc.) running iOS 4.2 or later. You can use this function to hide print functionality from users who will be unable to use it. Function takes a callback function, passed to which is a JSON object which contains a boolean property called available.

```javascript
/*
 Find out if printing is available. Use this for showing/hiding print buttons. 
 */
 window.plugins.printPlugin.isPrintingAvailable(
    function(result){
        alert(result.available ? "Printing is available" : "Printing NOT available");
    }
 );
```

### print ###
Function takes an html string and (optionally) a success callback, failure callback, and options.

1. An HTML string, e.g. <strong>hello<strong>
2. Success callback - receives an object with two parameters:
       - success (always true)
       - available (always true)
3. Failure callback - receives an object with properties
       - success (always false)
       - available (false if printing not available on this device)
       - error (error message returned by iOS in the event of an error)
4. An object which contains printing options (see below).

```javascript
//Get HTML string
var html = document.getElementById("printHTML").innerHTML;

/*
 Pass an HTML and - optionally - success function, error function.
 */
 window.plugins.printPlugin.print(
     html,
     function(result) {
        alert("Printing successful");
     }, 
     function(result) {
        if (!result.available){
           alert("Printing is not available");
        }
        else{
           //Localised error description
           alert(result.error);
        }
     }
     /*
      Add the following on an iPad to position the dialog
      ,
      {dialogOffset: {left: 500, top: 900}}
      */
 );
```

### Supporting devices running below iOS < 4.2 ###
In order to compile this for versions of iOS earlier than 4.2 (when printing was introduced) then you will need to add -weak_framework UIKit to the project settings under "Other Linker Flags". See the Stack Overflow article for more information: http://stackoverflow.com/questions/4297723/ios-add-printing-but-keep-compatibility-with-ios-3.

### Testing in the iOS Simulator ###
There's no need to waste lots of paper when testing - if you're using the iOS simulator, select File->Open Printer Simulator to open some dummy printers (print outs will appear as PDF files).

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

### EXC_BAD_ACCESS in iOS Simulator ###
(Taken from the Twitter plugin).

If you have issues with the app crashing with EXC_BAD_ACCESS on iOS
Simulator you may have a weak linking issue. With your project highlighted
in the left column in XCode go to Targets > Your Project > Build Settings >
Linking > Other Linker Flags and replace -weak_library with -weak-lSystem For
more information see:
http://stackoverflow.com/questions/6738858/use-of-blocks-crashes-app-in-iphone-simulator-4-3-xcode-4-2-and-4-0-2


## LICENSE ##

The MIT License

Copyright (c) 2011 Ian Tipton

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


