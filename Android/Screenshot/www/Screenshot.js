/*
 *  This code is adapted from the work of Michael Nachbaur 
 *  by Simon Madine of The Angry Robot Zombie Factory
 *   - Converted to Cordova 1.6.1 by Josemando Sobral.
 *  2012-07-03
 *  MIT licensed
 */

/*
 * Temporary Scope to contain the plugin.
 *  - More information here:
 *     https://github.com/apache/incubator-cordova-ios/blob/master/guides/Cordova%20Plugin%20Upgrade%20Guide.md
 */
(function() {
	/* Get local ref to global PhoneGap/Cordova/cordova object for exec function.
		- This increases the compatibility of the plugin. */
	var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks

	/**
	 * This class exposes the ability to take a Screenshot to JavaScript
	 */
	function Screenshot() { }

	/**
	 * Save the screenshot to the user's Photo Library
	 */
	Screenshot.prototype.saveScreenshot = function() {
		cordovaRef.exec(null, null, "Screenshot", "saveScreenshot", []);
	};

	cordovaRef.addConstructor(function() {
		if (!window.plugins) {
			window.plugins = {};
		}
		if (!window.plugins.screenshot) {
			window.plugins.screenshot = new Screenshot();
		}
	});

 })(); /* End of Temporary Scope. */