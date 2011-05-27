PhoneGap Plugin - SplashScreen
===

A PhoneGap iOS Plugin for showing and hiding the SplashScreen manually inside JavaScript.
This is useful, if your initial page rendering takes a long time.


Example
---

 	<script src="phonegap.js"></script>
    <script src="SplashScreen.js"></script>
    <script type="text/javascript">
    
        document.addEventListener("deviceready", function(){
            window.plugins.splashScreen.show();
            
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


Known Bugs
---

There´s a flickering caused by an delay, where PhoneGaps original loading screen gets hidden and this SplashScreen gets shown.


License
---

See [license](http://github.com/SunboX/PhoneGap-Plugin-SplashScreen/blob/master/license) file.