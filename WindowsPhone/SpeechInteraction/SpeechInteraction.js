/* MIT licensed */
// (c) 2013 Harshal Kulkarni,  CHK Sound LLC http://chksound.com/Speech/

/*----------------- Common Initialization for Speech Capabilities ------------------*/
function initSpeech(Success, Failure) {
    cordova.exec(initSuccess, initFailure, "SpeechInteraction", "initSpeech", options);
}

function initSuccess(response) {
    alert('Speech Recognition Capabilities Enabled');
}

function initFailure(response) {
    alert('Speech Recognition capabilities may not work!');
}


/*---------------- START: Text To Speech Capabilities ------------------------------*/
function playTTS(playText) {
    var options = { "text": playText, "playType": 'String', "gender": 'male' };
    cordova.exec(null, null, "SpeechInteraction", "playTTS", options);
}
/*---------------- END: Text To Speech Capabilities ------------------------------*/


/*----------------START: Speech Recognition Capabilities-------------------------*/
function recognizeFromTextList(Success, Failure, promptString, commandList, language) {
    var options = { "promptString": promptString, "commandList": commandList, "language": language };
    cordova.exec(Success, Failure, "SpeechInteraction", "recognizeFromTextList", options);
}

// This assumes SRGS/grxml grammar files are placed under www/grammar folder
function recognizeUsingSRGS(Success, Failure, promptString, grammarURI, language) {
    var options = { "promptString": promptString, "grammarURI": grammarURI, "language": language };
    cordova.exec(Success, Failure, "SpeechInteraction", "recognizeUsingSRGS", options);
}

//Uses Bing.com Speech services. Needs Data Connection. 
function recognizeUsingDictation(Success, Failure, promptString, language) {
    var options = { "promptString": promptString, "language": language };
    cordova.exec(Success, Failure, "SpeechInteraction", "recognizeUsingDictation", options);
}

/*----------------END: Speech Recognition Capabilities-------------------------*/


