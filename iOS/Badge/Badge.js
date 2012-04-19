/*
 *  This code is adapted from the work of Michael Nachbaur 
 *  by Simon Madine of The Angry Robot Zombie Factory
 *   - Converted to Cordova 1.6.1 by Joseph Stuhr.
 *  2012-04-19
 *  MIT licensed
 *
 */

/*
 * Temporary Scope to contain the plugin.
 *  - More information here:
 *     https://github.com/apache/incubator-cordova-ios/blob/master/guides/Cordova%20Plugin%20Upgrade%20Guide.md
 */
(function(){

	/* Get local ref to global PhoneGap/Cordova/cordova object for exec function.
		- This increases the compatibility of the plugin. */
	var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks

 	/*
  	 * This class exposes the iPhone 'icon badge' functionality to JavaScript
  	 * to add a number (with a red background) to each icon.
  	*/
	function Badge() { }
 
	/**
 	 * Positive integer sets the badge amount, 0 or negative removes it.
	 */
	Badge.prototype.set = function(options) {
	    cordovaRef.exec("Badge.setBadge", options);
	};

	/**
	 * Shorthand to set the badge to 0 and remove it.
	 */
	Badge.prototype.clear = function() {
	    cordovaRef.exec("Badge.setBadge", 0);
	};

	cordovaRef.addConstructor(function() {
		if(!window.plugins) {
			window.plugins = {};
		}
		if(!window.plugins.badge) {
    		window.plugins.badge = new Badge();
		}
	});
	
})(); /* End of Temporary Scope. */