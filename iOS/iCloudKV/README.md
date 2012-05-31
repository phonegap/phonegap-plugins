# iOS iCloud KeyValue Store plugin #
By Alex Drel

Allows storing small amounts of configuration data in iCloud from Cordova/Phonegap. Wraps NSUbiquitousKeyValueStore class.
## Adding the Plugin to your project ##

Copy the .h and .m file to the Plugins directory in your project. Copy the .js file to your www directory and reference it from your html file(s). 
Configure Your App’s iCloud Entitlements and create a provisioning profile (or update an existing profile) to use an App ID that is enabled for iCloud.

## Using the plugin ##

Please read [iCloud Storage IOS Programming Guide](http://developer.apple.com/library/ios/#documentation/iphone/conceptual/iphoneosprogrammingguide/iCloud/iCloud.html). Additional helpful resources are http://www.raywenderlich.com/6015/beginning-icloud-in-ios-5-tutorial-part-1 and http://useyourloaf.com/blog/2011/10/24/sync-preference-data-with-icloud.html blogs.

The plugin creates the object `iCloudKV` with the following methods:

    sync(successCallback/*(dictionary_with_all_sync_keys)*/ , failCallback) 
       In addition to calling NSUbiquitousKeyValueStore sync method the plugin's sync returns the dictionary holding all iCloud data for the app.
       Normally you only need to call the sync once - on application load. 
       Reminder: Calling sync does not guarantee (or matter for) syncrhonization with iCloud but only between the in-memory and the flash storage that will be eventually synced with iCloud by an independent agent.

    save(key, value, successCallback) 
       Saves string value for the key.
        
    load(key, successCallback/*(value)*/, failCallback) 
       Loads string value for the key.

    remove(key, successCallback) 
        Removes the key. 

    monitor(notificationCallback/*(value)*/, successCallback) 
        Monitor changes of the app's iCloud.

For the simplest (but probably sufficient for most apps) implementation you will only need two methods: sync (on page load) and save (each time a value is changed).

## BUGS AND CONTRIBUTIONS ##
The latest version is available [on GitHub](https://github.com/alexdrel/phonegap-plugins)
If you have a patch, fork my repo and send me a pull request. Submit bug reports on GitHub, please.
	
## Licence ##

The MIT License

Copyright (c) 2012 Alex Drel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.




