# PhoneGap iOS Map Plugin #

## Adding the Plugin to your project ##

Using this plugin requires [iOS PhoneGap](http://github.com/phonegap/phonegap-iphone) and the MapKit framework.

1. Add the "MapKit" framework to your Xcode project (different in Xcode 3 and 4, search for instructions)
2. Add the .h and .m files to your Plugins folder in your project
3. Add the .js files to your "www" folder on disk, and add reference(s) to the .js files as &lt;script&gt; tags in your html file(s)
4. In your app's [APPNAME]-Info.plist, expand "Plugins", and add a new string key and value under it. For the key, add "MapKitView" (left column) for the key, and add "MapKitView" for the value (right column).

