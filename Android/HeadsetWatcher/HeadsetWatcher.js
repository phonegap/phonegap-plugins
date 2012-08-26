/**
 * HeadsetWatcher plugin for Cordova/Phonegap
 *
 * Copyright (c) Triggertrap Ltd. 2012. All Rights Reserved.
 * Available under the terms of the MIT License.
 * 
 */
var HeadsetWatcher = {
	watch: function(callback) {
		return cordova.exec(function(result) {
			HeadsetWatcher.plugged = result.plugged;
			if(callback) {
				callback(result);
			}

		}, HeadsetWatcher.fail, "HeadsetWatcher", "watch", []);
	},
	plugged: false
}