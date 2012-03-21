# Android SpeechRecognizer plugin for Phonegap #

This plugin will recognize commands, phrases, etc as spoken by the user.
A collection of possible matches (strings) are returned to your app.

## Adding the Plugin to your project ##

Of course this plugin requires [Android PhoneGap](http://github.com/phonegap/phonegap-android).

1. To install the plugin, copy speechrecognizer.js to your project's www folder.
2. Add speechrecognizer.js to your html file, eg: `<script type="text/javascript" charset="utf-8" src="speechrecognizer.js"></script>`
3. Create an 'com/urbtek/phonegap' path under 'src' and add the SpeechRecognizer.java file to it
4. Add the plugin to the 'res/xml/plugins.xml' file. eg: `<plugin name="SpeechRecognizer" value="com.urbtek.phonegap.SpeechRecognizer"/>`

### Example
```html
<!DOCTYPE HTML>
<html>
  <head>
    <title>PhoneGap</title>
  <script type="text/javascript" charset="utf-8" src="phonegap.js"></script> 
  <script type="text/javascript" charset="utf-8" src="speechrecognizer.js"></script>      
  <script type="text/javascript" charset="utf-8">
     function onLoad(){
          document.addEventListener("deviceready", onDeviceReady, true);
     }
     function onDeviceReady()
	{
	    window.plugins.speechrecognizer.init(speechInitOk, speechInitFail);
	    // etc.
	}

	function speechInitOk() {
		alert("we are good");
		supportedLanguages();
		recognizeSpeech();
	}
	function speechInitFail(m) {
		alert(m);
	}

	// Show the list of the supported languages
	function supportedLanguages() {
		window.plugins.speechrecognizer.getSupportedLanguages(function(languages){
				// display the json array
				alert(languages);
			}, function(error){
				alert("Could not retrieve the supported languages");
		});
	}

	function recognizeSpeech() {
	    var requestCode = 1234;
	    var maxMatches = 5;
	    var promptString = "Please say a command";	// optional
		var language = "en-US";						// optional
	    window.plugins.speechrecognizer.startRecognize(speechOk, speechFail, requestCode, maxMatches, promptString, language);
	}
	
	function speechOk(result) {
	    var respObj, requestCode, matches;
	    if (result) {
	        respObj = JSON.parse(result);
	        if (respObj) {
	            var matches = respObj.speechMatches.speechMatch;
	            
	            for (x in matches) {
	                alert("possible match: " + matches[x]);
	                // regex comes in handy for dealing with these match strings
	            }
	        }        
	    }
	}
	
	function speechFail(message) {
	    console.log("speechFail: " + message);
	}
  </script>
  </head>
  <body onload="onLoad();">
       <h1>Welcome to PhoneGap</h1>
       <h2>Edit assets/www/index.html</h2>
  </body>
</html>
```

## RELEASE NOTES ##

### November 23, 2011 ###

* Java code to java convention (functions starts with a lowercase characater)
* New getSupportedLanguages method
* Java file warnings removed
* Better error handling 
* New language parameter
* SpeechOk demo code fixed (show the recognized text instead of the id)

### September 16, 2011 ###

* Initial release

## License

The MIT License

Copyright (c) 2011  
Colin Turner (github.com/koolspin)  
Guillaume Charhon (github/poiuytrez)  


Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
