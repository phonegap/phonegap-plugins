//
//  MessageBox.js
//
// Created by Olivier Louvignes on 11/26/2011.
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

function MessageBox() {}

MessageBox.prototype.alert = function(title, msg, fn, scope) {
	fn = fn || function(){};
	return navigator.notification.alert(msg, function(button) { button = 'ok'; fn.call(scope || null, button); }, title, 'OK');
};

MessageBox.prototype.confirm = function(title, msg, fn, scope) {
	fn = fn || function(){};
	return navigator.notification.confirm(msg, function(button) { button = (button == 1) ? 'yes' : 'no'; fn.call(scope || null, button); }, title, 'Yes, No');
};

MessageBox.prototype.prompt = function(title, msg, fn, options) {
	if(!options) options = {};

	var config = {
		title : title+'' || 'Prompt',
		message : msg+'' || '',
		callback : fn || function(){},
		scope: options.hasOwnProperty('scope') ? options.scope : null,
		type : options.hasOwnProperty('type') ? options.type+'' : 'text',
		placeholder : options.hasOwnProperty('placeholder') ? options.placeholder+'' : '',
		okButtonTitle : options.hasOwnProperty('okButtonTitle') ? options.okButtonTitle+'' : 'OK',
		cancelButtonTitle : options.hasOwnProperty('cancelButtonTitle') ? options.cancelButtonTitle+'' : 'Cancel'
	};

	var callback = function(result) {
		console.warn(result);
		var value = (result.buttonIndex == 1) ? result.value : false;
		button = (result.buttonIndex == 1) ? 'ok' : 'cancel';
		config.callback.call(config.scope || null, button, value);
	};

	return PhoneGap.exec(callback, callback, 'MessageBox', 'prompt', [config]);
};

PhoneGap.addConstructor(function() {
	if(!window.plugins) window.plugins = {};
	window.plugins.messageBox = new MessageBox();
});
