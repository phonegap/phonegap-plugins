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

# Cordova Plugin Upgrade Guide #

This document is for developers who need to upgrade their Cordova  plugins to a newer Cordova version. Starting with Cordova 1.5.0, some classes have been renamed, which will require the plugin to be upgraded. Make sure your project itself has been upgraded using the "Cordova Upgrade Guide" document.


## Upgrading older Cordova plugins to 1.6.0 ##

1. **Install** Cordova 1.6.0
2. Follow the **"Upgrading older Cordova plugins to 1.5.0"** section, if necessary
3. See the **1.6.0 Plugin Notes** section for new functionality available to plugins
4. The global **"Cordova"** (upper-case C) was renamed to **"cordova"** (lower-case c) to match the cordova-js Android implementation in 1.5.0 that is now common to Android, Blackberry and iOS. Please rename your calls to reflect the new lower-case **c**, or you can add a shim (which will support older versions) like so:

    a. Wrap your plugin JavaScript in a temporary scope (self-executing function) - see ["Temporary Scope"](http://ejohn.org/apps/learn/#57) or [this](https://github.com/phonegap/phonegap-plugins/wiki/Wrapping-your-Plugin's-JavaScript)
    
    b. Inside your temporary scope, set a **local var** to the global PhoneGap/Cordova/cordova object, for the exec function
    
            var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks
        
    c. Replace any **PhoneGap** or **Cordova** or **cordova** in your plugin JavaScript (within the temporary scope), with **cordovaRef** above
        


## Upgrading older Cordova plugins to 1.5.0 ##

1. **Install** Cordova 1.5.0
2. Replace macro occurrences of **"PHONEGAP\_FRAMEWORK"** with **"CORDOVA\_FRAMEWORK"**
3. Replace import occurrences of **"&lt;PhoneGap/"** with **"&lt;Cordova/"**
4. Replace class prefixes of **PG** with **CDV** (for example **PG**Plugin becomes **CDV**Plugin)
5. Replace occurrences of **[self appViewController]** with **self.viewController**. 
6. See the **1.5.0 Plugin Notes** section for new functionality available to plugins

## 1.6.0 Plugin Notes ##

1. There is a new CDVCommandDelegate protocol method available:

        - (void) registerPlugin:(CDVPlugin*)plugin withClassName:(NSString*)className;
    
    You use this in your plugin to initialize another plugin that your plugin needs to be available and running (dependency), and all plugins can access the registered plugin from the **getCommandInstance** method of the CDVCommandDelegate. This is a substitute for listing a plugin your plugin depends on, in **Cordova.plist/Plugins**.
2. There is a new **IsAtLeastiOSVersion** macro available in **CDVAvailability.h**:

        // Returns YES if it is at least version specified as NSString(X)
        if (IsAtLeastiOSVersion(@"5.1")) {
            // do something for iOS 5.1 or greater
        }
3. There are **Compatibility headers** available for versions 0.9.6 and 1.5.0, in **~/Documents/CordovaLib/Classes/compatibility** (where ~ signifies your Home folder). See the **"README.txt"** in that folder for instructions. 
    
    Note that including these headers are all or nothing - you can't have a mix and match of plugin versions, if you include the 0.9.6 compatibility header - all your plugins must be of the same "version". It is highly recommended that you upgrade your plugins to the current version instead of using these stop-gap headers. 
    
    The 1.5.0 header shouldn't be used - this is included for the [LocalStorage patch](https://issues.apache.org/jira/browse/CB-330) and is for using core plugins as general plugins that easily support multiple versions, and may be removed in the future.


## 1.5.0 Plugin Notes ##

1. The UIViewController returned from the **viewController property** will be a CDVViewController subclass.
2. The **appDelegate method** basically returns an (id) now, and is the same as calling **[[UIApplication sharedApplication] delegate]**. In the past it returned a PhoneGapDelegate class.
3. There is a new **commandDelegate property** now, which gives access to the [CDVCommandDelegate protocol](https://github.com/apache/incubator-cordova-ios/blob/master/CordovaLib/Classes/CDVCommandDelegate.h) used by the app
4. There is a new header file **CDVAvailability.h** that defines Cordova versions during compile time - to check for the current version during run-time, call **[CDVViewController cordovaVersion]**


The MIT License

Copyright (c) 2010 Jesse MacFadyen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.