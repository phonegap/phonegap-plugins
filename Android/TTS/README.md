# TTS plugin for Phonegap #

The TTS class that allows you to access the devices TTS services.

A simple use case would be:

- Playing text passed into the service out as synthesized speech

## Adding the Plugin to your project ##

Using this plugin requires [Android PhoneGap](http://github.com/phonegap/phonegap-android).

1. To install the plugin, move www/tts.js to your project's www folder and include a reference to it in your html file after phonegap.{ver}.js.

    &lt;script type="text/javascript" charset="utf-8" src="phonegap.{ver}.js"&gt;&lt;/script&gt;<br/>
    &lt;script type="text/javascript" charset="utf-8" src="tts.js"&gt;&lt;/script&gt;

2. Create a directory within your project called "src/com/phonegap/plugins/speech" and copy src/com/phonegap/plugins/speech/TTS.java into it.

3. Add the following activity to your AndroidManifest.xml file.  It should be added inside the &lt;application&gt; tag.

    &lt;activity android:name="com.phonegap.DroidGap" android:label="@string/app_name"&gt;<br/>
      &lt;intent-filter&gt;<br/>
      &lt;/intent-filter&gt;<br/>
    &lt;/activity&gt;
    
4. In your res/xml/plugins.xml file add the following line:

    &lt;plugin name="TTS" value="com.phonegap.plugins.speech.TTS"/&gt;


## Using the plugin ##

The plugin creates the object `window.plugins.tts`.  To use, call one of the following, available methods:

<pre>
/**
 * Play the passed in text as synthasized speech
 * 
 * @param {DOMString} text
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
</pre>
speak(text, successCallback, errorCallback);

Sample use:

    window.plugins.tts.speak("The TTS service is ready", win, fail);

<pre>
/** 
 * Play silence for the number of ms passed in as duration
 * 
 * @param {long} duration
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
</pre>
silence(duration, successCallback, errorCallback);

Sample use:

    window.plugins.tts.silence(2000, win, fail);

<pre>
/**
 * Starts up the TTS Service
 * 
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
</pre>
startup(successCallback, errorCallback);

Sample use:

    window.plugins.tts.startup(win, fail);

<pre>
/**
 * Shuts down the TTS Service if you no longer need it.
 * 
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
</pre>
shutdown(successCallback, errorCallback);

Sample use:

    window.plugins.tts.shutdown(win, fail);

<pre>
/**
 * Finds out if the language is currently supported by the TTS service.
 * 
 * @param {DOMSting} lang
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
</pre>
isLanguageAvailable(lang, successCallback, errorCallback);

Sample use:

    window.plugins.tts.isLanguageAvailable(lang, win, fail);

<pre>
/**
 * Finds out the current language of the TTS service.
 * 
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
</pre>
getLanguage(successCallback, errorCallback);

Sample use:

    window.plugins.tts.getLanguage(win, fail);

<pre>
/**
 * Sets the language of the TTS service.
 * 
 * @param {DOMString} lang
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
</pre>
setLanguage(lang, successCallback, errorCallback);

Sample use:

    window.plugins.tts.setLanguage(lang, win, fail);

## RELEASE NOTES ##

### May 7, 2011 ###

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
 