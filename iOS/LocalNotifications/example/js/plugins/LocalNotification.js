/**
	Usage:
	plugins.localNotification.add({ date: new Date(), message: 'This is a notification', badge: 1, id: 123, sound:'sub.caf',background:'app.background()',foreground:'app.running()' });
	plugins.localNotification.cancel(123);
	plugins.localNotification.cancelAll();
**/

cordova.define("cordova/plugin/localnotification", function(require, exports, module) {
	var exec = require('cordova/exec');
	
	var LocalNotification = function() {};
	

	LocalNotification.prototype.add = function(successFn, errorFn, options) {
		var defaults = {
			date: false,
			message: '',
			hasAction: true,
			action: 'View',
			repeat: '',
			badge: 0,
			id: 0,
			background:'',
			foreground:'',
			sound: '' 
		};
		for (var key in defaults) {
			if (typeof options[key] !== "undefined")
				defaults[key] = options[key];
		}
		if (typeof defaults.date == 'object') {
			defaults.date = Math.round(defaults.date.getTime()/1000);
		}
	  exec(successFn, errorFn, 'LocalNotification', 'addNotification', [
	  	defaults.date, 
	  	defaults.message, 
	  	defaults.hasAction, 
	  	defaults.action, 
	  	defaults.repeat,
	  	defaults.badge,
	  	defaults.id,
	  	defaults.background,
	  	defaults.foreground,
			defaults.sound // '' = default sound, 'none' = silent, 'mysound.caf' == custom sound
	  ]);
	}

	LocalNotification.prototype.cancel = function(successFn, errorFn, id) {
	    exec(successFn, errorFn, 'LocalNotification', 'cancelNotification', [id]);
	}
	
    LocalNotification.prototype.cancelAll = function(successFn, errorFn) {
        exec(successFn, errorFn, 'LocalNotification', 'cancelAllNotifications', []);
    }
	
	var localnotification = new LocalNotification();
	module.exports = localnotification;
});
