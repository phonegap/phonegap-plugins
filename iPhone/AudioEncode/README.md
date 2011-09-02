## PhoneGap AudioEncode Plugin ##
by Lyle Pratt

## About this Plugin ##

This plugin lets you easily convert WAV audio into M4A audio. It is useful when using Phonegap's audio capture or media recording functionality. Uploading WAV files on via cellular connections is not advised.  M4A encoded files are about 1/4 the size.

## Using the Plugin ##

The plugin creates the object `window.plugins.AudioEncode` with one method `encodeAudio(pathToWavFile, success, fail)`. All parameters are required and it will crash if they are not included. The plugin will encode and save the audio in the same directory the WAV audio was in, then delete the WAV file on completion. If you encode `festMonkey.wav`, you'll get `festMonkey.m4a`.

		window.plugins.AudioEncode.encodeAudio(pathToWavFile, success, fail);

		var success = function(newM4APath) {
			//Do something with your new encoded audio (upload it?)
			console.log(newM4APath);
		}

		var fail = function(statusCode) {
			//Why did it fail?
			console.log(statusCode);
		}

## Adding the Plugin to your project ##

Using this plugin requires [iPhone PhoneGap](http://github.com/phonegap/phonegap-iphone).

1. Make sure your PhoneGap Xcode project has been updated.
2. Add the .h and .m files to your Plugins folder in your project.
3. Add the .js files to your "www" folder on disk, and add reference(s) to the .js files in your html file(s).

## LICENSE ##

The MIT License

Copyright (c) 2011 Lyle Pratt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

