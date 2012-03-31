## PhoneGap AudioRecord Plugin ##
by Lyle Pratt

## About this Plugin ##

PhoneGap's media library does not let you provide settings to the audio recording functionality resulting in large, stereo files of a specific, unchangeable bitrate and sampling rate. These functions are intended to remedy that.

## Using the Plugin ##

The plugin adds two methods to Phonegap's existing media class: `media.startRecordWithSettings(options)` and `media.stopRecordWithSettings`. You must include all of the encoding options listed in the example or it will crash. The plugin will allows you to pass a FormatID, SampleRate, NumberOfChannels, and LinearPCMBitDepth to the record function.

		var recordSettings = {
                	"FormatID": "kAudioFormatULaw",
                        "SampleRate": 8000.0,
                        "NumberOfChannels": 1,
                        "LinearPCMBitDepth": 16
                }
		media.startRecordWithSettings(recordSettings);
		media.stopRecordWithSettings();

## Adding the Plugin to your project ##

Using this plugin requires [iPhone PhoneGap](http://github.com/phonegap/phonegap-iphone).

1. Make sure your PhoneGap Xcode project has been updated.
2. Add the .h and .m files to your Plugins folder in your project.
3. Add the .js files to your "www" folder on disk, and add reference(s) to the .js files in your html file(s).

## RELEASE NOTES ##

#### 2012-03-31

- Cordova 1.5.0 support by Francis Chong (@siuying) 

## LICENSE ##

The MIT License

Copyright (c) 2011 Lyle Pratt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

