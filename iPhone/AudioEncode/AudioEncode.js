//
//  AudioEncode.js
//
//  Created by Lyle Pratt, September 2011.
//  MIT licensed
//

/**
 * This class converts audio at a file path to M4A format
 * @constructor
 */
function AudioEncode() {
}

AudioEncode.prototype.encodeAudio = function(audioPath, successCallback, failCallback) {
    PhoneGap.exec("AudioEncode.encodeAudio", audioPath, GetFunctionName(successCallback), GetFunctionName(failCallback));
};

PhoneGap.addConstructor(function()
{
	if(!window.plugins)
	{
		window.plugins = {};
	}
    window.plugins.AudioEncode = new AudioEncode();
});
