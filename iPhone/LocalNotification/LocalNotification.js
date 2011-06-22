/**
	Phonegap LocalNotification Plugin
	Copyright (c) Greg Allen 2011
	MIT Licensed

	Usage:
	plugins.localNotification.add({ date: new Date(), message: 'This is a notification', badge: 1, id: 123 });
	plugins.localNotification.cancel(123);
	plugins.localNotification.cancelAll();
**/
if (typeof PhoneGap !== "undefined") {
	var LocalNotification = function() {
	};

	LocalNotification.prototype.add = function(options) {
        var defaults = {
            date: false,
            message: '',
            hasAction: true,
            action: 'View',
            badge: 0,
            id: 0
        };
        for (var key in defaults) {
            if (typeof options[key] !== "undefined")
                defaults[key] = options[key];
        }
		if (typeof defaults.date == 'object') {
			defaults.date = Math.round(defaults.date.getTime()/1000);
		}
		PhoneGap.exec("LocalNotification.addNotification", defaults);
	};

	LocalNotification.prototype.cancel = function(id) {
		PhoneGap.exec("LocalNotification.cancelNotification", id);
	};
	
	LocalNotification.prototype.cancelAll = function(id) {
        PhoneGap.exec("LocalNotification.cancelAllNotifications");
    };

	PhoneGap.addConstructor(function() 
	{
		if(!window.plugins)
		{
			window.plugins = {};
		}
		window.plugins.localNotification = new LocalNotification();
	});
}
