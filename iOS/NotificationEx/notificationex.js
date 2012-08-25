///////////////////
(function() {
///////////////////

// get local ref to global PhoneGap/Cordova/cordova object for exec function
var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks

/**
 * This class provides extended access to notifications on the device. (iOS)
 * In Cordova.plist/Plugins, add this mapping (key:NotificationEx, value:NotificationEx)
 */
NotificationEx = function() {
};

// iPhone only
NotificationEx.prototype.loadingStart = function(options) {
    cordovaRef.exec(null, null, "NotificationEx","loadingStart", [options]);
};
// iPhone only
NotificationEx.prototype.loadingStop = function() {
    cordovaRef.exec(null, null, "NotificationEx","loadingStop", []);
};

/**
 * Start spinning the activity indicator on the statusbar
 */
NotificationEx.prototype.activityStart = function() {
    cordovaRef.exec(null, null, "NotificationEx", "activityStart", []);
};

/**
 * Stop spinning the activity indicator on the statusbar, if it's currently spinning
 */
NotificationEx.prototype.activityStop = function() {
    cordovaRef.exec(null, null, "NotificationEx", "activityStop", []);
};

NotificationEx.install = function() {
    if (typeof navigator.notificationEx == "undefined") {
		navigator.notificationEx = new NotificationEx();
	}
};

/**
 * Add to Cordova constructor
 */
if (cordovaRef && cordovaRef.addConstructor) {
	cordovaRef.addConstructor(NotificationEx.install);
} else {
	console.log("NotificationEx Cordova Plugin could not be installed.");
	return null;
}


///////////////////
})();
///////////////////
