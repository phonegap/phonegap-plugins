/**
 * Phonegap DatePicker Plugin Copyright (c) Greg Allen 2011 MIT Licensed
 * Reused and ported to Android plugin by Daniel van 't Oever
 */
cordova.define("cordova/plugin/datepicker", function(require, exports, module) {
	var exec = require("cordova/exec");

	/**
	 * Constructor
	 */
	var DatePicker = function() {
		this._callback;
	};

	/**
	 * show - true to show the ad, false to hide the ad
	 */
	DatePicker.prototype.show = function(options, cb) {
		if (options.date) {
			options.date = (options.date.getMonth() + 1) + "/" + (options.date.getDate()) + "/" + (options.date.getFullYear()) + "/"
					+ (options.date.getHours()) + "/" + (options.date.getMinutes());
		}
		var defaults = {
			mode : '',
			date : '',
			allowOldDates : true
		};

		for ( var key in defaults) {
			if (typeof options[key] !== "undefined")
				defaults[key] = options[key];
		}
		this._callback = cb;

		return cordova.exec(cb, failureCallback, 'DatePickerPlugin', defaults.mode, new Array(defaults));
	};

	DatePicker.prototype._dateSelected = function(date) {
		var d = new Date(parseFloat(date) * 1000);
		if (this._callback)
			this._callback(d);
	};

	function failureCallback(err) {
		console.log("datePickerPlugin.js failed: " + err);
	}

	var datePicker = new DatePicker();
	module.exports = datePicker; 
});
