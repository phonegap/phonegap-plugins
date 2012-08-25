/**
 * 	PhoneListener.js
 * 	PhoneListener PhoneGap plugin (Android)
 *
 * 	Created by Tommy-Carlos Williams on 09/08/2011.
 * 	Copyright 2011 Tommy-Carlos Williams. All rights reserved.
 * 	MIT Licensed
 *
 *
 * Update by Matt McGrath to work with Cordova version of PhoneGap 1.6 upwards - 01/06/2012
 *
 */
var PhoneListener = { 
	start: function(successCallback, failureCallback) {
		return cordova.exec(    
			successCallback,
			failureCallback,
			'PhoneListener',
			'startMonitoringPhoneState',
			[]); // no arguments required
	},
	stop: function(successCallback, failureCallback) {
		return cordova.exec(    
			successCallback,
			failureCallback,
			'PhoneListener',
			'stopMonitoringPhoneState',
			[]); // no arguments required
	}
};
