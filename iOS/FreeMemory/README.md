# Cordova 2.1.0+ iOS Free Memory Report Plugin 

Author: Chris Williams (@voodootikigod)

In the config.xml file, you need to add the plugin with the key/pair value of:

<code>
<plugin name="FreeMemory" value="FreeMemory" />
</code>

Also be sure to copy the FreeMemory.h and FreeMemory.m to your {PROJECT_ROOT}/{PROJECT_NAME}/Plugins directory and copy freememory.js to your {PROJECT_ROOT}/www directory.

Include the JS file in your HTML as such:

<code>
	<script type="text/javascript" src="freememory.js"></script>
</code>


To Get the Current Available Memory on demand, use the following:

<code>
window.freeMemory(function(details) {
    sys.freeMemory = (details);
});
</code>

Bear in mind, this is the free memory within the device (total), not necessarily the available memory just to your application. It should assist, though, with identifying slow leaks and performance.



--


License

The MIT License

Copyright (c) 2013 Chris Williams (@voodootikigod)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.