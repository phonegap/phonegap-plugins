/**
 * 	PhoneListener.js
 * 	PhoneListener PhoneGap plugin (Android)
 *
 * 	Created by Tommy-Carlos Williams on 09/08/2011.
 * 	Copyright 2011 Tommy-Carlos Williams. All rights reserved.
 * 	MIT Licensed
 */
var PhoneListener = { 
	start: function(successCallback, failureCallback) {
		return PhoneGap.exec(    
			successCallback,
			failureCallback,
			'PhoneListener',
			'startMonitoringPhoneState',
			[]); // no arguments required
	},
	stop: function(successCallback, failureCallback) {
		return PhoneGap.exec(    
			successCallback,
			failureCallback,
			'PhoneListener',
			'stopMonitoringPhoneState',
			[]); // no arguments required
	}
};
