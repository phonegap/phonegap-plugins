# Cordova Keychain Plugin #
by Shazron Abdullah

## Adding the Plugin to your project ##

Using this plugin requires [iOS Cordova](http://github.com/apache/incubator-cordova-ios) and Xcode 4.

1. Make sure your Cordova Xcode project has been [updated for Cordova 1.6.0](https://github.com/apache/incubator-cordova-ios/blob/master/guides/Cordova%20Plugin%20Upgrade%20Guide.md)
2. Add the .h and .m files to your Plugins folder in your project (as a Group "yellow folder" not a Reference "blue folder")
3. Add the .js files to your "www" folder on disk, and add reference(s) to the .js files as &lt;script&gt; tags in your html file(s)
4. In **Cordova.plist** (1.5.0 or greater) or **PhoneGap.plist** (1.4.1 or lesser), under the **Plugins** section, add an idential key and value of **"SAiOSKeychainPlugin"**
5. Add the **"Security.framework"** to your project's Target, in the **Build Phase** tab - **Link Binary with Libraries**


## RELEASE NOTES ##

### 20120709 ###

* Updated for Cordova

### 20101105 ###
* Initial release
* See the .js file for API docs, and the KeychainPlugin-Host/www/index.html for sample code

## BUGS AND CONTRIBUTIONS ##

Patches welcome! Send a pull request. Since this is not a part of Cordova Core (which requires an Apache iCLA), this should be easier.

Post issues in the [PhoneGap Google Groups](http://groups.google.com/group/phonegap), include in the subject heading - "KeychainPlugin" or on [Github](http://github.com/phonegap/phonegap-plugins/issues)
(preferred)

## LICENSE ##

SFHFKeychainUtils code by:
  Created by Buzz Andersen on 10/20/08.
  Based partly on code by Jonathan Wight, Jon Crosby, and Mike Malone.
  Copyright 2008 Sci-Fi Hi-Fi. All rights reserved.

The rest:

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

