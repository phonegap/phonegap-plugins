# PhoneGap Globalization Plugin #
by IBM

## Adding the Plugin to your project ##

1. Make sure your PhoneGap Xcode project has been updated for the iOS 5.1 SDK
2. Add the .h and .m files to your Plugins folder in your project
3. Add Globalization to the Plugins dictionary in PhoneGap.plist.  The key and value are: Globalization.
4. Add the Globalization.js file to your "www" folder on disk, and add reference(s) to the .js files as <link> tags in your html file(s)
5. The Globalization.js code is well documented.  See a few examples in the code in index.html (make sure to update the reference to your version of phonegap*.js in index.html).
6. Make sure you check the "RELEASE NOTES" section below!

## RELEASE NOTES ##

### 20120412 ###
* Updated to work with Cordova 1.5 and 1.6
* Sample code in globalization.html

### 20110627 ###
* Initial release
* See the .js file for API docs, and the index.html for some sample code
* A globalization.tests.js file is provide to run with  qunit as part of Mobile-Spec [Github](http://github.com/phonegap/mobile-spec)

## BUGS AND CONTRIBUTIONS ##

Patches welcome! Send a pull request.  

Post issues in the [PhoneGap Google Groups](http://groups.google.com/group/phonegap), include in the subject heading - "GlobalizationPlugin" or on [Github](http://github.com/phonegap/phonegap-plugins/issues)
(preferred)

## LICENSE ##

The MIT License

Copyright (c) 2011, 2012 IBM

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
