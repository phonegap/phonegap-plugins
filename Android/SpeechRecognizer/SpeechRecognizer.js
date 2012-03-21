/**
 *  SpeechRecognizer.js
 *  Speech Recognizer PhoneGap plugin (Android)
 *
 *  @author Colin Turner
 *  @author Guillaume Charhon
 *  MIT Licensed
 */
 
/**
 * c'tor
 */
function SpeechRecognizer() {
}

/**
 * Initialize
 * 
 * @param successCallback
 * @param errorCallback
 */
SpeechRecognizer.prototype.init = function(successCallback, errorCallback) {
     return PhoneGap.exec(successCallback, errorCallback, "SpeechRecognizer", "init", []);
};

/**
 * Recognize speech and return a list of matches
 * 
 * @param successCallback
 * @param errorCallback
 * @param reqCode User-defined integer request code which will be returned when recognition is complete
 * @param maxMatches The maximum number of matches to return. 0 means the service decides how many to return.
 * @param promptString An optional string to prompt the user during recognition
 * @param language is an optional string to pass a language name in IETF BCP 47. If nothing is specified, the currrent phone language is used
 */
SpeechRecognizer.prototype.startRecognize = function(successCallback, errorCallback, reqCode, maxMatches, promptString, language) {
    return PhoneGap.exec(successCallback, errorCallback, "SpeechRecognizer", "startRecognize", [reqCode, maxMatches, promptString, language]);
};

/**
 * Get the list of the supported languages in IETF BCP 47 format
 * 
 * @param successCallback
 * @param errorCallback
 *
 * Returns an array of codes in the success callback
 */
SpeechRecognizer.prototype.getSupportedLanguages = function(successCallback, errorCallback) {
    return PhoneGap.exec(successCallback, errorCallback, "SpeechRecognizer", "getSupportedLanguages", []);
};

/**
 * Load 
 */ 
PhoneGap.addConstructor(function() {
    PhoneGap.addPlugin("speechrecognizer", new SpeechRecognizer());
});


