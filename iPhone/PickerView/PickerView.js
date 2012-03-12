//
//  PickerView.js
//
// Created by Olivier Louvignes on 11/28/2011.
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

function PickerView() {}

PickerView.prototype.create = function(title, items, fn, options) {
	if(!options) options = {};

	var service = 'PickerView',
	action = 'create',
	callbackId = service + (PhoneGap.callbackId + 1);

	var config = {
		title : title || ' ', // avoid blur with a !empty title
		items : items || {},
		callback : fn || function(){},
		style : options.hasOwnProperty('style') ? options.style+'' : 'default',
		doneButtonLabel : options.hasOwnProperty('doneButtonLabel') ? options.doneButtonLabel+'' : "Done",
		cancelButtonLabel : options.hasOwnProperty('cancelButtonLabel') ? options.cancelButtonLabel+'' : "Cancel"
	};

	// Force strings for items data text
	for (var key in items) {
		for (var _key in items[key].data) {
			items[key].data[_key].text = items[key].data[_key].text + '';
		}
	}

	var callback = function(result) {
		console.warn(service + '::callback', [this, arguments]);
		// Done
		if(result.buttonIndex !== 0) {
			config.callback.call(options.scope  || null, result.values, result.buttonIndex);
		// Cancel
		} else {
			config.callback.call(options.scope  || null, {}, result.buttonIndex);
		}
	};

	console.warn('config', config);
	PhoneGap.exec(callback, callback, service, action, [config]);
};

PhoneGap.addConstructor(function() {
	if(!window.plugins) window.plugins = {};
	window.plugins.pickerView = new PickerView();
});
