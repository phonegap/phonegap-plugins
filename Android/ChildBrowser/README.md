# ChildBrowser plugin for Phonegap #

The child browser allows you to display external web pages within your PhoneGap application.

A simple use case would be:

- Users can post links, and you don't want your users to exit your app to view the link.

This command creates a popup browser that is shown in front of your app, when the user presses the back button they are simply returned to your app.

## Adding the Plugin to your project ##

Using this plugin requires [Android PhoneGap](http://github.com/phonegap/phonegap-android).

1. To install the plugin, move www/childbrowser.js to your project's www folder and include a reference to it in your html file after phonegap.js.

    &lt;script type="text/javascript" charset="utf-8" src="phonegap.js"&gt;&lt;/script&gt;<br/>
    &lt;script type="text/javascript" charset="utf-8" src="childbrowser.js"&gt;&lt;/script&gt;
    
2. Copy the image files folder www/childbrowser to your project'w www folder. Note you need the entire folder not just the images.

3. Create a directory within your project called "src/com/phonegap/plugins/childBrowser" and move ChildBrowser.java into it.

4. Add the following activity to your AndroidManifest.xml file.  It should be added inside the &lt;application&gt; tag.

    &lt;activity android:name="com.phonegap.plugins.childBrowser.ChildBrowser" android:label="@string/app_name"&gt;<br/>
      &lt;intent-filter&gt;<br/>
      &lt;/intent-filter&gt;<br/>
    &lt;/activity&gt;

5. In your res/xml/plugins.xml file add the following line:

    &lt;plugin name="ChildBrowser" value="com.phonegap.plugins.childBrowser.ChildBrowser"/&gt;

## Using the plugin ##

The plugin creates the object `window.plugins.childBrowser`.  To use, call one of the following, available methods:

Note that unlike the iphone version, android childbrowser doesn't require a call to `ChildBrowser.install()`

<pre>
  /**
	* Display a new browser with the specified URL.
    * This method loads up a new web view in a dialog.
    *
    * @param url           The url to load
    * @param options       An object that specifies additional options
    */
  showWebPage(url, [options])
</pre>

Sample use:

    window.plugins.childBrowser.showWebPage("http://www.google.com", { showLocationBar: true });

<pre>
  /**
	* Close the browser.
    */
  close() {
</pre>

Sample use:

    window.plugins.childBrowser.close();

<pre>
  /**
	* A user supplied call back which is run when the browser is closed.
    */
  onClose() 
</pre>

Sample use:

    window.plugins.childBrowser.onClose();

<pre>
  /**
	* A user supplied call back which is run when the browser location changes.
	* The method is called with the new location of the browser.
    */
  onLocationChange(location) 
</pre>

Sample use:

    window.plugins.childBrowser.onLocationChange(location);

<pre>
  /**
   * Display a new browser with the specified URL.
   * 
   * NOTE: If usePhoneGap is set, only trusted PhoneGap URLs should be loaded,
   *       since any PhoneGap API can be called by the loaded HTML page.
   *
   * @param url           The url to load
   * @param usePhoneGap   Load url in PhoneGap webview [optional] - Default: false
   */
   
  openExternal(url, [usePhoneGap])
</pre>

Sample use:

    window.plugins.childBrowser.openExternal("http://www.google.com");

## RELEASE NOTES ##

### Oct 29, 2010 ###

* Initial release

### Nov 12, 2010 ###

* Changed how URL is passed when usePhoneGap=true.  Instead of using Data, it is now passed as Extra.  This will work with latest edge version with the same date.
* Added "Loading" dialog that is shown when usePhoneGap=true.

### Dec 2, 2010 ###

* Added warning comments about loading URLs when usePhoneGap=true.

### September 9, 2011 ###

* Modified ChildBrowser to more closely model the iOS ChildBrowser

## BUGS AND CONTRIBUTIONS ##


## LICENSE ##

PhoneGap is available under *either* the terms of the modified BSD license *or* the
MIT License (2008). As a recipient of PhonegGap, you may choose which
license to receive this code under (except as noted in per-module LICENSE
files). Some modules may not be the copyright of Nitobi.   These
modules contain explicit declarations of copyright in both the LICENSE files in
the directories in which they reside and in the code itself. No external
contributions are allowed under licenses which are fundamentally incompatible
with the MIT or BSD licenses that PhoneGap is distributed under.

The text of the MIT and BSD licenses is reproduced below. 

---

### The "New" BSD License

Copyright (c) 2005-2011, Nitobi Software Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
  * Neither the name of Phonegap/Nitobi nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

---

### The MIT License

Copyright (c) <2011> <Nitobi Software Inc., et. al., >

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
 
