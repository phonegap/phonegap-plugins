Phonegap SQLitePlugin
=====================

This plugin allows downloading files from http urls just like its [android
counterpart](https://github.com/phonegap/phonegap-plugins/tree/master/Android/Downloader) does, with the same API. 

- "Plugins/" contains objc source code of the plugin
- "www/" contains
    - coffeescript version of the plugin
    - javascript compiled version
    - an example of how it can be used


Notes on ARC: 
This plugin does not use the new iOS ARC facility. It's possible to convert it to ARC with the automatic XCode procedure. You will also have to change @property lines. Be careful to avoid Reference Cycles since DownloaderTasks retains NSURLConnection and NSURLConnection retains the DownloaderTask as it's delegate. One of the @property should be set to weak.

Installing
==========

Drag .h and .m files into your project's Plugins folder (in xcode) -- I always
just have "Create references" as the option selected.

Take the precompiled javascript file from www/, or compile the coffeescript
file (.coffee) to javascript WITH the top-level function wrapper option (default).

Use the resulting javascript file in your HTML.

Look for the following to your project's PhoneGap.plist:

    <key>Plugins</key>
    <dict>
      ...
    </dict>

Insert this in there:

    <key>Downloader</key>
    <string>Downloader</string>

General Usage
=============

Look at www/index.html for a very simple example.

Note that you can also download multiple files at once. Also this plugin ALWAYS OVERWRITES if the target file already exists.
