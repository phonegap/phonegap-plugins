/**
 * Phonegap Wikitude AR Camera plugin
 * Copyright (c) Spletart 2011
 */
var WikitudeCamera = function() { 

}

WikitudeCamera.prototype.show = function(data, success, fail, options) {
    return PhoneGap.exec(function(args) {
        success(args);
    }, function(args) {
        fail(args);
    }, 'WikitudeCamera', 'show', [data, options]);
};

PhoneGap.addConstructor(function() {
	PhoneGap.addPlugin('wikitudeCamera', new WikitudeCamera());
});