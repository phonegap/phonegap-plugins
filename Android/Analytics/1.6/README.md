# Analytics plugin for Phonegap #

The analytics client allows you to send page views to Google Analytics server.

A simple use case would be:

- Initialize Analytics object with the appropriate Google Analytics account.
- Send page views upon user navigation.
- Send events upon user interaction.

## Adding the Plugin to your project ##

Using this plugin requires [Android PhoneGap](http://github.com/phonegap/phonegap-android).

1. To install the plugin, move www/analytics.js to your project's www folder and include a reference to it in your html file after phonegap.js.

    &lt;script type="text/javascript" charset="utf-8" src="phonegap.js"&gt;&lt;/script&gt;<br/>
    &lt;script type="text/javascript" charset="utf-8" src="analytics.js"&gt;&lt;/script&gt;

2. Create a directory within your project called "src/com/phonegap/plugins/analytics" and copy src/com/phonegap/plugins/analytics/GoogleAnalyticsTracker.java into it.

3. Add the following activity to your AndroidManifest.xml file.  It should be added inside the &lt;application&gt; tag.

    &lt;activity android:name="com.phonegap.DroidGap" android:label="@string/app_name"&gt;<br/>
      &lt;intent-filter&gt;<br/>
      &lt;/intent-filter&gt;<br/>
    &lt;/activity&gt;

4. Copy "lib/libGoogleAnalytics.jar" into the libs directory within your project.  You will also need to right click on this file in eclipse and add the jar to the build path.

5. In your res/xml/plugins.xml file add the following line:

<plugin name="GoogleAnalyticsTracker" value="com.phonegap.plugins.analytics.GoogleAnalyticsTracker" />

## Using the plugin ##

The plugin creates the object `window.plugins.analytics`.  To use, call one of the following, available methods:

<pre>
/**
 * Initialize Google Analytics configuration
 * 
 * @param accountId			The Google Analytics account id 
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
   
  start(accountId, successCallback, failureCallback);
</pre>

Sample use:

	window.plugins.analytics.start("Your-Account-ID-Here", function(){alert("Start: success");}, function(){alert("Start: failure");});
    
<pre>
/**
 * Track a page view on Google Analytics
 * @param key				The name of the tracked item (can be a url or some logical name).
 * 							The key name will be presented in Google Analytics report.  
 * @param successCallback	The success callback
 * @param failureCallback	The error callback 
 */
   
  trackPageView(key, successCallback, failureCallback);
</pre>

Sample use:

    window.plugins.analytics.trackPageView("page1.html", function(){alert("Track: success");}, function(){alert("Track: failure");});
	
<pre>
/**
 * Track an event on Google Analytics
 * @param category			The name that you supply as a way to group objects that you want to track
 * @param action			The name the type of event or interaction you want to track for a particular web object
 * @param label				Provides additional information for events that you want to track (optional)
 * @param value				Assign a numerical value to a tracked page object (optional)

 * @param successCallback	The success callback
 * @param failureCallback	The error callback 
 */

  trackEvent(category, action, label, value, successCallback, failureCallback);
</pre>

Sample use:

	window.plugins.analytics.trackPageView("category", "action", "event", 1, function(){alert("Track: success");}, function(){alert("Track: failure");});


Please keep in mind that these methods, as in any other plugin, are ready to be invoked only after '[deviceready](http://docs.phonegap.com/phonegap_events_events.md.html#deviceready)' event has been fired
    

## RELEASE NOTES ##

### AUG, 10, 2011 ###

* Added event tracking

### Jul 24, 2011 ###

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

Copyright (c) 2005-2010, Nitobi Software Inc.
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

Copyright (c) <2010> <Nitobi Software Inc., et. al., >

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
 
 ---
 
 ### libGoogleAnalytics.jar
 
 The libGoogleAnalytics.jar is distributed under Apache License, Version 2.0.
 License URL: http://www.apache.org/licenses/LICENSE-2.0
 libGoogleAnalytics.jar URL: http://code.google.com/p/android-scripting/source/browse/android/AndroidScriptingEnvironment/libs/libGoogleAnalytics.jar?r=41b40b84919bdf461784fd86e6ae464697d2abea