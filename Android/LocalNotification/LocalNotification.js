/*-
 * Phonegap LocalNotification Plugin for Android
 * 
 * Created by Daniel van 't Oever 2012 MIT Licensed
 * 
 * Usage: 
 * 
 * plugins.localNotification.add({ date: new Date(), message: 'This is an Android alarm using the statusbar', id: 123 });
 * plugins.localNotification.cancel(123); 
 * plugins.localNotification.cancelAll();
 * 
 * This interface is similar to the existing iOS LocalNotification plugin created by Greg Allen
 */
if (typeof PhoneGap !== "undefined") {

	/**
	 * Empty constructor
	 */
	var LocalNotification = function() {
	};

	/**
	 * Register a notification message for a specific date / time
	 * 
	 * @param successCB
	 * @param failureCB
	 * @param options
	 *            Array with arguments. Valid arguments are date, message,
	 *            repeatDaily and id
	 */
	LocalNotification.prototype.add = function(options) {
		var defaults = {
			date : new Date(),
			message : '',
			ticker : '',
			repeatDaily : false,
			id : ""
		};

		if (options.date) {
			options.date = (options.date.getMonth()) + "/" + (options.date.getDate()) + "/"
					+ (options.date.getFullYear()) + "/" + (options.date.getHours()) + "/"
					+ (options.date.getMinutes());
		}

		for ( var key in defaults) {
			if (typeof options[key] !== "undefined")
				defaults[key] = options[key];
		}

		PhoneGap.exec(null, null, 'LocalNotification', 'add', new Array(defaults));
	};

	/**
	 * Cancel an existing notification using its original ID.
	 * 
	 * @param id
	 *            The ID that was used when creating the notification using the
	 *            'add' method.
	 */
	LocalNotification.prototype.cancel = function(notificationId) {
		PhoneGap.exec(null, null, 'LocalNotification', 'cancel', new Array({
			id : notificationId
		}));
	};

	/**
	 * Cancel all notifications that were created by your application.
	 */
	LocalNotification.prototype.cancelAll = function() {
		PhoneGap.exec(null, null, 'LocalNotification', 'cancelAll', new Array());
	};

	/**
	 * Register this plugin with phonegap
	 */
	PhoneGap.addConstructor(function() {
		if (!window.plugins) {
			window.plugins = {};
		}
		window.plugins.localNotification = new LocalNotification();
	});
}
