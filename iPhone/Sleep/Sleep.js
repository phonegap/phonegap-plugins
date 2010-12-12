/**
 * This class exposes the ability to prevent sleep to JavaScript
 * @constructor
 */
function Sleep() {
}

/**
 * Enable sleep
 */
Sleep.prototype.enable = function() {
    PhoneGap.exec("Sleep.enable");
};

/**
 * Disable sleep
 */
Sleep.prototype.disable = function() {
    PhoneGap.exec("Sleep.disable");
};

PhoneGap.addConstructor(function() {
	if(!window.plugins) 
		window.plugins = {};

    window.plugins.sleep = new Sleep();
});
