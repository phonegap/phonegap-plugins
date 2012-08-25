//
//  ProgressHud.js
//
// Created by Olivier Louvignes on 04/25/2012.
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

(function(cordova) {

	function ProgressHud() {}

	ProgressHud.prototype.show = function(options, callback) {
		if(!options) options = {};
		var scope = options.scope || null;
		delete options.scope;

		var service = 'ProgressHud',
			action = 'show',
			callbackId = service + (cordova.callbackId + 1);

		var config = {
			mode: options.mode || 'indeterminate',
			labelText: options.labelText || 'Loading...',
			detailsLabelText: options.detailsLabelText || '',
			progress: options.progress || 0
		};

		var _callback = function(result) {
			if(typeof callback == 'function') callback.apply(scope, arguments);
		};

		return cordova.exec(_callback, _callback, service, action, [config]);

	};

	ProgressHud.prototype.set = function(options, callback) {
		if(!options) options = {};
		var scope = options.scope || null;
		delete options.scope;

		var service = 'ProgressHud',
			action = 'set',
			callbackId = service + (cordova.callbackId + 1);

		var _callback = function(result) {
			if(typeof callback == 'function') callback.apply(scope, arguments);
		};

		return cordova.exec(_callback, _callback, service, action, [options]);

	};

	ProgressHud.prototype.hide = function(options, callback) {
		if(!options) options = {};
		var scope = options.scope || null;
		delete options.scope;

		var service = 'ProgressHud',
			action = 'hide',
			callbackId = service + (cordova.callbackId + 1);

		var config = {};

		var _callback = function(result) {
			if(typeof callback == 'function') callback.apply(scope, arguments);
		};

		return cordova.exec(_callback, _callback, service, action, [config]);

	};

	cordova.addConstructor(function() {
		if(!window.plugins) window.plugins = {};
		window.plugins.progressHud = new ProgressHud();
	});

})(window.cordova || window.Cordova);
