//
//  SecureDeviceIdentifier.js
//
// Created by Olivier Louvignes on 05/31/2012.
//
// Copyright 2012 Olivier Louvignes. All rights reserved.
// MIT Licensed

(function(cordova) {

	function SecureDeviceIdentifier() {}

	SecureDeviceIdentifier.prototype.get = function(options, callback) {
		if(!options) options = {};
		var scope = options.scope || null;
		delete options.scope;

		var service = 'SecureDeviceIdentifier',
			action = 'get',
			callbackId = service + (cordova.callbackId + 1);

		var config = {
			domain: options.domain || 'com.example.myapp',
			key: options.key || 'difficult-to-guess-key'
		};

		var _callback = function(result) {
			if(typeof callback == 'function') callback.apply(scope, arguments);
		};

		return cordova.exec(_callback, _callback, service, action, [config]);

	};

	cordova.addConstructor(function() {
		if(!window.plugins) window.plugins = {};
		window.plugins.secureDeviceIdentifier = new SecureDeviceIdentifier();
	});

})(window.cordova || window.Cordova);
