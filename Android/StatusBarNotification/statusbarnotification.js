
/**
 *  
 *	Constructor
 */
var NotificationMessenger = function() { 
}

/**
 * @param title Title of the notification
 * @param body Body of the notification
 */
NotificationMessenger.prototype.notify = function(title, body) {
    return PhoneGap.exec(null, null, 'StatusBarNotificationPlugin',	'notify', [title, body]);
};

/**
 * 	Load StatusBarNotification
 * */

PhoneGap.addConstructor(function() {
	PhoneGap.addPlugin('statusBarNotification', new NotificationMessenger());
	
//	@deprecated: No longer needed in PhoneGap 1.0. Uncomment the addService code for earlier 
//	PhoneGap releases.
//	PluginManager.addService("StatusBarNotificationPlugin","com.trial.phonegap.plugin.directorylisting.StatusBarNotificationPlugin");
});