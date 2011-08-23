/**
 * 
 * Phonegap share plugin for Android
 * Kevin Schaul 2011
 *
 */

var Share = function() {};
			
Share.prototype.show = function(content, success, fail) {
	return PhoneGap.exec( function(args) {
		success(args);
	}, function(args) {
		fail(args);
	}, 'Share', '', [content]);
};

PhoneGap.addConstructor(function() {
	/**
	 * Phonegap version < 1.0
	 * use the following line
	 */
	// PhoneGap.addPlugin('share', new Share());
	PluginManager.addService("Share","com.schaul.plugins.share.Share");
});