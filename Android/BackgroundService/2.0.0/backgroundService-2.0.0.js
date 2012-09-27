/*
 * Copyright 2012 Red Folder Consultancy Ltd
 *   
 * Licensed under the Apache License, Version 2.0 (the "License");   
 * you may not use this file except in compliance with the License.   
 * You may obtain a copy of the License at       
 * 
 * 	http://www.apache.org/licenses/LICENSE-2.0   
 *
 * Unless required by applicable law or agreed to in writing, software   
 * distributed under the License is distributed on an "AS IS" BASIS,   
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   
 * See the License for the specific language governing permissions and   
 * limitations under the License.
 */

/*
 * Constructor
 */
function CreateBackgroundService(serviceName, require, exports, module) {
	var exec = require("cordova/exec");
	
	var BackgroundService = function (serviceName) {
		var ServiceName = serviceName
		this.getServiceName = function() {
			return ServiceName;
		};
	};

	var BackgroundServiceError = function (code, message) {
		this.code = code || null;
		this.message = message || null;
	};	

	/**
	  * All methods attempt to return the following data in both the success and failure callbacks
	  * Front end development should take into account any all or all of these values may be null
	  *
	  * Following returned in the JSONObject:
	  *		Boolean Success - was the call a success
	  *		int ErrorCode - Error code if an error occurred, else will be zero
	  *		String ErrorMessage - Text representation of the error code
	  *		Boolean ServiceRunning - True if the Service is running
	  *		Boolean TimerEnabled - True if the Timer is enabled
	  *		Boolean RegisteredForBootStart - True if the Service is registered for boot start
	  *		JSONObject Configuration - A JSONObject of the configuration of the service (contents dependant on the service)
	  *		JSONObject LastestResult - A JSONObject of the last result of the service (contents dependant on the service)
	  */

	/**
	  * Starts the Service
	  * 
	  * @param successCallback The callback which will be called if the method is successful
	  * @param failureCallback The callback which will be called if the method encounters an error
	  */
	BackgroundService.prototype.startService = function(successCallback, failureCallback) { 
		return exec(	successCallback,      
						failureCallback,      
						'BackgroundServicePlugin',      
						'startService',      
						[this.getServiceName()]);
	};

	/**
	  * Stops the Service
	  *
	  * @param successCallback The callback which will be called if the method is successful
	  * @param failureCallback The callback which will be called if the method encounters an error
	  */
	BackgroundService.prototype.stopService = function(successCallback, failureCallback) { 
		return exec(	successCallback,      
						failureCallback,      
						'BackgroundServicePlugin',      
						'stopService',      
						[this.getServiceName()]);
	};

	/**
	  * Enables the Service Timer
	  *
	  * @param milliseconds The milliseconds used for the timer
	  * @param successCallback The callback which will be called if the method is successful
	  * @param failureCallback The callback which will be called if the method encounters an error
	  */
	BackgroundService.prototype.enableTimer = function(milliseconds, successCallback, failureCallback) { 
		return exec(	successCallback,      
						failureCallback,      
						'BackgroundServicePlugin',      
						'enableTimer',      
						[this.getServiceName(), milliseconds]);
	};

	/**
	  * Disabled the Service Timer
	  *
	  * @param successCallback The callback which will be called if the method is successful
	  * @param failureCallback The callback which will be called if the method encounters an error
	  */
	BackgroundService.prototype.disableTimer = function(successCallback, failureCallback) { 
		return exec(	successCallback,      
						failureCallback,      
						'BackgroundServicePlugin',      
						'disableTimer',      
						[this.getServiceName()]);
	};

	/**
	  * Sets the configuration for the service
	  *
	  * @oaran configuration JSONObject to be sent to the service
	  * @param successCallback The callback which will be called if the method is successful
	  * @param failureCallback The callback which will be called if the method encounters an error
	  */
	BackgroundService.prototype.setConfiguration = function(configuration, successCallback, failureCallback) { 
		return exec(	successCallback,      
						failureCallback,      
						'BackgroundServicePlugin',      
						'setConfiguration',      
						[this.getServiceName(), configuration]);
	};

	/**
	  * Registers the service for Boot Start
	  *
	  * @param successCallback The callback which will be called if the method is successful
	  * @param failureCallback The callback which will be called if the method encounters an error
	  */
	BackgroundService.prototype.registerForBootStart = function(successCallback, failureCallback) { 
		return exec(	successCallback,      
						failureCallback,      
						'BackgroundServicePlugin',      
						'registerForBootStart',      
						[this.getServiceName()]);
	};

	/**
	  * Deregisters the service for Boot Start
	  *
	  * @param successCallback The callback which will be called if the method is successful
	  * @param failureCallback The callback which will be called if the method encounters an error
	  */
	BackgroundService.prototype.deregisterForBootStart = function(successCallback, failureCallback) { 
		return exec(	successCallback,      
						failureCallback,      
						'BackgroundServicePlugin',      
						'deregisterForBootStart',      
						[this.getServiceName()]);
	};

	/**
	  * Get the current status of the service.	
	  * 
	  * @param successCallback The callback which will be called if the method is successful
	  * @param failureCallback The callback which will be called if the method encounters an error
	  */
	BackgroundService.prototype.isRegisteredForBootStart = function(successCallback, failureCallback) { 
		return exec(	successCallback,      
						failureCallback,      
						'BackgroundServicePlugin',      
						'isRegisteredForBootStart',      
						[this.getServiceName()]);
	};


	/**
	  * Returns the status of the service
	  *
	  * @param successCallback The callback which will be called if the method is successful
	  * @param failureCallback The callback which will be called if the method encounters an error
	  */
	BackgroundService.prototype.getStatus = function(successCallback, failureCallback) { 
		return exec(	successCallback,      
						failureCallback,      
						'BackgroundServicePlugin',      
						'getStatus',      
						[this.getServiceName()]);
	};

	var backgroundService = new BackgroundService(serviceName);
	module.exports = backgroundService;
}; 
