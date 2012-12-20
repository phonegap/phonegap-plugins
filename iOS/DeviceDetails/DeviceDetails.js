;(function(cordova) {

	function DeviceDetails() {}

	DeviceDetails.prototype.getDetails = function(callback) {
		cordova.exec(callback, callback, "DeviceDetails", "getDeviceDetails", [])
	}

	DeviceDetails.prototype.getUUID = function(callback) {
		cordova.exec(callback, callback, "DeviceDetails", "getDeviceUUID", [])
	}

 	if (!window.plugins) window.plugins = {}
	window.plugins.deviceDetails = new DeviceDetails()

})(window.cordova || window.Cordova || window.PhoneGap);
