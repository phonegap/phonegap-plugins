/*
 * Resources
 * Implements the javascript access to the phonegap plugin for retrieving specific resource information
 * @author Olivier Brand
 */

/**
 * @return the Resources class instance
 */
var Resources = function() {
};

/**
 * Returns the named resources defined in R.strings Note the last parameter,
 * this method is synchronous
 * 
 * @param successCallback
 *            The callback which will be called when directory listing is
 *            successful
 * @param failureCallback
 *            The callback which will be called when directory listing encouters
 *            an error
 */
Resources.prototype.getStringResources = function(params, successCallback,
        failureCallback) {
    return cordova.exec(successCallback, failureCallback, 'Resources',
            'getStringResources', [ params ], false);
};



cordova.addConstructor(function() {
    cordova.addPlugin('resources', new Resources());
});