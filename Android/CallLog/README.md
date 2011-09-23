# CallLog plugin for Phonegap #

The call log plugin lets you grab data from your phones call log. 

## Adding the Plugin to your project ##

Using this plugin requires [Android PhoneGap](http://github.com/phonegap/phonegap-android).

1. To install the plugin, move calllog.js to your project's www folder and include a reference to it in your html file after phonegap.js.

    &lt;script type="text/javascript" charset="utf-8" src="phonegap.js"&gt;&lt;/script&gt;<br/>
    &lt;script type="text/javascript" charset="utf-8" src="calllog.js"&gt;&lt;/script&gt;

2. Create a directory within your project called "src/com/leafcut/ctrac" and move CallListPlugin.java into it.

## Using the plugin ##

The plugin creates the object `window.plugins.CallLog`.  To use, call one of the following, available methods:

<pre>
   window.plugins.CallLog.list(day|month|year|all, successCallBack, failCallBack);
   window.plugins.CallLog.show(phoneNumber, successCallBack, failCallBack);
</pre>

Sample use:

    window.plugins.CallLog.list('all', successCallBack, failCallBack);

## RELEASE NOTES ##

### Sep 6, 2011 ###

* Initial release

## BUGS AND CONTRIBUTIONS ##


### The MIT License

Copyright (c) <2011> James Hornitzky

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
 
