/**
 * This class provides extended access to notifications on the device. (iOS)
 * In config.xml, add this mapping (key:NotificationEx, value:NotificationEx)
 */

 cordova.define("cordova/plugin/notification_ex", function(require, exports, module) {
 	var exec = require('cordova/exec');

 	var NotificationEx = function() {
 		this.serviceName = "NotificationEx";
 	}

 	NotificationEx.prototype.loadingStart = function(options) {
 	    exec(null, null, "NotificationEx","loadingStart", [options]);
 	};

 	NotificationEx.prototype.loadingStop = function() {
 	    exec(null, null, "NotificationEx","loadingStop", []);
 	};

 	/**
 	 * Start spinning the activity indicator on the statusbar
 	 */
 	NotificationEx.prototype.activityStart = function() {
 	    exec(null, null, "NotificationEx", "activityStart", []);
 	};

 	/**
 	 * Stop spinning the activity indicator on the statusbar, if it's currently spinning
 	 */
 	NotificationEx.prototype.activityStop = function() {
 	    exec(null, null, "NotificationEx", "activityStop", []);
 	};

 	NotificationEx.install = function() {
 	    if (typeof navigator.notificationEx == "undefined") {
 			navigator.notificationEx = new NotificationEx();
 		}
 	};

 	var notificationEx = NotificationEx.install();
 	module.exports = notificationEx;
 });
