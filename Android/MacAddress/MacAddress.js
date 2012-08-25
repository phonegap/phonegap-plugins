/*
 * MacAddress
 * Implements the javascript access to the cordova plugin for retrieving the device mac address. Returns 0 if not running on Android
 * @author Olivier Brand
 */

/**
 * @return the mac address class instance
 */
var MacAddress = function() {
};

/**
 * Returns the mac address of the device. Return a 00:00:00:00:00:00 for
 * emulator based runtime or just PC web
 * 
 * @param successCallback
 *            The callback which will be called when directory listing is
 *            successful
 * @param failureCallback
 *            The callback which will be called when directory listing encouters
 *            an error
 */
MacAddress.prototype.getMacAddress = function(successCallback, failureCallback) {
	return cordova.exec(successCallback, failureCallback, 'MacAddress',
			'getMacAddress', [], false);
};

cordova.addConstructor(function() {
    cordova.addPlugin('macaddress', new MacAddress());
});