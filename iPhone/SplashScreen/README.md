PhoneGap Plugin - SplashScreen
===

A PhoneGap iOS Plugin for showing and hiding the SplashScreen manually inside JavaScript.
This is useful, if your initial page rendering takes a long time. It takes a image file as input, remember to add as a resource.


Example
---

 	<script src="phonegap.js"></script>
    <script src="SplashScreen.js"></script>
    <script type="text/javascript">
    
        document.addEventListener("deviceready", function(){
            window.plugins.splashScreen.show('Default.png');
            
            // do some stuff here ...
            // launch your application, render the layout, ...
            // after all, just hide the SplashScreen again:
            
            window.plugins.splashScreen.hide();
            
        }, false);
        
    </script>


Plugin Installation
---


This plugin consists of 3 files, SplashScreen.m, SplashScreen.h, and SplashScreen.js
The .m/.h files need to be added to your XCode project and this must be done through XCode so that XCode is aware that these files are to be compiled and linked to the application. You can do this by manually copying the files into your project's plugins folder and from within XCode select your plugins folder, right click and choose 'Add Existing Files...' and select the files you already put in the plugins folder.


You may also choose to save a step and simply select your XCode project plugins folder, right click and choose 'Add Existing Files...' and find the files within your plugin repo, then choose copy so XCode will duplicate the files for you.


The SplashScreen.js is generally moved into the www folder manually and NOT a part of the XCode project. You can do this on the file-system directly by copying the file over.  Be sure to include the SplashScreen.js with a script tag in your html file that will interact with it, and do this AFTER including phonegap.js 


## BUGS AND CONTRIBUTIONS ##
The latest release version is available [on GitHub](https://github.com/ttopholm/phonegap-plugins/)
If you have a patch, fork my repo and send me a pull request. Submit bug reports on GitHub, please.
	
## Licence ##

The MIT License

Copyright (c) 2011 Tue Topholm / Sugee / Dipl.-Ing. (FH) André Fiedler <fiedler.andre at gmail dot com>

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
