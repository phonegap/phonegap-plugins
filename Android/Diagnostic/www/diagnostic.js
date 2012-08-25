/**
 *  Plugin diagnostic
 *
 *  Copyright (c) 2012 AVANTIC ESTUDIO DE INGENIEROS
 *  
**/


var Diagnostic = function() {
};


/**
 * Checks device settings for location.
 *
 * @param successCallback		The callback which will be called when diagnostic of location is successful.
 * 								This callback function have a boolean param with the diagnostic result.
 * @param errorCallback			The callback which will be called when diagnostic of location encounters an error.
 * 								This callback function have a string param with the error.
 */
Diagnostic.prototype.isLocationEnabled = function(successCallback, errorCallback) {
	return cordova.exec(successCallback,
						errorCallback,
						'Diagnostic',
						'isLocationEnabled',
						[]);
};

/**
 * Requests that the user enable the location services in device settings.
 */
Diagnostic.prototype.switchToLocationSettings = function() {
	return cordova.exec(null,
						null,
						'Diagnostic',
						'switchToLocationSettings',
						[]);
};

/**
 * Checks device settings for GPS.
 *
 * @param successCallback		The callback which will be called when diagnostic of GPS is successful.
 * 								This callback function have a boolean param with the diagnostic result.
 * @param errorCallback			The callback which will be called when diagnostic of GPS encounters an error.
 * 								This callback function have a string param with the error.
 */
Diagnostic.prototype.isGpsEnabled = function(successCallback, errorCallback) {
	return cordova.exec(successCallback,
						errorCallback,
						'Diagnostic',
						'isGpsEnabled',
						[]);
};

/**
 * Checks device settings for wireless network location (Wi-Fi and/or mobile networks).
 *
 * @param successCallback		The callback which will be called when diagnostic of wireless network location is successful.
 * 								This callback function have a boolean param with the diagnostic result.
 * @param errorCallback			The callback which will be called when diagnostic of wireless network location encounters an error.
 * 								This callback function have a string param with the error.
 */
Diagnostic.prototype.isWirelessNetworkLocationEnabled = function(successCallback, errorCallback) {
	return cordova.exec(successCallback,
						errorCallback,
						'Diagnostic',
						'isWirelessNetworkLocationEnabled',
						[]);
};

/**
 * Checks device settings for Wi-Fi.
 *
 * @param successCallback		The callback which will be called when diagnostic of Wi-Fi is successful.
 * 								This callback function have a boolean param with the diagnostic result.
 * @param errorCallback			The callback which will be called when diagnostic of Wi-Fi encounters an error.
 * 								This callback function have a string param with the error.
 */
Diagnostic.prototype.isWifiEnabled = function(successCallback, errorCallback) {
	return cordova.exec(successCallback,
						errorCallback,
						'Diagnostic',
						'isWifiEnabled',
						[]);
};

/**
 * Requests that the user enable the Wi-Fi in device settings.
 */
Diagnostic.prototype.switchToWifiSettings = function() {
	return cordova.exec(null,
						null,
						'Diagnostic',
						'switchToWifiSettings',
						[]);
};

/**
 * Checks device settings for bluetooth.
 *
 * @param successCallback		The callback which will be called when diagnostic of bluetooth is successful.
 * 								This callback function have a boolean param with the diagnostic result.
 * @param errorCallback			The callback which will be called when diagnostic of bluetooth encounters an error.
 * 								This callback function have a string param with the error.
 */
Diagnostic.prototype.isBluetoothEnabled = function(successCallback, errorCallback) {
	return cordova.exec(successCallback,
						errorCallback,
						'Diagnostic',
						'isBluetoothEnabled',
						[]);
};
 

/**
 * Requests that the user enable the bluetooth in device settings.
 */
Diagnostic.prototype.switchToBluetoothSettings = function() {
	return cordova.exec(null,
						null,
						'Diagnostic',
						'switchToBluetoothSettings',
						[]);
};

cordova.addConstructor(function() {
	cordova.addPlugin("diagnostic", new Diagnostic());
});