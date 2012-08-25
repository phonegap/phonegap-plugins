/*
 * RemoteSound
 * Implements the javascript access to the phonegap plugin for playing and loading remote sounds
 * @author Olivier Brand
 */

/**
 * @return the deviceInfo class instance
 */
var RemoteSound = function() {
};

/**
 * Play a sound. Parameter is a URI called "soundName"
 * 
 * @param successCallback
 *            The callback which will be called when directory listing is
 *            successful
 * @param failureCallback
 *            The callback which will be called when directory listing encouters
 *            an error
 */
RemoteSound.prototype.playRemoteSound = function(params, successCallback,
		failureCallback) {
	return cordova.exec(successCallback, failureCallback, 'RemoteSound',
			'playRemoteSound', [ params ], true);
};

/**
 * Load and cache remote sounds. Parameter is a JSON Array of URLs pointing to sound assets
 * 
 * @param successCallback
 *            The callback which will be called when directory listing is
 *            successful
 * @param failureCallback
 *            The callback which will be called when directory listing encouters
 *            an error
 */
RemoteSound.prototype.loadRemoteSounds = function(params, successCallback,
        failureCallback) {
    return cordova.exec(successCallback, failureCallback, 'RemoteSound',
            'loadRemoteSounds', [ params ], true);
};


cordova.addConstructor(function() {
	cordova.addPlugin('remotesound', new RemoteSound());
});