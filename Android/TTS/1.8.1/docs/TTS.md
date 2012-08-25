TTS
==========

The TTS class that allows you to access the devices TTS services.

Properties
----------

N/A

Methods
-------

- __startup__: starts the TTS service.
- __shutdown__: stops the TTS service. 
- __speak__: speaks the specified text. 
- __silence__: plays silence for the specified number of ms. 
- __getLanguage__: gets the current TTS language.
- __setLanguage__: sets the current TTS language.
- __isLanguageAvailable__: finds out if TTS supports the language.


Details
-------

The TTS class is a way to have your application read out text in a machine generated format.



Supported Platforms
-------------------

- Android

Quick Example
------------------------------
	
    window.plugins.tts.startup(startupWin, startupFail);
    
    function startupWin(result) {
		// When result is equal to STARTED we are ready to play
		if (result == TTS.STARTED) {
			window.plugins.tts.speak("The text to speech service is ready");
		}
    }
    
    function startupFail(result) {
        console.log("Startup failure = " + result);
    }
    
Full Example
------------

	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
	                      "http://www.w3.org/TR/html4/strict.dtd">
	<html>
	  <head>
	    <title>PhoneGap Events Example</title>
	
	    <script type="text/javascript" charset="utf-8" src="phonegap.0.9.5.js"></script>
	    <script type="text/javascript" charset="utf-8" src="tts.js"></script>
	    <script type="text/javascript" charset="utf-8">
	
	    // Call onDeviceReady when PhoneGap is loaded.
	    //
	    // At this point, the document has loaded but phonegap.js has not.
	    // When PhoneGap is loaded and talking with the native device,
	    // it will call the event `deviceready`.
	    // 
	    function onLoad() {
	        document.addEventListener("deviceready", onDeviceReady, false);
	    }
	
	    // PhoneGap is loaded and it is now safe to make calls PhoneGap methods
	    //
	    function onDeviceReady() {
	        window.plugins.tts.startup(startupWin, fail);
	    }
	    
	    function startupWin(result) {
			// When result is equal to STARTED we are ready to play
			if (result == TTS.STARTED) {
				window.plugins.tts.getLanguage(win, fail);
				window.plugins.tts.speak("The text to speech service is ready");
	            window.plugins.tts.isLanguageAvailable("en", function() {
					addLang("en");
				}, fail);
	            window.plugins.tts.isLanguageAvailable("fr", function() {
	                addLang("fr");
	            }, fail);
			}
	    }
		
		function addLang(lang) {
			var langs = document.getElementById('langs');
			var anOption = document.createElement("OPTION") 
			anOption.innerText = lang; 
			anOption.Value = lang;
	        langs.options.add(anOption); 
		}
		
		function changeLang() {
			var yourSelect = document.getElementById('langs');
	        window.plugins.tts.setLanguage(yourSelect.options[yourSelect.selectedIndex].value, win, fail);
		}
		
		function win(result) {
			console.log(result);
		}
	    
	    function fail(result) {
	        console.log("Error = " + result);
	    }
	    
	    function speak() {
	        window.plugins.tts.speak(document.getElementById('playMe').value);
	    }
	    </script>
	  </head>
	  <body onload="onLoad()">
	    <h2>TTS Example</h2>
		<input id="playMe" type="text"/><br/>
		<select id="langs" onchange="changeLang()"></select>
	    <a href="javascript:speak()">Speak</a><br/>
		test
	  </body>
	</html>