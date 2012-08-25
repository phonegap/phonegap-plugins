# Cordova Globalization Plugin #
by IBM

## Adding the Plugin to your project ##

Using this plugin requires [Cordova BlackBerry-WebWorks](http://www.github.com/apache/incubator-cordova-blackberry-webworks).

1. To install the plugin, copy globalization.js to your project and include a reference to it in your html file after cordova.js.

    &lt;script type="text/javascript" charset="utf-8" src="cordova.js"&gt;&lt;/script&gt;<br/>
    &lt;script type="text/javascript" charset="utf-8" src="globalization.js"&gt;&lt;/script&gt;

2. Copy the resourceBundles folder and all of its contents to your projects resources folder.  The resourceBundles folder contains additional localization information that is not available from the BlackBerry operating system. If you do not need to support all the locales you may selectively remove them so they are not included in your application.

3. Add the plugin source to your cordova.jar in your projects ext folder.  The cordova.jar file is a jar of source code.  Open cordova.jar with your favorite archive manager or use the jar command to create a directory called "org/apache/cordova/plugins/globalization" and copy Globalization.java, GlobalizationError.java, Resources.java and Util.java into it.

4. In your projects plugins.xml file add the following line:

    &lt;plugin name="Globalization" value="org.apache.cordova.plugins.globalization.Globalization"/&gt;


## RELEASE NOTES ##

### 20110915 ###
* Initial release
* See the .js file for API docs
* A globalization.tests.js file is provide to run with qunit as part of Mobile-Spec [Github](http://www.github.com/apache/incubator-cordova-mobile-spec)

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
