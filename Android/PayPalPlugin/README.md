# PhoneGap PayPal-Plugin #
by Paul Beusterien, Mobile Developer Solutions and Carl Stehle, Appception Inc.


## Adding the Plugin to your project ##

Using this plugin requires Android PhoneGap and the PayPal Mobile Payments Library. The PayPal Mobile Payments Library can be downloaded [here](https://www.x.com/community/ppx/xspaces/mobile/mep).

1. Create an Android PhoneGap project. Details at http://www.mobiledevelopersolutions.com/home/start
2. Put PayPal_MPL.jar into your project's libs directory and add it to the build path. In Eclipse, right click on PayPal_MPL.jar and select Add to Build Path.
3. Copy assets/www/ files into your project's assets/www/ directory
4. Copy src/com/phonegap/plugin/ files into your project's src/com/phonegap/plugin/ directory
5. Make sure your AndroidManifest.xml includes a superset of the permissions shown in the reference AndroidManifest.xml
6. Add the com.paypal.android.MEP.PayPalActivity as shown in the reference AndroidManifest.xml
7. Make sure the phonegap.{version}.js filename in index.html matches the filename in your www directory.
8. Deploy and test the app. The default environment is ENV_NONE.

## Using the PayPal Sandbox ##

1. Set up a PayPal buyer and seller sandbox account from https://developer.paypal.com/
2. Update demo.js to use ENV_SANDBOX instead of ENV_NONE. See comments near bottom of demo.js
3. In index.html, update the pmt_recipient field to your sandbox seller account


## RELEASE NOTES ##

### 201100618 ###
* Initial release
* By default the PayPalPlugin-Host runs in ENV_NONE (offline) with a dummy PayPal ID. Change to ENV_SANDBOX or ENV_LIVE
* Only tested with ENV_NONE and ENV_SANDBOX 
* The default payment type is HARD_GOODS. Change initializeMPL method in demo.js to one of the PayPalPaymentType's listed at the bottom of paypal.js
* For API docs, see the assets/www/paypal.js. For sample code, see assets/www/demo.js and assets/www/index.html.

## BUGS AND CONTRIBUTIONS ##

Patches welcome! Send a pull request. Since this is not a part of PhoneGap Core (which requires a CLA), this should be easier.

Post issues in the [PhoneGap Google Groups](http://groups.google.com/group/phonegap), include in the subject heading - "PayPalPlugin" or on [Github](http://github.com/phonegap/phonegap-plugins/issues)
(preferred)
