# PhoneGap Globalization Plugin #
by IBM

## Adding the Plugin to your project ##

Using this plugin requires [Apache Cordova for Android](https://github.com/apache/incubator-cordova-android).

1. To install the plugin, copy globalization.js to your project's www folder and include a reference to it in your html file after cordova.js.

    &lt;script type="text/javascript" charset="utf-8" src="cordova-1.5.0.js"&gt;&lt;/script&gt;<br/>
    &lt;script type="text/javascript" charset="utf-8" src="globalization.js"&gt;&lt;/script&gt;

2. Create a directory within your project called "src/com/phonegap/plugins/globalization" and copy GlobalizationCommand.java, GlobalizationError.java and Resources.java into it.

3. In your res/xml/plugins.xml file add the following line:

    &lt;plugin name="GlobalizationCommand" value="com.phonegap.plugins.globalization.GlobalizationCommand"/&gt;


## RELEASE NOTES ##

### 20110627 ###
* Initial release
* See the .js file for API docs
* A globalization.tests.js file is provide to run with qunit as part of Mobile-Spec [Github](http://github.com/phonegap/mobile-spec)

### 20120312 ###
* Updated for Cordova 1.5.0

## BUGS AND CONTRIBUTIONS ##

Patches welcome! Send a pull request.  Requires a [CLA](https://files.pbworks.com/download/qH1OfztZ1d/phonegap/31724031/NitobiPhoneGapCLA.pdf).

Post issues in the [PhoneGap Google Groups](http://groups.google.com/group/phonegap), include in the subject heading - "GlobalizationPlugin" or on [Github](http://github.com/phonegap/phonegap-plugins/issues)
(preferred)

## LICENSE ##

The MIT License

Copyright (c) 2011 IBM

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
