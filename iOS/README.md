#Cordova (iOS) plugins should be submitted here.


The [/iPhone](https://github.com/phonegap/phonegap-plugins/tree/master/iPhone) folder should be preserved for use with projects still using [PhoneGap 1.4.1](https://github.com/phonegap/phonegap/tags) and before.

* Added  ActionSheet (iOS) plugin with Cordova support.
* Added  AdPlugin (iOS) plugin with Cordova support.
* Added  AppBlade (iOS) plugin with Cordova support.
* Added  AppiraterPlugin (iOS) plugin with Cordova support.
* Added  ApplicationPreferences (iOS) plugin with Cordova support.
* Added  AudioRecord (iOS) plugin with Cordova support.
* Added  Badge (iOS) plugin with Cordova support.
* Added  BarcodeScanner (iOS) plugin with Cordova support.
* Added  CalendarPlugin (iOS) plugin with Cordova support.
* Added  ClipboardPlugin (iOS) plugin with Cordova support.
* Added  ChildBrowser (iOS) plugin with Cordova support.
* Added  DatePicker (iOS) plugin with Cordova support.
* Added  Diagnostic (iOS) plugin with Cordova support.
* Added  EmailComposer (iOS) plugin with Cordova support.
* Added  FileUploader (iOS) plugin with Cordova support.
* Added  Globalization (iOS) plugin with Cordova support.
* Added  GoogleAnalytics (iOS) plugin with Cordova support.
* Added  InAppPurchaseManager (iOS) plugin with Cordova support.
* Added  Keychain (iOS) plugin with Cordova support.
* Added  LocalNotifications (iOS) plugin with Cordova support.
* Added  LowLatencyAudio (iOS) plugin with Cordova support.
* Added  MapKit (iOS) plugin with Cordova support.
* Added  MessageBox (iOS) plugin with Cordova support.
* Added  NativeControls (iOS) plugin with Cordova support.
* Added  NavigationBar (iOS) plugin with Cordova support.
* Added  NotificationEx (iOS) plugin with Cordova support.
* Added  OCRPlugin (iOS) plugin with Cordova support.
* Added  PayPalPlugin (iOS) plugin with Cordova support.
* Added  PickerView (iOS) plugin with Cordova support.
* Added  PowerManagement (iOS) plugin with Cordova support.
* Added  PrintPlugin (iOS) plugin with Cordova support.
* Added  ProgressHud (iOS) plugin with Cordova support.
* Added  PushNotification (iOS) plugin with Cordova support.
* Added  SMSComposer (iOS) plugin with Cordova support.
* Added  Screenshot (iOS) plugin with Cordova support.
* Added  SecureDeviceIdentifier (iOS) plugin with Cordova support.
* Added  ShareKitPlugin (iOS) plugin with Cordova support.
* Added  TabBar (iOS) plugin with Cordova support.
* Added  Testflight (iOS) plugin with Cordova support.
* Added  Twitter (iOS) plugin with Cordova support.
* Added  UAPushNotifications (iOS) plugin with Cordova support.
* Added  UniqueIdentifier (iOS) plugin with Cordova support.
* Added  VolumeSlider (iOS) plugin with Cordova support.
* Added  WebInspector (iOS) plugin with Cordova support.
* Added  card.io (iOS) plugin with Cordova support.
* Added  iCloudKV (iOS) plugin with Cordova support.
* More added regularly.

Please refer to the Plugin Upgrade Guides distributed in the [download](http://phonegap.com/download/) for the most current version.


#Cordova Plugin Upgrade Guide
This document is for developers who need to upgrade their Cordova plugins to a newer Cordova version. Starting with Cordova 1.5.0, some classes have been renamed, which will require the plugin to be upgraded. Make sure your project itself has been upgraded using the "Cordova Upgrade Guide" document.Upgrading older Cordova plugins to 2.0.01. Install Cordova 2.0.02. Follow the "Upgrading older Cordova plugins to 1.9.0" section, if necessary3. No changes in plugin structure from 1.9.x4. Change in import header use: in 2.0.0, Cordova projects use the CordovaLib project as a subproject, it now uses the CORDOVA_FRAMEWORK styled import like this:<br>        <code>#import  <Cordova/CDV.h></code>
instead of like this:<br>
<code>#import "CDV.h"</code>
So now in 2.0.0, Cordova import headers are unified.NOTE: The deprecated for 2.0.0 CDVPlugin methods verifyArguments and appViewController have been removed.
##Upgrading older Cordova plugins to 1.9.01. Install Cordova 1.9.02. Follow the "Upgrading older Cordova plugins to 1.8.0" section, if necessary 3. No changes in plugin structure from 1.8.x
##Upgrading older Cordova plugins to 1.8.01. Install Cordova 1.8.02. Follow the "Upgrading older Cordova plugins to 1.7.0" section, if necessary 3. No changes in plugin structure from 1.7.x##Upgrading older Cordova plugins to 1.7.01. Install Cordova 1.7.02. Follow the "Upgrading older Cordova plugins to 1.6.0" section, if necessary 3. No changes in plugin structure from 1.6.x##Upgrading older Cordova plugins to 1.6.x
1. Install Cordova 1.6.x2. Follow the "Upgrading older Cordova plugins to 1.5.0" section, if necessary3. See the 1.6.0 Plugin Notes section for new functionality available to plugins4. The global "Cordova" (upper-case C) was renamed to "cordova" (lower-case c) to match the cordova-js Android implementation in 1.5.0 that is now common to Android, Blackberry and iOS. Please rename your calls to reflect the new lower-case c, or you can add a shim (which will support older versions) like so:5. Wrap your plugin JavaScript in a temporary scope (self-executing function) - see "Temporary Scope" or this b. Inside your temporary scope, set a local var to the global PhoneGap/Cordova/cordova object, for the execfunctionvar cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks6. Replace any PhoneGap or Cordova or cordova in your plugin JavaScript (within the temporary scope), with cordovaRef above.
##Upgrading older Cordova plugins to 1.5.01. Install Cordova 1.5.02. Replacemacrooccurrencesof"PHONEGAP_FRAMEWORK"with"CORDOVA_FRAMEWORK" 3. Replace import occurrences of "<PhoneGap/" with "<Cordova/"4. Replace class prefixes of PG with CDV (for example PGPlugin becomes CDVPlugin)5. Replace occurrences of [self appViewController] with self.viewController.6. See the 1.5.0 Plugin Notes section for new functionality available to plugins##1.6.0 Plugin Notes1. There is a new CDVCommandDelegate protocol method available:- (void) registerPlugin:(CDVPlugin*)plugin withClassName:(NSString*)className;You use this in your plugin to initialize another plugin that your plugin needs to be available and running (dependency), and all plugins can access the registered plugin from the getCommandInstance method of the CDVCommandDelegate. This is a substitute for listing a plugin your plugin depends on, in Cordova.plist/Plugins.2. There is a new IsAtLeastiOSVersion macro available in CDVAvailability.h:// Returns YES if it is at least version specified as NSString(X) if (IsAtLeastiOSVersion(@"5.1")) {// do something for iOS 5.1 or greater }3. There are Compatibility headers available for versions 0.9.6 and 1.5.0, in ~/Documents/CordovaLib/Classes/compatibility (where ~ signifies your Home folder). See the "README.txt" in that folder for instructions.Note that including these headers are all or nothing - you can't have a mix and match of plugin versions, if you include the 0.9.6 compatibility header - all your plugins must be of the same "version". It is highly recommended that you upgrade your plugins to the current version instead of using these stop-gap headers.The 1.5.0 header shouldn't be used - this is included for the LocalStorage patch and is for using core plugins as general plugins that easily support multiple versions, and may be removed in the future.1.5.0 Plugin Notes1. The UIViewController returned from the viewController property will be a CDVViewController subclass.2. The appDelegate method basically returns an (id) now, and is the same as calling [[UIApplicationsharedApplication] delegate]. In the past it returned a PhoneGapDelegate class.3. There is a new commandDelegate property now, which gives access to the CDVCommandDelegate protocolused by the app4. There is a new header file CDVAvailability.h that defines Cordova versions during compile time - to check forthe current version during run-time, call [CDVViewController cordovaVersion]￼￼Cordova 2.0.0 Plugin Upgrade Guide 2/2


#The MIT License

Copyright (c) 2010 Jesse MacFadyen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
