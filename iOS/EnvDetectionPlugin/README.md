#### This project is hosted here https://github.com/sandeep45/phonegap-env-plugin

Build Environment Detection Plugins
=====================================

This plugin tells you if you are running a debug or release build. 
Common use case is to do load a different url or process things differently when running in release mode vs debug mode.

Step 1. Add preprocessors to your project
------------------------------------------

For this plugin to work, you first need to __add a preprocessor__ to your project.
In Xcode click on your project, select your target and under preprocessor macros add appenv=1 for debug and appenv=0 for release.

Screenhost - https://github.com/sandeep45/phonegap-env-plugin/blob/master/settings.png

Step 2. Add Plugin files
------------------------------------------

Copy Env.h and Env.m to you projects plugin directory

Step 3. Enable the plugin
----------------------------

In you config.xml add the following line:

`<plugin name="Env" value="Env" />`

Step 4. Include Plugin Javascript File
----------------------------------------

Add env.js file in your index.html like this:

`<script type="text/javascript" src="env.js"></script>`

Step 5. Detect the Environment
------------------------------------

Use the following code to detect environment
```javascript
	var env = window.plugins.env;
	env.env(this,function(ans){
	  if(ans === "Debug"){
	    alert(ans);
	  }
	},function(ans){
	    alert("ERROR");
	}); 
```


