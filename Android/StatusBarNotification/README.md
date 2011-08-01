# StatusBarNotification plugin for Phonegap #

Plugin allows you to display notifications in the status bar from your PhoneGap application.

## Adding the Plugin to your project ##

Using this plugin requires [Android PhoneGap](http://github.com/phonegap/phonegap-android).

1. To install the plugin, move statusbarnotification.js to your project's www folder and include a reference to it in your html file after phonegap.js.

    &lt;script type="text/javascript" charset="utf-8" src="phonegap.js"&gt;&lt;/script&gt;<br/>
    &lt;script type="text/javascript" charset="utf-8" src="statusbarnotification.js"&gt;&lt;/script&gt;

2. Create a directory within your project called "src/com/phonegap/plugins/statusBarNotification" and move StatusBarNotification.java into it.

3. Add the following activity to your AndroidManifest.xml file.  It should be added inside the &lt;application&gt; tag.

    &lt;activity android:name="com.phonegap.DroidGap" android:label="@string/app_name"&gt;<br/>
      &lt;intent-filter&gt;<br/>
      &lt;/intent-filter&gt;<br/>
    &lt;/activity&gt;

4. In your res/xml/plugins.xml file add the following line:

    &lt;plugin name="StatusBarNotification" value="com.phonegap.plugins.statusBarNotification.StatusBarNotification"/&gt;

## Using the plugin ##

The plugin creates the object `window.plugins.statusBarNotification`. To use, call one of the following, available methods:

<pre>
  /**
   * Displays new status bar notification
   * 
   * @param notificationTitle	The url to load
   * @param notificationBody	Load url in PhoneGap webview [optional] - Default: false
   */
   
  notify(notificationTitle, notificationBody);
</pre>

Sample use:

    window.plugins.statusBarNotification.notify("Put your title here", "Put your message here");

## License ##

Copyright (C) 2011 Dmitry Savchenko <dg.freak@gmail.com>

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