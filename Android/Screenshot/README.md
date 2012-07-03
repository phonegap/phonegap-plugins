Screenshot
===============
Plugin for Cordova (1.6+)

The Screenshot plugin allows your application to take screenshots of the current screen and save them into the phone.

Platforms
---------
Currently available on:

### Android
Copy the content of *src* folder to your *src* folder.

Copy the content of *www* folder to you *www* folder.

Edit your *AndroidManifest.xml* and add the following permission:
`<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />`

In addition you have to edit your *res/xml/plugins.xml* file to let Cordova know about the plugin:
`<plugin name="Screenshot" value="org.apache.cordova.Screenshot"/>`

### iOS
Copy the *Screenshot.h* and *Screenshot.m* files to your projects "Plugins" folder.

Copy the *Screenshot.js* file to you *www* folder.

Add the Screenshot plugin to the *Cordova.plist* file (to the Plugins list). Both Key and Value are "Screenshot".


License
=======
Copyright (C) 2012 30ideas (http://30ide.as)
MIT licensed
 
Created by Josemando Sobral
Jul 2nd, 2012
