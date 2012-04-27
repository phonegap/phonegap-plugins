//
//  MessageBox.js
//
// Created by Olivier Louvignes on 11/26/2011.
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

function MessageBox() {}

MessageBox.prototype.alert = function(title, message, callback, options) {
	if(!options) options = {};
	var config = {
		scope: options.scope || null,
		okButtonTitle: options.okButtonTitle || 'OK'
	};

	var _callback = function(buttonIndex) {
		var button = 'ok';
		if(typeof callback == 'function') callback.call(config.scope, button);
	};

	return navigator.notification.alert(message, _callback, title, config.okButtonTitle + '');
};

MessageBox.prototype.confirm = function(title, message, callback, options) {
	if(!options) options = {};
	var config = {
		scope: options.scope || null,
		yesButtonTitle: options.yesButtonTitle || 'Yes',
		noButtonTitle: options.noButtonTitle || 'No'
	};

	var _callback = function(buttonIndex) {
		var button = (buttonIndex === 2) ? 'yes' : 'no';
		if(typeof callback == 'function') callback.call(config.scope, button);
	};

	return navigator.notification.confirm(message, _callback, title, config.noButtonTitle + ', ' + config.yesButtonTitle);
};

MessageBox.prototype.prompt = function(title, message, callback, options) {
	if(!options) options = {};
	var scope = options.scope || null;
	delete options.scope;

	var config = {
		okButtonTitle: options.okButtonTitle || 'OK',
		cancelButtonTitle: options.cancelButtonTitle || 'Cancel',
		title : title || 'Prompt',
		message : message || '',
		type : options.type || 'text',
		placeholder : options.placeholder || ''
	};

	var _callback = function(result) {
		var value = (result.buttonIndex == 1) ? result.value : false;
		button = (result.buttonIndex == 1) ? 'ok' : 'cancel';
		if(typeof callback == 'function') callback.call(scope, button, value);
	};

	return cordova.exec(_callback, _callback, 'MessageBox', 'prompt', [config]);
};

cordova.addConstructor(function() {
	if(!window.plugins) window.plugins = {};
	window.plugins.messageBox = new MessageBox();
});
