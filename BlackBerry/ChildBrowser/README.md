# ChildBrowser plugin for Phonegap #

The child browser allows you to display external web pages within your PhoneGap application in either a custom browser field or in the device's builtin browser.  Web pages accessed through the child browser plugin are not restricted by the whitelist entries in the applications config.xml.

The custom browser view provides advantages over the builtin browser.  The custom browser provides the ability to be notified of URL location changes and when the browser is closed.  Additionally, with the custom browser it is possible to have a chrome-less view or a view with a navigation bar at the top.

Whether the custom browser or builtin browser is used the user is always brought back to the original application when the user backs out or closes the browser.

## Adding the Plugin to your project ##

Using this plugin requires [BlackBerry PhoneGap](http://github.com/callback/callback-blackberry).

1. To install the plugin, move www/childbrowser.js to your project's www folder and include a reference to it in your html file after phonegap.js.

    &lt;script type="text/javascript" charset="utf-8" src="phonegap.js"&gt;&lt;/script&gt;<br/>
    &lt;script type="text/javascript" charset="utf-8" src="childbrowser.js"&gt;&lt;/script&gt;

2. Copy the image files folder www/childbrowser to your project's www folder. Note, you need the entire folder not just the images.

3. Add the plugin source to your phonegap.jar in your projects ext folder.  The phonegap.jar file is a jar of source code.  Open phonegap.jar with your favorite archive manager or use the jar command to create a directory called "com/phonegap/plugins/childbrowser" and copy the `.java` files into it.

4. In your projects plugins.xml file add the following line:

    &lt;plugin name="ChildBrowser" value="com.phonegap.plugins.childbrowser.ChildBrowser"/&gt;

## Using the plugin ##

The plugin creates the object `window.plugins.childBrowser`.  To use, call one of the following, available methods:

### Load a URL in a custom browser ###

    showWebPage(url, [options])
        Where:
            url:     The URL to load
            options: An object that specifies additional options.

The following values are recognized for the `options` parameter.

* showLocationBar - boolean value indicating whether to show a navigation bar or not. The location bar provides UI elements for back, forward, stop/refresh and URL entry.

Sample use:

    window.plugins.childBrowser.showWebPage("http://www.google.com", { showLocationBar: true });

### Close an open custom browser ###

    close()

Sample use:

    window.plugins.childBrowser.close();

### Receive notification that the custom browser closed ###

    onClose()

Sample use:

    function closed() {
        console.log("The browser window was closed");
    }
    window.plugins.childBrowser.onClose = closed;

### Receive notification when the browser location changes ###

    onLocationChange(location)

Sample use:

    function locationChanged(newurl) {
        console.log("Location was changed to: " + newurl);
    }
    window.plugins.childBrowser.onLocationChange = locationChanged;

### Receive notification when an error occurs in the custom browser ###

    onError(data)

Sample use:

    function error(msg) {
        console.log("An error occurred while browsing: " + msg);
    }
    window.plugins.childBrowser.onError = error;

### Load a URL in the device's builtin browser ###

    openExternal(url, [usePhoneGap])
        Where:
            url:         The URL to load
            usePhoneGap: Ignored. Maintained for API consistency with Android

Sample use:

    window.plugins.childBrowser.openExternal("http://www.google.com");

## Known Issues ##

* Severe rendering issue appearing in landscape mode on Torch 9800 running OS 6. Looks like only portrait resolution is being rendered and the rest is clipped. Issue does not appear in simulators.  Not sure at this time if it happens on other devices.
* On OS 5 non-touchscreen devices, the navigation bar does not acquire focus when the pointer is within the navigation bar region.  This is a known issue on OS 5 with BrowserField elements.  On OS 5, once the BrowserField acquires focus it does not release focus to other UI elements like it should.  To move focus to the navigation bar, the user must click the trackpad/roller in the navigation bar region.  The user will then be able to focus the individual UI elements.
* When editing the URL in the navigation bar the full URL is not always shown. For some reason it appears that the text box is wrapping text.

## RELEASE NOTES ##

### Nov 30, 2011 ###

* Initial release

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
