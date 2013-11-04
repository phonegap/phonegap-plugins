# Cordova 2.1.0+ iOS Wifi Details Plugin 


Author: [Chris Williams](http://www.twitter.com/voodootikigod) (@voodootikigod)

In the config.xml file, you need to add the plugin with the key/pair value of:

<pre>
 &lt;plugin name="Wifi" value="Wifi" />
</pre>

Also be sure to copy the Wifi.h and Wifi.m to your {PROJECT_ROOT}/{PROJECT_NAME}/Plugins directory and copy wifi.js to your {PROJECT_ROOT}/www directory.

Include the JS file in your HTML as such:

<pre>
	&lt;script type="text/javascript" src="wifi.js"></script>
</pre>


To Get the Wireless SSID on demand, use the following:

<pre>
window.wifi.getSSID(function(details) {
    console.log(details);
});
</pre>




--


License

The MIT License

Copyright (c) 2013 [Chris Williams](http://www.twitter.com/voodootikigod) (@voodootikigod)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.