## Wikitude PhoneGap Plugin Documentation
by ``` Wikitude GmbH ```


### DESCRIPTION 
***

This document describes all available PhoneGap bindings which exists in the Wikitude PhoneGap Plugin.


#### Getting information about the device

###### isDeviceSupported
Call ``` isDeviceSupported ``` to determinate if the current device is capable of launching ARchitect Worlds.
	
	@param onSuccessCallback - A callback which gets called if the current device supports launching ARchitect Worlds
	@param onErrorCallback - An callback which gets called if the current device does not fulfil all needs to lauch ARchitect Worlds
	@param Plugin name - The name of the plugin you want to call a function
	@param Plugin function - The name of the function you want to call on the plugin
	@param options - No options
	
		cordova.exec(deviceSupportedCallback, deviceNotSupportedCallback, "WikitudePlugin", "isDeviceSupported", [""]);


#### Managing the ARchitectView


###### open
Call open to add the ARchitectView to your applications view hierarchy and loads the specified ARchitect World.
	
	@param onSuccessCallback - A success callback
	@param onErrorCallback - An error callback
	@param Plugin name - The name of the plugin you want to call a function
	@param Plugin function - The name of the function you want to call on the plugin
	@param options - a dictionary containing two pairs:
					@pair apiKey : The Wikitude SDK Key provided to you after you purchased the Wikitude SDK or an empty string if you're using a trial version
					@pair filePath : A filepath to a local bundle resource or to a file on e.g. your dropbox
	
		cordova.exec(architectWorldLaunchedCallback, architectWorldFailedLaunchingCallback, "WikitudePlugin", "open", [{ apiKey: myApiKey, filePath: worldPath}]);

###### close	
This call will remove the ARchitectView from the view hierarchy and also stops all ongoing Wikitude updates.	

	@param onSuccessCallback - A success callback
	@param onErrorCallback - An error callback
	@param Plugin name - The name of the plugin you want to call a function
	@param Plugin function - The name of the function you want to call on the plugin
	@param options - No options
	
		cordova.exec(onWikitudeOK, onWikitudeError, "WikitudePlugin", "close", [""]);

###### show
This call hides the ARchitectView, but keeps it alive in memory.

	@param onSuccessCallback - A success callback
	@param onErrorCallback - An error callback
	@param Plugin name - The name of the plugin you want to call a function
	@param Plugin function - The name of the function you want to call on the plugin
	@param options - No options
	
		cordova.exec(onWikitudeOK, onWikitudeError, "WikitudePlugin", "hide", [""]);

###### hide	
This call will show the ARchitectView again if it was hidden with the ``` hide ``` call.
	
	@param onSuccessCallback - A success callback
	@param onErrorCallback - An error callback
	@param Plugin name - The name of the plugin you want to call a function
	@param Plugin function - The name of the function you want to call on the plugin
	@param options - No options
	
		cordova.exec(onWikitudeOK, onWikitudeError, "WikitudePlugin", "show", [""]);
	
	

#### Interacting with the ARchitectView

###### callJavaScript
This function will evaluate the passed JavaScript in the current ARchitect World context.
	
	@param onSuccessCallback - A success callback
	@param onErrorCallback - An error callback
	@param Plugin name - The name of the plugin you want to call a function
	@param Plugin function - The name of the function you want to call on the plugin
	@param options - A JavaScript array with a JavaScript string at first position
	
		cordova.exec(onWikitudeOK, onWikitudeError, "WikitudePlugin", "callJavascript", [js]);

###### onUrlInvoke	
This function will set an callback which gets called if you call ``` document.location = architectsdk://aRequestWithParameters?id=5&name=Poi5 ```.

	@param onSuccessCallback - A callback which gets called every time you call ` architectsdk:// `
	@param onErrorCallback - An error callback
	@param Plugin name - The name of the plugin you want to call a function
	@param Plugin function - The name of the function you want to call on the plugin
	@param options - No options

		cordova.exec(onUrlInvokeCallback, onWikitudeError, "WikitudePlugin", "onUrlInvoke", [""]);	
		
###### setLocation
This function allows you to set a location for your current ARchitectView


	@param onSuccessCallback - A success callback
	@param onErrorCallback - An error callback
	@param Plugin name - The name of the plugin you want to call a function
	@param Plugin function - The name of the function you want to call on the plugin
	@param options - A dictionary containing the new latitude, longitude, altitude, accuracy
		@pair lat : The new latitude
		@pair lon : The new longitude
		@pair alt : The new altitude
		@pair acc : The accuracy of the new locations

		cordova.exec(onUrlInvokeCallback, onWikitudeError, "WikitudePlugin", "setLocation", [""]);


