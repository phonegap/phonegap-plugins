//
//  ActionSheet.js
//
// Created by Olivier Louvignes on 11/27/2011.
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

function ActionSheet() {}

ActionSheet.prototype.create = function(title, items, fn, options) {
	if(!options) options = {};

	var service = 'ActionSheet',
		action = 'create',
		callbackId = service + (PhoneGap.callbackId + 1);

	var config = {
		title : title+'' || '',
		items : items || ['Cancel'],
		callback : fn || function(){},
		scope: options.hasOwnProperty('scope') ? options.scope : null,
		style : options.hasOwnProperty('style') ? options.style+'' : 'default',
		destructiveButtonIndex : options.hasOwnProperty('destructiveButtonIndex') ? options.destructiveButtonIndex*1 : undefined,
		cancelButtonIndex : options.hasOwnProperty('cancelButtonIndex') ? options.cancelButtonIndex*1 : undefined
	};

	var callback = function(result) {
		var buttonValue = false, // value for cancelButton
			buttonIndex = result.buttonIndex;

		if(!config.cancelButtonIndex || buttonIndex != config.cancelButtonIndex) {
			buttonValue = config.items[buttonIndex];
		}

		config.callback.call(config.scope || null, buttonValue, buttonIndex);
	};

	PhoneGap.exec(callback, callback, service, action, [config]);
};

PhoneGap.addConstructor(function() {
	if(!window.plugins) window.plugins = {};
	window.plugins.actionSheet = new ActionSheet();
});
