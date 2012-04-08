Project examples located in PayPalPlugin/.EXAMPLES  (hidden to minimize confusion when adding to xcode)

# PhoneGap PayPal-Plugin #
by Shazron Abdullah

## Adding the Plugin to your project ##

Using this plugin requires [iPhone PhoneGap](http://github.com/phonegap/phonegap-iphone) and the PayPal Mobile Payments Library. The PayPal Mobile Payments Library can be downloaded [here](https://www.x.com/community/ppx/xspaces/mobile/mep).

1. Make sure your PhoneGap Xcode project has been [updated for the iOS 4 SDK](http://wiki.phonegap.com/Upgrade-your-PhoneGap-Xcode-Template-for-iOS-4)
2. Add the "Paypal Mobile Payments" folder to your project (put in a suitable location under your project, then drag and drop it in)
3. Add the .h and .m files to your Plugins folder in your project
4. Add the .js files to your "www" folder on disk, and add reference(s) to the .js files as <link> tags in your html file(s)
5. See the sample project "PayPalPlugin-Host" for an example use (examine the code in www/index.html)
6. Make sure you check the "RELEASE NOTES" section below!

## RELEASE NOTES ##

### 20101008 ###
* Initial release
* By default the PayPalPlugin-Host runs in ENV_NONE (offline) with a dummy PayPal ID. Change these in the Objective-C source (the code warns you in the Console)
* Only tested with ENV_NONE (verified payment success and cancel work, payment failure has NOT been tested)
* You are not using the PayPal native button - the native button when overlaid on the UIWebView does not scroll up and down with the UIWebView. It is hidden, and through the .pay() function, it is triggered. You can style the .pay() trigger with an official web button image from PayPal itself.
* See the .js file for API docs, and the PayPalPlugin-Host/www/index.html for sample code

## BUGS AND CONTRIBUTIONS ##

Patches welcome! Send a pull request. Since this is not a part of PhoneGap Core (which requires a CLA), this should be easier.

Post issues in the [PhoneGap Google Groups](http://groups.google.com/group/phonegap), include in the subject heading - "PayPalPlugin" or on [Github](http://github.com/phonegap/phonegap-plugins/issues)
(preferred)

The latest code (my fork) will always be [here](http://github.com/shazron/phonegap-plugins/tree/master/iPhone/PayPalPlugin/)

## LICENSE ##

The MIT License

Copyright (c) 2010 Shazron Abdullah

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

