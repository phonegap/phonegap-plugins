/*
 *  This code is adapted from the work of Michael Nachbaur 
 *  by Simon Madine of The Angry Robot Zombie Factory
 *  2010-05-04
 *  MIT licensed
 *
 *  Converted to Cordova by Joseph Stuhr.
*/

/**
 * This class exposes the iPhone 'icon badge' functionality to JavaScript
 * to add a number (with a red background) to each icon
 * @constructor
 */
function Badge() {
}

/**
 * Positive integer sets the badge, 0 or negative clears it
 */
Badge.prototype.set = function(options) {
    Cordova.exec("Badge.setBadge", options);
};

/**
 * Shorthand to set the badge to 0
 */
Badge.prototype.clear = function() {
    Cordova.exec("Badge.setBadge", 0);
};

Cordova.addConstructor(function() {
	if(!window.plugins) {
		window.plugins = {};
	}
	if(!window.plugins.badge) {
    	window.plugins.badge = new Badge();
	}
});