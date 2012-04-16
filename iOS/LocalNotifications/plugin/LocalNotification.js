/**
	Phonegap LocalNotification Plugin
	Copyright (c) Greg Allen 2011
	Updates Drew Dahlman 2012
	
	MIT Licensed

	Usage:
	plugins.localNotification.add({ date: new Date(), message: 'This is a notification', badge: 1, id: 123, sound:'sub.caf',background:'app.background()',foreground:'app.running()' });
	plugins.localNotification.cancel(123);
	plugins.localNotification.cancelAll();
**/
if (typeof cordova !== "undefined") {
	var LocalNotification = function() {
	};

	LocalNotification.prototype.add = function(options) {
        var defaults = {
            date: false,
            message: '',
            hasAction: true,
            action: 'View',
            badge: 0,
            id: 0,
			sound:'',
			background:'',
			foreground:''
        };
        for (var key in defaults) {
            if (typeof options[key] !== "undefined")
                defaults[key] = options[key];
        }
		if (typeof defaults.date == 'object') {
			defaults.date = Math.round(defaults.date.getTime()/1000);
		}
        cordova.exec(null,null,"LocalNotification","addNotification",[defaults]);
	};

	LocalNotification.prototype.cancel = function(id) {
		cordova.exec("LocalNotification.cancelNotification", id);
	};
	
	LocalNotification.prototype.cancelAll = function(id) {
        cordova.exec("LocalNotification.cancelAllNotifications");
    };

	cordova.addConstructor(function() 
	{
		if(!window.plugins)
		{
			window.plugins = {};
		}
		window.plugins.localNotification = new LocalNotification();
	});
}
