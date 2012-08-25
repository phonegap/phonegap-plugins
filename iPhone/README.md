This code is completely dependent on the <= [PhoneGap 1.4.1](https://github.com/apache/incubator-cordova-ios/tree/1.4.1) project, also hosted on
GitHub ( [https://github.com/apache/incubator-cordova-ios/tree/1.4.1](https://github.com/apache/incubator-cordova-ios/tree/1.4.1) )

This folder is for <= Phonegap 1.4.1 [/iPhone](https://github.com/phonegap/phonegap-plugins/tree/master/iPhone) specific plugins.
Please include a ReadMe.md in your plugin, and preferably some sample code for how to use it.

Please submit PhoneGap/Cordova 1.5.0+ plugin versions for iOS under the [/iOS](https://github.com/phonegap/phonegap-plugins/tree/master/iOS) repository.

Reference: [https://github.com/phonegap/phonegap-plugins/blob/master/iOS/README.md](https://github.com/phonegap/phonegap-plugins/blob/master/iOS/README.md)

Reference: [https://github.com/phonegap/phonegap-plugins/issues/487](https://github.com/phonegap/phonegap-plugins/issues/487)





The MIT License

Copyright (c) 2010 Nitobi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.




Plugin Installation.
The exact manner of using a plugin in iPhone PhoneGap will likely vary with each plugin, so the following is a general rule for how to set things up to use a plugin.

A simple plugin will likely be just 3 files, generally PluginName.m, PluginName.h, and PluginName.js
The .m/.h files need to be added to your XCode project and this must be done through XCode so that XCode is aware that these files are to be compiled and linked to the application.  You can do this by manually copying the files into your project's plugins folder and from within XCode select your plugins folder, right click and choose 'Add Existing Files...' and select the files you already put in the plugins folder.

You may also choose to save a step and simply select your XCode project plugins folder, right click and choose 'Add Existing Files...' and find the files within your plugin repo, then choose copy so XCode will duplicate the files for you.

The PluginName.js is generally moved into the www folder manually and NOT a part of the XCode project. You can do this on the file-system directly by copying the file over.  Be sure to include the PluginName.js with a script tag in your html file that will interact with it, and do this AFTER including phonegap.js 

Generally you will see instructions on how to interact with the plugin, but this is up to the authors/contributors. 

Some general rules for interacting with plugins:

- do NOT call plugin methods until after the 'deviceready' event has fired.
- some plugins need to be explicitly installed. 
  ex. ChildBrowser.install();
- plugins are usually installed in the DOM at window.plugins.pluginName 
- do NOT call prototype methods, call instance methods
  ex. EmailComposer.prototype.showEmailComposer( ... 
          // WRONG, this is the definition of the method, and not the actual instance method.
  ex. window.plugins.emailComposer.showEmailComposer( ...
          // CORRECT, this is calling an instance method.

- if using the Xcode 4 Template using the PhoneGap.framework, see https://github.com/phonegap/phonegap-plugins/issues/21





