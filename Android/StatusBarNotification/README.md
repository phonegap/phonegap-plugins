# StatusBarNotification plugin for Cordova #

This plugin allows you to display notifications in the status bar from your Cordova application. On Android you have to explicitly add things to the status bar (as opposed to iOS where push notifications automatically get displayed in the UI). The Android status bar is the UI component at the top of the screen that has a bunch of little icons. You can also drag the status bar down to view a list of notifications.

## Adding the Plugin to your project ##

Using this plugin requires [Android Cordova](http://github.com/apache/incubator-cordova-android).

1. To install the plugin, move statusbarnotification.js to your project's www folder and include a reference to it in your html file after cordova.js.

    &lt;script type="text/javascript" charset="utf-8" src="cordova.js"&gt;&lt;/script&gt;<br/>
    &lt;script type="text/javascript" charset="utf-8" src="statusbarnotification.js"&gt;&lt;/script&gt;

2. Create a directory within your project called "src/com/phonegap/plugins/statusBarNotification" and move the .java files from this folder into it.

3. In your res/xml/plugins.xml file add the following line:

    &lt;plugin name="StatusBarNotification" value="com.phonegap.plugins.statusBarNotification.StatusBarNotification"/&gt;

   CAUTION: Using PhoneGap &ge; 2.0 (aka Cordova) you have to add this line into res/xml/config.xml in the &lt;plugins&gt;-section.
The plugins.xml is no longer supported. The plugins are all located in the config.xml


4. You will need to add a notification.png file to your applications res/drawable-ldpi, res/drawable-mdpi & res/drawable-hdpi or res/drawable-xhdpi directories (depending on what resolutions you want to support).

5. You will need to add an import line like this to the .java files (see commented out lines inside the files):

	import com.my.app.R; 
6. If you need the notification to stick, you can pass a paramter to notify function. 
	E.g.:
	   window.plugins.statusBarNotification.notify("Put your title here", "Put your sticky message here", Flag.FLAG_NO_CLEAR);
           //you can then use clear function to remove it.
	   window.plugins.statusBarNotification.clear();
	
## Using the plugin ##

The plugin creates the object `window.plugins.statusBarNotification`.

Sample use:

    window.plugins.statusBarNotification.notify("Put your title here", "Put your message here");

## License ##

Copyright (C) 2011 Dmitry Savchenko <dg.freak@gmail.com>
Copyright (C) 2012 Max Ogden <max@maxogden.com>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
