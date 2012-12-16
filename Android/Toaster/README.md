# Toaster plugin for Cordova #

This plugin allows you to display a toaster notification in the main screen of your Cordova application.

## Adding the Plugin to your project ##

Using this plugin requires [Android Cordova](http://github.com/apache/incubator-cordova-android).

1. To install the plugin, move toaster.js to your project's www folder and include a reference to it in your html file after cordova.js.

    &lt;script type="text/javascript" charset="utf-8" src="cordova.js"&gt;&lt;/script&gt;<br/>
    &lt;script type="text/javascript" charset="utf-8" src="toaster.js"&gt;&lt;/script&gt;

2. Create a directory within your project called "src/com/phonegap/plugins/toaster" and move the .java files from this folder into it.

3. In your res/xml/plugins.xml file add the following line:

    &lt;plugin name="Toaster" value="com.phonegap.plugins.Toaster"/&gt;

   CAUTION: Using PhoneGap &ge; 2.0 (aka Cordova) you have to add this line into res/xml/config.xml in the &lt;plugins&gt;-section.
The plugins.xml is no longer supported. The plugins are all located in the config.xml

	
## Using the plugin ##

The plugin creates the object `window.plugins.toaster`.

Sample use:

    window.plugins.toaster.show({
            message: "Put your message here"
        },
        function() { }, // success
        function() { } // error
    );

## License ##

Copyright (C) 2012 Jonathan Parker <jonathanparkeremail@gmail.com>

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