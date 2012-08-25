	

    function onLoad() {
		document.addEventListener("deviceready", onDeviceReady, false);
	}

	function onDeviceReady() {
        
       
        
        // To know if the location is turned ON/OFF and if the app is allowed to use it.
		window.plugins.diagnostic.isLocationEnabled(locationEnabledSuccessCallback, locationEnabledErrorCallback);
   
        function locationEnabledSuccessCallback(result) {
            if (result)
            {
                //alert("Location ON");
                document.getElementById('location').innerHTML = 'ON';
                
                //alert("Location Setting ON");
                document.getElementById('locationSetting').innerHTML = 'ON';
                
                //alert("Auth Location ON");
                document.getElementById('locationAuthorization').innerHTML = 'ON';    
                
                function locationAuthorizedErrorCallback(error) {
                    console.log(error);
                }
            }
            else
            {
                //alert("Location OFF");
                document.getElementById('location').innerHTML = 'OFF';
                // To know if the location is turned ON/OFF.
                window.plugins.diagnostic.isLocationEnabledSetting(locationEnabledSettingSuccessCallback, locationEnabledSettingErrorCallback);
                
                function locationEnabledSettingSuccessCallback(result) {
                    if (result)
                    {
                        //alert("Location Setting ON");
                        document.getElementById('locationSetting').innerHTML = 'ON';
                    }
                    else
                    {
                        //alert("Location Setting OFF");
                        document.getElementById('locationSetting').innerHTML = 'OFF';
                    }
                }
                
                function locationEnabledSettingErrorCallback(error) {
                    console.log(error);
                }
                
                // To know if the app is allowed to use it.
                window.plugins.diagnostic.isLocationAuthorized(locationAuthorizedSuccessCallback, locationAuthorizedErrorCallback);
                
                function locationAuthorizedSuccessCallback(result) {
                    if (result)
                    {
                        //alert("Auth Location ON");
                        document.getElementById('locationAuthorization').innerHTML = 'ON';
                    }
                    else
                    {
                        //alert("Auth Location OFF");
                        document.getElementById('locationAuthorization').innerHTML = 'OFF';
                    }
                }
                
                function locationAuthorizedErrorCallback(error) {
                    console.log(error);
                }
            }
        }
        
        function locationEnabledErrorCallback(error) {
            console.log(error);
        }
        
        
        // To know if the WiFi is turned ON/OFF.
        window.plugins.diagnostic.isWifiEnabled(wifiEnabledSuccessCallback, wifiEnabledErrorCallback);
        
        function wifiEnabledSuccessCallback(result) {
            if (result)
            {
                //alert("WiFi ON");
                document.getElementById('wifi').innerHTML = 'ON';
            }
            else
            {
                //alert("WiFi OFF");
                document.getElementById('wifi').innerHTML = 'OFF';
            }
        }
        
        function wifiEnabledErrorCallback(error) {
            console.log(error);
        }
        
        // To know if the camera is enabled.
        window.plugins.diagnostic.isCameraEnabled(cameraEnabledSuccessCallback, cameraEnabledErrorCallback);
        
        function cameraEnabledSuccessCallback(result) {
            if (result)
            {
                //alert("Camera ON");
                document.getElementById('camera').innerHTML = 'ON';
            }
            else
            {
                //alert("Camera OFF");
                document.getElementById('camera').innerHTML = 'OFF';
            }
        }
        
        function cameraEnabledErrorCallback(error) {
            console.log(error);
        }
        
	   
	   
	}