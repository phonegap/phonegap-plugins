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
