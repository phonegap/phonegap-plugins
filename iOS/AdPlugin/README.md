# Cordova AdPlugin #
by Shazron Abdullah

## Adding the Plugin to your project ##

Using this plugin requires [Cordova](http://github.com/apache/incubator-cordova-ios) and iAd. iAd requires at least the [iOS 4 SDK](http://developer.apple.com/iphone).

1. Make sure your Cordova Xcode project has been [updated for Cordova 1.6.0](https://github.com/apache/incubator-cordova-ios/blob/master/guides/Cordova%20Plugin%20Upgrade%20Guide.md)
2. Add the "iAd" framework to your Frameworks folder, and set it to be weak linked (see "Weak Linking the iAd Framework" section below)
3. Add the .h and .m files to your Plugins folder in your project (as a Group "yellow folder" not a Reference "blue folder")
4. Add the .js files to your "www" folder on disk, and add reference(s) to the .js files as &lt;script&gt; tags in your html file(s)
5. In **Cordova.plist** (1.5.0 or greater) or **PhoneGap.plist** (1.4.1 or lesser), under the **Plugins** section, add an idential key and value of **"SAiOSAdPlugin"**
6. See the sample index.html
7. Make sure you check the **"RELEASE NOTES"** section below!
8. Your App must be added to [https://iad.apple.com/itcportal/](https://iad.apple.com/itcportal/) to make $

## Weak Linking the iAd Framework ##

1. In your project, under "Targets", double click on the Target item
2. Go to the "General" Tab, under "Linked Libraries" 
3. For the iAd Framework, change the value from "Required" to "Weak"

## FUTURE FEATURES ##
* Landscape mode iAds
* Showing of other ad network ads in place of iAds, if no iAds are available

## RELEASE NOTES ##

### 20120409 ###

- Changed license to Apache 2.0 License
- Updated for Cordova 1.6.0 (backwards compatible to earlier versions as well)
- wrapped object in function closure (to prevent pollution of the global namespace)

### 20120308 ###

- Cordova 1.5.0 support (@RandyMcMillan)

### 20100712 ###
* Initial release
* Only supports portrait iAd banners
* Not tested on a 3.x device
* WebView initial size being oversized is a PhoneGap Core issue, and is not addressed in this plugin. When an ad is shown, it correctly sizes the WebView, and when the ad is hidden, sets the WebView back to its original size.
* Not tested with any other native UI plugins, like TabBar, and will not play nice with them (until we get a better layout management system/plugin)

### 20110627 ###
* Requires PhoneGap 0.9.6
* Fixed size issues
* Orientation change handling
* Works on iPad 4.x
* Still does not play nice with other native UI plugins like TabBar (yet)

## BUGS AND CONTRIBUTIONS ##

Patches welcome! Send a pull request. Since this is not a part of Cordova Core (which requires an Apache iCLA), this should be easier.

Post issues in the [PhoneGap Google Groups](http://groups.google.com/group/phonegap), include in the subject heading - "AdPlugin" or on [Github](http://github.com/phonegap/phoneGap-plugins/issues)
(preferred)


## LICENSE ##

Copyright 2012 Shazron Abdullah

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
