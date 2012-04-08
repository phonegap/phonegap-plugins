New iOS plugins should be submitted here.

As existing iPhone/iOS plugins are patched and COMPLETELY abandon the PhoneGap naming convention they will be placed here.

The present https://github.com/phonegap/phonegap-plugins/tree/master/iPhone should be preserved for use with projects still using PhoneGap 1.4.1 and before.

* Added a ActionSheet (iOS) plugin with Cordova support.
* Added a AdPlugin (iOS) plugin with Cordova support.
* Added a ApplicationPreferences (iOS) plugin with Cordova support.
* Added a Badge (iOS) plugin with Cordova support.
* Added a BarCodeScanner (iOS) plugin with Cordova support.
* Added a card.io (iOS) plugin with Cordova support.
* Added a ChildBrowser (iOS) plugin with Cordova support.
* Added a DatePicker (iOS) plugin with Cordova support.
* Added a EmailComposer (iOS) plugin with Cordova support.
* Added a NativeControls (iOS) plugin with Cordova support.
* Added a PayPalPlugin (iOS) plugin with Cordova support.
* Added a PrintPlugin (iOS) plugin with Cordova support.
* Added a SMSComposer (iOS) plugin with Cordova support.
* Added a Twitter (iOS) plugin with Cordova support.
* Added a VolumeSlider (iOS) plugin with Cordova support.
* More added regularly.

Please refer to the Plugin Upgrade Guides distributed in the [download](http://phonegap.com/download/) for the most current version. 

**Cordova Plugin Upgrade Guide
**

This document is for developers who need to upgrade their Cordova plugins to a newer Cordova version. Starting with Cordova 1.5.0, some classes have been renamed, which will require the plugin to be upgraded. Make sure your project itself has been upgraded using the "Cordova Upgrade Guide" document.
Upgrading older Cordova plugins to 1.5.0

1. Install Cordova 1.5.0
2. Replace macro occurrences of "PHONEGAP_FRAMEWORK"with"CORDOVA_FRAMEWORK" 
3. Replace import occurrences of "<PhoneGap/" with "<Cordova/"
4. Replace class prefixes of PG with CDV (for example PGPlugin becomes CDVPlugin)
5. Replace occurrences of [self appViewController] with self.viewController.

1.5.0 Plugin Notes

1. The UIViewController returned from the viewController property will be a CDVViewController subclass.
2. The appDelegate method basically returns an (id) now, and is the same as calling [[UIApplication sharedApplication] delegate]. In the past it returned a PhoneGapDelegate class.
3. There is a new commandDelegate property now, which gives access to the CDVCommandDelegate protocol used by the app
4. There is a new header file CDVAvailability.h that defines Cordova versions during compile time - to check for the current version during run-time, call [CDVViewController cordovaVersion]
 

The MIT License

Copyright (c) 2010 Jesse MacFadyen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.