# FtpClient plugin for Phonegap #

The ftp client allows you to upload and download files from within your PhoneGap application.

A simple use case would be:

- Downloading a text file from a FTP server in order to be displayed in your application.
- Uploading a text file to a FTP server.

## Adding the Plugin to your project ##

Using this plugin requires [Android PhoneGap](http://github.com/phonegap/phonegap-android).

1. To install the plugin, move www/ftpclient.js to your project's www folder and include a reference to it in your html file after phonegap.js.

    &lt;script type="text/javascript" charset="utf-8" src="phonegap.js"&gt;&lt;/script&gt;<br/>
    &lt;script type="text/javascript" charset="utf-8" src="ftpclient.js"&gt;&lt;/script&gt;

2. Create a directory within your project called "src/com/phonegap/plugins/ftpclient" and copy src/com/phonegap/plugins/ftpclient/FtpClient.java into it.

3. Add the following activity to your AndroidManifest.xml file.  It should be added inside the &lt;application&gt; tag.

    &lt;activity android:name="com.phonegap.DroidGap" android:label="@string/app_name"&gt;<br/>
      &lt;intent-filter&gt;<br/>
      &lt;/intent-filter&gt;<br/>
    &lt;/activity&gt;

4. Copy "libs/commons-net-2.2.jar" into the libs directory within your project.  You will also need to right click on this file in eclipse and add the jar to the build path.

## Using the plugin ##

The plugin creates the object `window.plugins.ftpclient`.  To use, call one of the following, available methods:

<pre>
  /**
   * Upload a file with the specified URL.
   * 
   * @param file   The file to upload
   * @param url	   The url of the ftp server
   * @param win	   The success callback
   * @param fail   The error callback
   */
   
  put(file, url, win, fail);
</pre>

Sample use:

    window.plugins.ftpclient.put("test.txt", "ftp://username:password@ftp.server.com/test.txt;type=i", win, fail);
    
<pre>
  /**
   * Download a file with the specified URL.
   * 
   * @param file   The name of the local file to be saved
   * @param url	   The url of the ftp server
   * @param win	   The success callback
   * @param fail   The error callback
   */
   
  get(file, url, win, fail);
</pre>

Sample use:

    window.plugins.ftpclient.get("test.txt", "ftp://username:password@ftp.server.com/test.txt;type=i", win, fail);

## RELEASE NOTES ##

### Jan 12, 2011 ###

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
 