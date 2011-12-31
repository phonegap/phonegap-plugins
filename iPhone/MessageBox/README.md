# PhoneGap MessageBox Plugin #
by `Olivier Louvignes`

## DESCRIPTION ##

* This plugin provides an unified API to use the `UIAlertView` native component from IOS. It does comply with the latest (future-2.x) phonegap standards.

* Compared to the `iPhone/Prompt` plugin, it is more documented & simpler to understand. It does also provide new options for prompt (message, multiline, input type password).

* There is a `Sencha Touch 2.0` plugin to easily leverage this plugin [here](https://github.com/mgcrea/sencha-touch-plugins/blob/master/PhonegapMessageBox.js)

## SETUP ##

Using this plugin requires [iPhone PhoneGap](http://github.com/phonegap/phonegap-iphone).

1. Make sure your PhoneGap Xcode project has been [updated for the iOS 4 SDK](http://wiki.phonegap.com/Upgrade-your-PhoneGap-Xcode-Template-for-iOS-4)
2. Drag and drop the `MessageBox` folder from Finder to your Plugins folder in XCode, using "Create groups for any added folders"
3. Add the .js files to your `www` folder on disk, and add reference(s) to the .js files as <link> tags in your html file(s)
4. Add new entry with key `MessageBox` and value `MessageBox` to `Plugins` in `PhoneGap.plist`

## JAVASCRIPT INTERFACE ##

    // After device ready, create a local alias
    var messageBox = window.plugins.messageBox;

    // Alert
    messageBox.alert('Title', 'Message', function(button) { console.warn('alert', [this, arguments]); });

    // Confirm
    messageBox.confirm('Title', 'Message', function(button) { console.warn('confirm', [this, arguments]); });

    // Default prompt
    messageBox.prompt('Title', 'Message', function(button, value) { console.warn('prompt', [this, arguments]); });

    // Prompt a password
    messageBox.prompt('Please enter your password', '', function(button, value) { console.warn('prompt', [this, arguments]); }, {placeholder: 'password', type: 'password'});

* Check [source](http://github.com/mgcrea/phonegap-plugins/tree/master/iPhone/MessageBox/MessageBox.js) for additional configuration.

## BUGS AND CONTRIBUTIONS ##

Patches welcome! Send a pull request. Since this is not a part of PhoneGap Core (which requires a CLA), this should be easier.

Post issues on [Github](http://github.com/phonegap/phonegap-plugins/issues)

The latest code (my fork) will always be [here](http://github.com/mgcrea/phonegap-plugins/tree/master/iPhone/MessageBox/)

## LICENSE ##

Copyright 2011 Olivier Louvignes. All rights reserved.

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## CREDITS ##

Inspired by :

* [Prompt Phonegap plugin](https://github.com/phonegap/phonegap-plugins/tree/master/iPhone/Prompt)

* [MessageBox Sencha Touch 2.0 class](http://docs.sencha.com/touch/2-0/#!/api/Ext.MessageBox)
