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
		callbackId = service + (PhoneGap.callbackId + 1);

	var config = {
		title : title+'' || 'Title',
		items : items || ['Cancel'],
		callback : fn || function(){},
		scope: options.hasOwnProperty('scope') ? options.scope : null,
		style : options.hasOwnProperty('style') ? options.style+'' : 'default',
		destructiveButtonIndex : options.hasOwnProperty('destructiveButtonIndex') ? options.destructiveButtonIndex*1 : false,
		cancelButtonIndex : options.hasOwnProperty('cancelButtonIndex') ? options.cancelButtonIndex*1 : false
	};

	var callback = function(result) {
		var buttonValue = false, // value for cancelButton
			buttonIndex = result.buttonIndex;

		if(!config.cancelButtonIndex || result.buttonIndex != config.cancelButtonIndex) {
			buttonValue = config.items[result.buttonIndex];
		}

		config.callback.call(config.scope || null, button, result.buttonIndex);
	};

	PhoneGap.exec(callback, callback, 'ActionSheet', 'create', [config]);
};

PhoneGap.addConstructor(function() {
	if(!window.plugins) window.plugins = {};
	window.plugins.actionSheet = new ActionSheet();
});
