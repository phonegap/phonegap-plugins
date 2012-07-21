/**
 * Phonegap Wikitude AR Camera plugin
 * Copyright (c) Spletart 2011
 */
var WikitudeCamera = function() {

}

WikitudeCamera.prototype.show = function(data, success, fail, options) {
    return cordova.exec(function(args) {
        success(args);
    }, function(args) {
        fail(args);
    }, 'WikitudeCamera', 'show', [data, options]);
};

cordova.addConstructor(function() {
	cordova.addPlugin('wikitudeCamera', new WikitudeCamera());
});