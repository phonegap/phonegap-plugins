# Diagnostic plugin for PhoneGap #

The diagnostic plugin allows you to check different device settings in your PhoneGap application.

A simple use case would be:

- Your app require geolocation and you want check if the location services are enabled in device settings.
- Your app require the Wi-Fi enabled for the wireless network location and you want check if the Wi-Fi is enabled in device settings.
- Your app require the bluetooth enabled and you want check if the bluetooth is enabled in device settings.
- You want that the user enable the location services, Wi-Fi or bluetooth in device settings.

## Adding the Plugin to your project ##

Using this plugin requires a PhoneGap project for Android: [Get Started Guide](http://phonegap.com/start#android).

1. To install the plugin, move _diagnostic.js_ to your project's _www_ folder and include a reference to it in your _html_ file after _cordova.js_:

	<pre>
	 &lt;script type="text/javascript" charset="utf-8" src="cordova-X.X.X.js"&gt;&lt;/script&gt;
	 &lt;script type="text/javascript" charset="utf-8" src="diagnostic.js"&gt;&lt;/script&gt;
	</pre>

2. Create a directory within your project called _src/net/avantic/diagnosticPlugin_ and move _Diagnostic.java_ into it.
3. In your _res/xml/plugins.xml_ file add the following line:

	<pre>
	 &lt;plugin name="Diagnostic" value="net.avantic.diagnosticPlugin.Diagnostic" /&gt;
	</pre>

4. And in the _AndroidManifest.xml_ add:
	<pre>
	 &lt;uses-permission android:name="android.permission.ACCESS_WIFI_STATE" /&gt;
	 &lt;uses-permission android:name="android.permission.BLUETOOTH" /&gt;
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
 * Checks device settings for location.
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

- switchToLocationSettings:

<pre>
/**
 * Requests that the user enable the location services in device settings.
 */
switchToLocationSettings()
</pre>

Usage:

<pre>
   alert("You must enable the location services in device settings.");
   window.plugins.diagnostic.switchToLocationSettings();
</pre>

- isGpsEnabled:

<pre>
/**
 * Checks device settings for GPS.
 *
 * @param successCallback	The callback which will be called when diagnostic of GPS is successful.
 * 							This callback function have a boolean param with the diagnostic result.
 * @param errorCallback		The callback which will be called when diagnostic of GPS encounters an error.
 * 							This callback function have a string param with the error.
 */
isGpsEnabled()
</pre>

Usage:

<pre>
   window.plugins.diagnostic.isGpsEnabled(gpsEnabledSuccessCallback, gpsEnabledErrorCallback);

   function gpsEnabledSuccessCallback(result) {
      if (result)
         alert("GPS ON");
      else
         alert("GPS OFF");
   }

   function gpsEnabledErrorCallback(error) {
      console.log(error);
   }
</pre>

- isWirelessNetworkLocationEnabled:

<pre>
/**
 * Checks device settings for wireless network location (Wi-Fi and/or mobile networks).
 *
 * @param successCallback	The callback which will be called when diagnostic of wireless network location is successful.
 * 							This callback function have a boolean param with the diagnostic result.
 * @param errorCallback		The callback which will be called when diagnostic of wireless network location encounters an error.
 * 							This callback function have a string param with the error.
 */
isWirelessNetworkLocationEnabled()
</pre>

Usage:

<pre>
   window.plugins.diagnostic.isWirelessNetworkLocationEnabled(wirelessNetworkLocationEnabledSuccessCallback, wirelessNetworkLocationEnabledErrorCallback);

   function wirelessNetworkLocationEnabledSuccessCallback(result) {
	  if (result)
	     alert("Wireless network location ON");
	  else
	     alert("Wireless network location OFF");
   }

   function wirelessNetworkLocationEnabledErrorCallback(error) {
	   console.log(error);
   }
</pre>

- isWifiEnabled:

<pre>
/**
 * Checks device settings for Wi-Fi.
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

- switchToWifiSettings:

<pre>
/**
 * Requests that the user enable the Wi-Fi in device settings.
 */
switchToWifiSettings()
</pre>

Usage:

<pre>
   alert("You must enable the Wi-Fi in device settings.");
   window.plugins.diagnostic.switchToWifiSettings();
</pre>

- isBluetoothEnabled:

<pre>
 /**
 * Checks device settings for bluetooth.
 *
 * @param successCallback	The callback which will be called when diagnostic of bluetooth is successful.
 * 							This callback function have a boolean param with the diagnostic result.
 * @param errorCallback		The callback which will be called when diagnostic of bluetooth encounters an error.
 * 							This callback function have a string param with the error.
 */
isBluetoothEnabled()
</pre>

Usage:

<pre>
   window.plugins.diagnostic.isBluetoothEnabled(bluetoothEnabledSuccessCallback, bluetoothEnabledErrorCallback);

   function bluetoothEnabledSuccessCallback(result) {
	  if (result)
	     alert("Bluetooth ON");
	  else
	     alert("Bluetooth OFF");
   }

   function bluetoothEnabledErrorCallback(error) {
	  console.log(error);
   }
</pre>

- switchToBluetoothSettings:

<pre>
/**
 * Requests that the user enable the bluetooth in device settings.
 */
switchToBluetoothSettings()
</pre>

Usage:

<pre>
   alert("You must enable the Bluetooth in device settings.");
   window.plugins.diagnostic.switchToBluetoothSettings();
</pre>



## LICENSE ##

Copyright (c) 2012 AVANTIC ESTUDIO DE INGENIEROS

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.