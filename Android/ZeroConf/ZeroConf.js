/**
 * ZeroConf plugin for Cordova/Phonegap
 *
 * @author Matt Kane
 * Copyright (c) Triggertrap Ltd. 2012. All Rights Reserved.
 * Available under the terms of the MIT License.
 * 
 */
var ZeroConf = {
	watch: function(type, callback) {
		return cordova.exec(function(result) {
			if(callback) {
				callback(result);
			}

		}, ZeroConf.fail, "ZeroConf", "watch", [type]);
	},
	unwatch: function(type) {
		return cordova.exec(null, ZeroConf.fail, "ZeroConf", "unwatch", [type]);
	},
	close: function() {
		return cordova.exec(null, ZeroConf.fail, "ZeroConf", "close", [])
	},
	register: function(type, name, port, text) {
		if(!type) {
			console.error("'type' is a required field");
			return;
		}
		return cordova.exec(null, ZeroConf.fail, "ZeroConf", "register", [type, name, port, text]);
	}
	unregister: function() {
		return cordova.exec(null, ZeroConf.fail, "ZeroConf", "unregister", [])
	},
	fail: function (o) {
		console.error("Error " + JSON.stringify(o));
	}
}