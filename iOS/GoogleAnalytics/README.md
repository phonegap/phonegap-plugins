# Cordova GoogleAnalytics Plugin #
by Jesse MacFadyen
updated by Olivier Louvignes
updated by Chris Kihneman

## Adding the Plugin to your project ##

Using this plugin requires [iOS Cordova](http://github.com/phonegap/phonegap-iphone) and the Google Analytics for Mobile Apps SDK (included). The Google Analytics for Mobile Apps SDK can be downloaded [here](http://code.google.com/mobile/analytics/download.html).

1. Make sure you are running Cordova(PhoneGap) 1.5.0
2. Drag and drop the `GoogleAnalytics` folder from Finder to your Plugins folder in XCode, using "Create groups for any added folders"
4. Include the CFNetwork framework in your project and link against libsqlite3.0.dylib.
5. Add the .js files to your `www` folder on disk, and add reference(s) to the .js files as <link> tags in your html file(s)
5. Add new entry with key `GoogleAnalyticsPlugin` and value `GoogleAnalyticsPlugin` to `Plugins` in `Cordova.plist`
6. Add `google-analytics.com` to `ExternalHosts` in `Cordova.plist`

## JAVASCRIPT INTERFACE ##

    // after device ready, create a local alias and start the tracker with your own id.
    var googleAnalytics = window.plugins.googleAnalyticsPlugin;
    googleAnalytics.startTrackerWithAccountID("UA-XXXXXXXX-X");

    // Track an event in your application
    // more here : http://code.google.com/apis/analytics/docs/tracking/eventTrackerGuide.html
    googleAnalytics.trackEvent("category", "action", "label goes here", 666);

    // Track an pageview in your application (must start with a slash)
    googleAnalytics.trackPageview("/test");

## BUGS AND CONTRIBUTIONS ##

Patches welcome! Send a pull request. Since this is not a part of Cordova Core (which requires a CLA), this should be easier.

Post issues in the [Cordova Google Groups](http://groups.google.com/group/phonegap), include in the subject heading - "GoogleAnalyticsPlugin" or on [Github](http://github.com/phonegap/phonegap-plugins/issues)
(preferred)

## LICENSE ##

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## DOCS & OTHER HELP ##

* Google documentation [here](http://code.google.com/mobile/analytics/docs/iphone/#gettingStarted)
* http://stackoverflow.com/questions/8097015/step-by-set-to-get-google-analytics-working-in-phonegap-1-2-0-on-ios-phonegapal
* http://stackoverflow.com/questions/8094604/differences-between-android-and-ios-when-using-google-analytics-in-phonegap-1-2
