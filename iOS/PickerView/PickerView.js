//
//  PickerView.js
//
// Created by Olivier Louvignes on 11/28/2011.
// Added Cordova support on 04/09/2012
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

function PickerView() {}

PickerView.prototype.create = function(title, items, callback, options) {
	if(!options) options = {};
	var scope = options.scope || null;
	delete options.scope;

	var service = 'PickerView',
		action = 'create',
		callbackId = service + (cordova.callbackId + 1);

	var config = {
		title : title || ' ', // avoid blur with a !empty title
		items : items || {},
		style : options.style || 'default',
		doneButtonLabel : options.doneButtonLabel || "Done",
		cancelButtonLabel : options.cancelButtonLabel || "Cancel"
	};

	// Force strings for items data text
	for (var key in items) {
		for (var _key in items[key].data) {
			items[key].data[_key].text = items[key].data[_key].text + '';
		}
	}

	var _callback = function(result) {
		var values = result.values,
			buttonIndex = result.buttonIndex;

		if(buttonIndex !== 0) { // Done
			callback.call(scope, values, buttonIndex);
		} else { // Cancel
			callback.call(scope, {}, buttonIndex);
		}
	};

	return cordova.exec(_callback, _callback, service, action, [config]);

};

cordova.addConstructor(function() {
	if(!window.plugins) window.plugins = {};
	window.plugins.pickerView = new PickerView();
});
