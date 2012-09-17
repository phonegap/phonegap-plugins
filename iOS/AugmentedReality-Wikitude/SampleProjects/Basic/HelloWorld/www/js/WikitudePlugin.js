var WikitudePlugin = {
    
    /**
     *
     *	This is the SDK Key, provided to you after you purchased the Wikitude SDK from http://www.wikitude.com/developer/sdk
     *	If you're having a trial version, leave this string empty
     *
     */
    mySDKKey : "ENTER-YOUR-KEY-HERE",

    /**
     *
     *  Change the value of this variable to modify the location update rate 
     *
     */
    locationUpdateRate : 3000,
    
    /**
     *
     *	This variable represents if the current device is capable of running the Wikitude SDK
     *	
     */	
    isDeviceSupported : false,

    /**
     *
     *	This watchID is used to shedule location updates
     *	
     */	    
    watchID : null,
    
    /**
     *
     *	Callbacks to get device information if ARchitect Worlds can be launched
     *
     */
    onDeviceSupportedCallback : null,
    onDeviceNotSupportedCallback : null,

    /**
     *
     *	Callbacks to get notified if the ARchitect World finished launching or if something went wrong during the World launch
     *
     */
    onARchitectWorldLaunchedCallback : null,
    onARchitectWorldFailedLaunchingCallback : null,
    
    /**
     *
     *	This function gets called if PhoneGap reports that it has finished loading successfully.
     *	
     */	
    isDeviceSupported: function(successCallback, errorCallback)
    {
        
        WikitudePlugin.onDeviceSupportedCallback = successCallback;
        WikitudePlugin.onDeviceNotSupportedCallback = errorCallback;
        
                            
		// PhoneGap is running, so the first thing we do is to check if the current device is capable of running the Wikitude Plugin
        cordova.exec(WikitudePlugin.deviceIsARchitectReady, WikitudePlugin.deviceIsNotARchitectReady, "WikitudePlugin", "isDeviceSupported", [""]);
        
    },

    /**
     *
     *	This function gets called if the Wikitude Plugin reports that the device is able to start the Wikitude SDK
     *	
     */	
    deviceIsARchitectReady : function()
    {
		// We keep track of the device status
        WikitudePlugin.isDeviceSupported = true;
        
        
        if(WikitudePlugin.onDeviceSupportedCallback)
        {
            WikitudePlugin.onDeviceSupportedCallback();
        }
    },

    /**
     *
     *	This function gets called if the Wikitude Plugin reports that the device is not able of starting the Wikitude SDK.
     *	
     */	
    deviceIsNotARchitectReady : function()
    {
        WikitudePlugin.isDeviceSupported = false;
        
        // In this case we notify the user that his device is not supported by the Wikitude SDK
        if(WikitudePlugin.onDeviceNotSupportedCallback)
        {
            WikitudePlugin.onDeviceNotSupportedCallback();
        }
    },


	/*
	 *	=============================================================================================================================
	 *
	 *	PUBLIC API
	 *
	 *	=============================================================================================================================
	 */

	/* Managing ARchitect world loading */

    /**
     *
     *	Call this function if you want to load an ARchitect World
	 *
	 * 	@param {String} worldPath The path to an ARchitect world ether on the device or on e.g. your dropbox
     *	
     */	
    loadARchitectWorld : function(worldPath)
    {
        
		// before we actually call load, we check again if the device is able to open the world
        if(WikitudePlugin.isDeviceSupported)
        {

			//	the 'open' function of the Wikitude Plugin requires a option dictionary with two keys:
			//	@param {Object} options (required)
			//	@param {String} options.sdkKey License key for the Wikitude SDK
			//	@param {String} options.filePath The path to a local ARchitect world or to a ARchitect world on a server or your dropbox

            cordova.exec(WikitudePlugin.worldLaunched, WikitudePlugin.worldFailedLaunching, "WikitudePlugin", "open", [{ sdkKey: WikitudePlugin.mySDKKey, filePath: worldPath}]);
            
            
            // We add an event listener on the resume and pause event of the application lifecycle
            document.addEventListener("resume", WikitudePlugin.onResume, false);
            document.addEventListener("pause", WikitudePlugin.onPause, false);
	
			// After we started loading the world, we start location updates 
	        WikitudePlugin.startLocationUpdates();

        }else
        {
			// if the device is not able to start the Wikitude SDK, we notify the user again
            WikitudePlugin.deviceNotARchitectReady();
        }
    },

    /* Managing the Wikitude SDK Lifecycle */
    
    /**
     *
     *	Use this function to stop the Wikitude SDK and to remove the ARchitectView from the screen
     *
     */
    close : function()
    {
        document.removeEventListener("pause", WikitudePlugin.onPause, false);
        document.removeEventListener("resume", WikitudePlugin.onResume, false);
        
        WikitudePlugin.stopLocationUpdates();
        
        cordova.exec(WikitudePlugin.onWikitudeOK, WikitudePlugin.onWikitudeError, "WikitudePlugin", "close", [""]);
    },
    
    /**
     *
     *	Use this function to only hide the Wikitude SDK. All location and rendering updates are still active
     *	
     */
	hide : function()
	{
		cordova.exec(WikitudePlugin.onWikitudeOK, WikitudePlugin.onWikitudeError, "WikitudePlugin", "hide", [""]);
	},

    /**
     *
     *	Use this function to show the Wikitude SDK if it was hidden before
     *	
     */
	show : function()
	{
		cordova.exec(WikitudePlugin.onWikitudeOK, WikitudePlugin.onWikitudeError, "WikitudePlugin", "show", [""]);
	},
    
    /* Interacting with the Wikitude SDK */

    /**
     *
     *	Use this function to call javascript which will be executed in the context of your ARchitect World
     * 
     *
     * @param js The JavaScript that gets evaluated in context of the ARchitect World
     *	
     */
	callJavaScript : function(js)
	{
		cordova.exec(WikitudePlugin.onWikitudeOK, WikitudePlugin.onWikitudeError, "WikitudePlugin", "callJavascript", [js]);
	},

    /**
     *
     *	Use this function to set a callback which will be invoked when the ARchitect World calls for example
	 *	document.location = "architectsdk://opendetailpage?id=9";
     *	
	 *
	 *	@param onUrlInvokeCallback A function which gets called when the ARchitect World invokes a call to "document.location = architectsdk://"
     */
	setOnUrlInvokeCallback : function(onUrlInvokeCallback)
	{
		cordova.exec(onUrlInvokeCallback, WikitudePlugin.onWikitudeError, "WikitudePlugin", "onUrlInvoke", [""]);
	},	


	/*
	 *	=============================================================================================================================
	 *
	 *	Callbacks of public functions
	 *
	 *	=============================================================================================================================
	 */

    /**
     *
     *	Use this callback to get notified if the world loaded successfully
     *	
     */	
    worldLaunched : function()
    {
        if(WikitudePlugin.onARchitectWorldLaunchedCallback)
        {
            WikitudePlugin.onARchitectWorldLaunchedCallback();
        }
    },

    /**
     *
     *	Use this callback to get notified if the Wikitude SDK wasn't able to load the ARchitect World
     *	
     */
    worldFailedLaunching : function(err)
    {
        if(WikitudePlugin.onARchitectWorldFailedLaunchingCallback)
        {
            WikitudePlugin.onARchitectWorldFailedLaunchingCallback(err);
        }
    },

	/* Lifecycle updates */

    /**
     *
     *	This function actually starts the PhoneGap location updates
     *	
     */
    startLocationUpdates : function()
    {
        
        WikitudePlugin.watchID = navigator.geolocation.watchPosition(WikitudePlugin.onReceivedLocation, WikitudePlugin.onWikitudeError, { frequency: WikitudePlugin.locationUpdateRate });
    },

    /**
     *
     *	This callback gets called everytime the location did update
     *	
     */
    onReceivedLocation : function(position)
    {
        
		// Every time that PhoneGap did received a location update, we pass the location into the Wikitude SDK
        cordova.exec(WikitudePlugin.onWikitudeOK, WikitudePlugin.onWikitudeError, "WikitudePlugin", "setLocation", [{ lat: position.coords.latitude, lon: position.coords.longitude, alt: position.coords.altitude, acc: position.coords.accuracy}]);
    },

    /**
     *
     *	Use this function to stop location updates
     *	
     */
    stopLocationUpdates : function()
    {
        
		// We clear the location update watch which was responsible for updating the location in a specific time interval
        navigator.geolocation.clearWatch(WikitudePlugin.watchID);
        WikitudePlugin.watchID = null;
    },

    /**
     *
     *	This function gets called every time the application did become active.
     *	
     */
    onResume : function()
    {
        
		// Call the Wikitude SDK that the application did become active again
        cordova.exec(WikitudePlugin.onWikitudeOK, WikitudePlugin.onWikitudeError, "WikitudePlugin", "onResume", [""]);

		// And start continuing updating the user location
        WikitudePlugin.startLocationUpdates();
    },

    /**
     *
     *	This function gets called every time the application is about to become inactive
     *	
     */
    onPause : function()
    {
        
		// Call the Wikitude SDK that the application did resign active
        cordova.exec(WikitudePlugin.onWikitudeOK, WikitudePlugin.onWikitudeError, "WikitudePlugin", "onPause", [""]);

		// And stop all ongoing location updates
        WikitudePlugin.stopLocationUpdates();
    },

    /**
     *
     *	Android specific!
	 *	This function gets called if the user presses the back button
     *	
     */
    onBackButton : function()
    {
        
        cordova.exec(WikitudePlugin.onWikitudeOK, WikitudePlugin.onWikitudeError, "WikitudePlugin", "close", [""]);
        WikitudePlugin.stopLocationUpdates();
    },

    /**
     *
     *	This function gets called every time the application is about to become inactive
     *	
     */
    onWikitudeOK : function()
    {
    },

    /**
     *
     *	This function gets called every time the application is about to become inactive
     *	
     */
    onWikitudeError : function()
    {
    },

    /**
     *
     *	This function gets called every time the application is about to become inactive
     *	
     */
    report: function(id)
    {
        console.log("app report: " + id);
    }
};
