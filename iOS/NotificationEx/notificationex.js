(function(window) {

	var cordovaRef = window.PhoneGap || window.Cordova || window.cordova;

	/**
	* This class provides extended access to notifications on the device. (iOS)
	* In Cordova.plist/Plugins, add this mapping (key:NotificationEx, value:NotificationEx)
	*/
	var NotificationEx = function() {};

	NotificationEx.prototype = {

		// iPhone only
		loadingStart: function(options) {
			cordovaRef.exec(null, null, 'NotificationEx', 'loadingStart', [options]);
		},

		// iPhone only
		loadingStop: function() {
			cordovaRef.exec(null, null, 'NotificationEx', 'loadingStop', []);
		},

		/**
		* Start spinning the activity indicator on the statusbar
		*/
		activityStart: function() {
			cordovaRef.exec(null, null, 'NotificationEx', 'activityStart', []);
		},

		/**
		* Stop spinning the activity indicator on the statusbar, if it's currently spinning
		*/
		activityStop: function() {
			cordovaRef.exec(null, null, 'NotificationEx', 'activityStop', []);
		}

	};

	cordovaRef.addConstructor(function() {
		if (typeof navigator.notificationEx === 'undefined') {
			navigator.notificationEx = new NotificationEx();
		}
	});

}(window));