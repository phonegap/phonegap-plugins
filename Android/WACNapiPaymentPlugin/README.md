# WAC Napi Payment Plugin #
by WAC Application Services Ltd.

## Adding the Plugin to your project ##
Using this plugin requires Android PhoneGap and the WAC PhoneGap Plugin Library. The WAC Library can be downloaded [here](http://www.wacapps.net/c/document_library/get_file?uuid=442d5263-e438-4f87-a723-4d6400256400&groupId=155802).

1. Create your Android PhoneGap project. Details at http://phonegap.com/start/#android

2. From WAC_PhoneGap_Plugin_Library, (a) move wacphonegap-1.0.1.jar and wac-1.0.2.jar into your project's libs directory and (b) add them to your build path. 

3. Copy the files in WACNapiPaymentPlugin/assets/www/ into your assets/www/ folder.

4. Using WACNapiPaymentPlugin/AndroidManifest.xml as a reference, update your AndroidManifest.xml file with (a) a superset of the permissions and (b) net.wacapps.napi.android.WacNapiPayment.

5. Make sure the file name for phonegap.{version}.js in your index.html matches the file name in your www directory.

6. Create your WAC API keys as explained in WAC_PhoneGap_Plugin_Library/Managing WAC Payment API Keys.pdf. 

7. Configure the WAC API keys you created in the onDeviceReady() function of the demo.js file.  (Currently this file points to the WAC TEST environment. Update this configuration to use your own unique API keys.)

8. Deploy and test your app.

## RELEASE NOTES ##

### 20120329 ###
* Initial release
* For API docs, see the assets/www/wac.js. For sample code, see assets/www/demo.js and assets/www/index.html.

### 20120411 ###
* New checkBillingAvailability() API has been added to check if Wac billing is available.
* Bug fixes related to callback functions

## BUGS AND CONTRIBUTIONS ##

Patches are welcome, send a pull request. Since this is not a part of PhoneGap Core (which requires a CLA), this should be easier.

Post issues in the [PhoneGap Google Groups](http://groups.google.com/group/phonegap), include in the subject heading - "WACNapiPlugin" or on [Github](http://github.com/phonegap/phonegap-plugins/issues)
(preferred)