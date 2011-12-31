PhoneGap Twitter Plugin
================================

The Twitter plugin for PhoneGap allows you to take advantage of the Twitter integration that ships with iOS 5. Please note that to use the APIs you must compile the application on the iOS 5 SDK. The plugin will not cause any issues if it is run on a pre-iOS 5 OS as long as you always validate that the Twitter SDK is available (see **Twitter.isTwitterAvailable()**)

This is licensed under MIT.


Getting Started
===============

Download the latest version of PhoneGap from www.phonegap.com.

Create an iOS PhoneGap project (Android not yet supported)

Check out the /example/www/index.html to see how it works.

<pre>
|-native
|  |-ios
`-www
   `-TwitterPlugin.js
</pre>

/native/ios is the native code for the plugin on iOS

/www/TwitterPlugin.js is the JavaScript code for the plugin

iOS (Mac OS X)
===============

1. Create a basic PhoneGap iOS application. See http://www.phonegap.com/start/#ios-x4
2. From the **iPhone/Twitter** (aka the current) folder copy the contents of the **native/ios** folder into your app in Xcode (usually in the **Plugins** folder group). Make sure it is added as a "group" (yellow folder)
3. Find the PhoneGap.plist file in the project navigator, expand the "Plugins" sub-tree, and add a new entry. For the key, add **com.phonegap.twitter**, and its value will be **TwitterPlugin**
4. From the **PhoneGap Twitter Plugin** folder copy the contents of the **www** folder into the **www** directory in Xcode (don't forget to add script tags in your index.html to reference any .js files copied over)
5. Click on your project's icon (the root element) in Project Navigator, select your **Target**, and the **Build Phases** tab.
6. From the **Build Phases** tab, expand **Link Binary With Libraries**, then click on the **+** button
7. Select **Twitter.framework** and click Add, also select **Accounts.framework** and click Add
8. for Xcode 4, you will need to build it once, and heed the warning - this is an Xcode 4 template limitation. The warning instructions will tell you to drag copy the **www** folder into the project in Xcode (add as a **folder reference** which is a blue folder).
9. If you wish to allow users to share URLs and/or images you need to add a whitelist wildcard since you don't know which domains they'll reference. Simply add a wildcard entry (*) to external hosts whitelist (PhoneGap.plist/ExternalHosts).
10. Run the application in Xcode.


If you have issues with the app crashing with `EXC_BAD_ACCESS` on iOS Simulator you may have a weak linking issue. With your project highlighted in the left column in XCode go to Targets > Your Project > Build Settings > Linking > Other Linker Flags and replace `-weak_library` with `-weak-lSystem`
For more information see: http://stackoverflow.com/questions/6738858/use-of-blocks-crashes-app-in-iphone-simulator-4-3-xcode-4-2-and-4-0-2