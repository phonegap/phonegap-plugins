/*
 *  This code is adapted from the work of Michael Nachbaur 
 *  by Simon Madine of The Angry Robot Zombie Factory
 *  2010-05-04
 *  MIT licensed
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
    PhoneGap.exec("Badge.setBadge", options);
};

/**
 * Shorthand to set the badge to 0
 */
Badge.prototype.clear = function() {
    PhoneGap.exec("Badge.setBadge", 0);
};

PhoneGap.addConstructor(function() 
{
	if(!window.plugins)
	{
		window.plugins = {};
	}
    window.plugins.badge = new Badge();
});
