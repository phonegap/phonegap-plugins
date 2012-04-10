Project examples located in PayPalPlugin/.EXAMPLES  (hidden to minimize confusion when adding to xcode)

# PhoneGap PayPal-Plugin #
by Shazron Abdullah

## Adding the Plugin to your project ##

Using this plugin requires [Cordova](http://github.com/apache/incubator-cordova-ios) and the PayPal Mobile Payments Library. The PayPal Mobile Payments Library can be downloaded [here](https://www.x.com/community/ppx/xspaces/mobile/mep).

1. Make sure your Cordova Xcode project has been [updated for Cordova 1.6.0](https://github.com/apache/incubator-cordova-ios/blob/master/guides/Cordova%20Plugin%20Upgrade%20Guide.md)
2. Add the "Paypal Mobile Payments" folder to your project (put in a suitable location under your project, then drag and drop it in)
3. Add the .h and .m files to your Plugins folder in your project (as a Group "yellow folder" not a Reference "blue folder")
4. Add the .js files to your "www" folder on disk, and add reference(s) to the .js files as &lt;script&gt; tags in your html file(s)
5. In **Cordova.plist** (1.5.0 or greater) or **PhoneGap.plist** (1.4.1 or lesser), under the **Plugins** section, add an idential key and value of **"SAiOSPaypalPlugin"**
6. Make sure you check the **"RELEASE NOTES"** section below!

## RELEASE NOTES ##

### 20120409 ###
- Changed license to Apache 2.0 License
- Updated for Cordova 1.6.0 (backwards compatible to earlier versions as well)
- wrapped object in function closure (to prevent pollution of the global namespace)
- global constants are now namespaced under the global PayPal object

    e.g if it was **PayPalPaymentType.DONATION** before, it's **PayPal.PaymentType.Donation** now
        and it is also accessible under **window.plugins.paypal.PaymentType.Donation**


### 20101008 ###
* Initial release
* By default the PayPalPlugin-Host runs in ENV_NONE (offline) with a dummy PayPal ID. Change these in the Objective-C source (the code warns you in the Console)
* Only tested with ENV_NONE (verified payment success and cancel work, payment failure has NOT been tested)
* You are not using the PayPal native button - the native button when overlaid on the UIWebView does not scroll up and down with the UIWebView. It is hidden, and through the .pay() function, it is triggered. You can style the .pay() trigger with an official web button image from PayPal itself.
* See the .js file for API docs, and the PayPalPlugin-Host/www/index.html for sample code

## BUGS AND CONTRIBUTIONS ##

Patches welcome! Send a pull request. Since this is not a part of Cordova Core (which requires an Apache iCLA), this should be easier.

Post issues in the [PhoneGap Google Groups](http://groups.google.com/group/phonegap), include in the subject heading - "PayPalPlugin" or on [Github](http://github.com/phonegap/phonegap-plugins/issues)
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

