AppBladeSDK PhoneGap Plugin
===================

Plugin for PhoneGap that uses the AppBlade SDK.


##Installation - iOS

1. Copy `AppBlade.js` from into your `www` directory.
2. Copy `AppBladePlugin.[hm]` into your Plugins folder.
3. Follow directions for [adding plugins to your iOS project](http://wiki.phonegap.com/w/page/43708792/How%20to%20Install%20a%20PhoneGap%20Plugin%20for%20iOS).
3. Follow directions for [adding the AppBlade SDK to your project](http://github.com/AppBlade/SDK), but do not edit the `AppDelegate`.
4. Add `-all_load` to the `other linker flags` build setting for your target.
5. In your `index.html`, register for the `"deviceready"` eventListener, and call the setup method with your SDK keys in this order: project, token, secret, issued timestamp.

See the Example project included for examples using the other functions of the SDK.

##Resources:
###[AppBlade.com](https://appblade.com/)
###[License and Terms](https://appblade.com/terms_of_use)