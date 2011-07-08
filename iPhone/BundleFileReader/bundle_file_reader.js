/**
 * Bundle File Reader Plugin
 * Copyright (c) 2011 Tim Fischbach (github.com/tf)
 * MIT licensed
 */

/*global plugins, PhoneGap*/

/**
 * Read files from application bundle.
 */
plugins.BundleFileReader = (function() {
	function BundleFileReader() {}

	/**
	 * Reads a file from the application bundle. The first three
	 * parameters correspond directly to the parameters of NSBundle
	 * pathForResource:ofType:inDirectory.
	 *
	 * @param resource        {String} Basename of resource file.
	 * @param type            {String} File extension.
	 * @param dir             {String} Directory relative to bundle.
	 * @param successCallback {Function} Receives file contents as
	 *                        first parameter.
	 * @param errorCallback   {Function} Invoked if resource cannot
	 *                        be found.
	 */
	BundleFileReader.prototype.readResource = function(resource, type, dir, successCallback, errorCallback) {
		PhoneGap.exec(function(contents) {
		    successCallback(decodeURIComponent(contents));
		}, errorCallback, "BundleFileReader", "readResource", [resource, type, dir]);
	};

	PhoneGap.addConstructor(function()  {
		if(!window.plugins) {
			window.plugins = {};
		}
		plugins.bundleFileReader = new BundleFileReader();
	});

	return BundleFileReader;
}());