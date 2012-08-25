# Diagnostic plugin for PhoneGap #

The diagnostic plugin allows you to check different device settings in your PhoneGap application.

A simple use case would be:

- Your app require geolocation and you want check if the location services are enabled in device settings.
- Your app require the Wi-Fi enabled for the wireless network location and you want check if the Wi-Fi is enabled in device settings.
- Your app require the camera enabled and you want check if the camera is enabled in device settings.

## Adding the Plugin to your project ##

Using this plugin requires a PhoneGap project for iOS: [Get Started Guide](http://phonegap.com/start#ios-x4).

1. To install the plugin, move _diagnostic.js_ to your project's _www_ folder and include a reference to it in your _html_ file after _cordova.js_:

	<pre>
	 &lt;script type="text/javascript" charset="utf-8" src="cordova-X.X.X.js"&gt;&lt;/script&gt;
	 &lt;script type="text/javascript" charset="utf-8" src="diagnostic.js"&gt;&lt;/script&gt;
	</pre> 

2. Move _Diagnostic.h_ and _Diagnostic.m_ files into _Plugins_ folder.
3. And edit _Cordova.plist_ creating a new entry in the _Plugins_ section as follows:

	<pre>
	    - Key:    Diagnostic
	    - Type:   String
	    - Value:  Diagnostic
	</pre>

## Using the plugin ##

The plugin creates the object:
<pre>
 window.plugins.diagnostic
</pre>
To use, call one of the following, available methods:


- isLocationEnabled:

<pre>
/**
 * Checks if location is enabled (Device setting for location and authorization).
 *
 * @param successCallback	The callback which will be called when diagnostic of location is successful.
 * 							This callback function have a boolean param with the diagnostic result.
 * @param errorCallback		The callback which will be called when diagnostic of location encounters an error.
 * 							This callback function have a string param with the error.
 */
isLocationEnabled()
</pre>

Usage:
 
<pre>
   window.plugins.diagnostic.isLocationEnabled(locationEnabledSuccessCallback, locationEnabledErrorCallback);

   function locationEnabledSuccessCallback(result) {
      if (result)
         alert("Location ON");
      else
         alert("Location OFF");
   }

   function locationEnabledErrorCallback(error) {
      console.log(error);
   }
</pre>

- isLocationEnabledSetting:

<pre>
/**
 * Checks device settings for location.
 *
 * @param successCallback	The callback which will be called when diagnostic of location is successful.
 * 							This callback function have a boolean param with the diagnostic result.
 * @param errorCallback		The callback which will be called when diagnostic of location encounters an error.
 * 							This callback function have a string param with the error.
 */
isLocationEnabledSetting()
</pre>

Usage:
 
<pre>
   window.plugins.diagnostic.isLocationEnabledSetting(locationEnabledSettingSuccessCallback, locationEnabledSettingErrorCallback);

   function locationEnabledSettingSuccessCallback(result) {
      if (result)
         alert("Location ON");
      else
         alert("Location OFF");
   }

   function locationEnabledSettingErrorCallback(error) {
      console.log(error);
   }
</pre>

- isLocationAuthorized:

<pre>
/**
 * Checks if the application is authorized to use location.
 *
 * @param successCallback	The callback which will be called when diagnostic of location is successful.
 * 							This callback function have a boolean param with the diagnostic result.
 * @param errorCallback		The callback which will be called when diagnostic of location encounters an error.
 * 							This callback function have a string param with the error.
 */
isLocationAuthorized()
</pre>

Usage:
 
<pre>
   window.plugins.diagnostic.isLocationAuthorized(locationAuthorizedSuccessCallback, locationAuthorizedErrorCallback);

   function locationAuthorizedSuccessCallback(result) {
      if (result)
         alert("Authorized to use location");
      else
         alert("Not authorized to use location");
   }

   function locationAuthorizedErrorCallback(error) {
      console.log(error);
   }
</pre>

- isWifiEnabled:

<pre>
/**
 * Checks if exists Wi-Fi connection.
 *
 * @param successCallback	The callback which will be called when diagnostic of Wi-Fi is successful.
 * 							This callback function have a boolean param with the diagnostic result.
 * @param errorCallback		The callback which will be called when diagnostic of Wi-Fi encounters an error.
 * 							This callback function have a string param with the error.
 */
isWifiEnabled()
</pre>

Usage:
   
<pre>
   window.plugins.diagnostic.isWifiEnabled(wifiEnabledSuccessCallback, wifiEnabledErrorCallback);

   function wifiEnabledSuccessCallback(result) {
	   if (result)
	      alert("Wi-Fi ON");
	   else
	      alert("Wi-Fi OFF");
   }

   function wifiEnabledErrorCallback(error) {
	   console.log(error);
  }
</pre>

- isCameraEnabled:

<pre>
/**
 * Checks if exists camera.
 *
 * @param successCallback	The callback which will be called when diagnostic of camera is successful.
 * 							This callback function have a boolean param with the diagnostic result.
 * @param errorCallback		The callback which will be called when diagnostic of camera encounters an error.
 * 							This callback function have a string param with the error.
 */
isCameraEnabled()
</pre>

Usage:
 
<pre>
   window.plugins.diagnostic.isCameraEnabled(cameraEnabledSuccessCallback, cameraEnabledErrorCallback);

   function cameraEnabledSuccessCallback(result) {
	  if (result)
	     alert("Camera ON");
	  else
	     alert("Camera OFF");
   }

   function cameraEnabledErrorCallback(error) {
	  console.log(error);
   }
</pre>


## LICENSE ##

Copyright (c) 2012 AVANTIC ESTUDIO DE INGENIEROS

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.