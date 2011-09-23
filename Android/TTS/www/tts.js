/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 * 
 * Copyright (c) 2011, IBM Corporation
 */

/**
 * Constructor
 */
function TTS() {
}

TTS.STOPPED = 0;
TTS.INITIALIZING = 1;
TTS.STARTED = 2;

/**
 * Play the passed in text as synthasized speech
 * 
 * @param {DOMString} text
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
TTS.prototype.speak = function(text, successCallback, errorCallback) {
     return PhoneGap.exec(successCallback, errorCallback, "TTS", "speak", [text]);
};

/** 
 * Play silence for the number of ms passed in as duration
 * 
 * @param {long} duration
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
TTS.prototype.silence = function(duration, successCallback, errorCallback) {
     return PhoneGap.exec(successCallback, errorCallback, "TTS", "silence", [duration]);
};

/**
 * Starts up the TTS Service
 * 
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
TTS.prototype.startup = function(successCallback, errorCallback) {
     return PhoneGap.exec(successCallback, errorCallback, "TTS", "startup", []);
};

/**
 * Shuts down the TTS Service if you no longer need it.
 * 
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
TTS.prototype.shutdown = function(successCallback, errorCallback) {
     return PhoneGap.exec(successCallback, errorCallback, "TTS", "shutdown", []);
};

/**
 * Finds out if the language is currently supported by the TTS service.
 * 
 * @param {DOMSting} lang
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
TTS.prototype.isLanguageAvailable = function(lang, successCallback, errorCallback) {
     return PhoneGap.exec(successCallback, errorCallback, "TTS", "isLanguageAvailable", [lang]);
};

/**
 * Finds out the current language of the TTS service.
 * 
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
TTS.prototype.getLanguage = function(successCallback, errorCallback) {
     return PhoneGap.exec(successCallback, errorCallback, "TTS", "getLanguage", []);
};

/**
 * Sets the language of the TTS service.
 * 
 * @param {DOMString} lang
 * @param {Object} successCallback
 * @param {Object} errorCallback
 */
TTS.prototype.setLanguage = function(lang, successCallback, errorCallback) {
     return PhoneGap.exec(successCallback, errorCallback, "TTS", "setLanguage", [lang]);
};

/**
 * Load TTS
 */ 
PhoneGap.addConstructor(function() {
    PhoneGap.addPlugin("tts", new TTS());
// @deprecated: No longer needed in PhoneGap 1.0. Uncomment the addService code for earlier 
// PhoneGap releases.
//     PluginManager.addService("TTS", "com.phonegap.plugins.speech.TTS");
});
