## NotificationEx - Adding the Plugin to your project ##

These are removed functions from PhoneGap core (Notification.loadingStart/Stop, and Notification.activityStart/Stop)
Using this plugin requires [iPhone PhoneGap](http://github.com/phonegap/phonegap-iphone) 1.0.0

1. Add all the .h and .m files to your Plugins folder in your project
2. Add the .js files to your "www" folder on disk, and add a reference to the .js file as &lt;script&gt; tags in your html file(s)
3. In your project's PhoneGap.plist, find the Plugins section. Add a new entry under there, the key is "NotificationEx", value is "NotificationEx".
4. See the sample index.html for usage examples

## LICENSE ##

**NotificationEx plugin** is [MIT licensed](http://www.opensource.org/licenses/mit-license.php) except for the code below:

**UIColorExpanded.h,.m** is [unknown currently](https://github.com/ars/uicolor-utilities), I have e-mailed the author.

**LoadingView.h,.m** license is licensed ["zlib" style](http://projectswithlove.com/about.html)