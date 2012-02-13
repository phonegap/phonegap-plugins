# Android SpeechRecognizer plugin for Phonegap #

This plugin will recognize commands, phrases, etc as spoken by the user.
A collection of possible matches (strings) are returned to your app.

## Adding the Plugin to your project ##

Of course this plugin requires [Android PhoneGap](http://github.com/phonegap/phonegap-android).

1. To install the plugin, copy SpeechRecognizer.js to your project's www folder.
2. Add SpeechRecognizer.js to your html file, eg: `<script type="text/javascript" charset="utf-8" src="SpeechRecognizer.js"></script>`
3. Create an 'com/urbtek/phonegap' path under 'src' and add the SpeechRecognizer.java file to it
4. Add the plugin to the 'res/xml/plugins.xml' file. eg: `<plugin name="SpeechRecognizer" value="com.urbtek.phonegap.SpeechRecognizer"/>`

### Example
```javascript
function onDeviceReady()
{
    window.plugins.speechrecognizer.init(speechInitOk, speechInitFail);
    // etc.
}

function speechInitOk() {
	// we're good
}
function speechInitFail(m) {
	// recognizer not present?
}

function recognizeSpeech() {
    var requestCode = 1234;
    var maxMatches = 5;
    var promptString = "Please say a command";
    window.plugins.speechrecognizer.startRecognize(speechOk, speechFail, requestCode, maxMatches, promptString);
}

function speechOk(result) {
    var match, respObj, requestCode;
    if (result) {
        respObj = JSON.parse(result);
        if (respObj) {
            // This is the code that was sent with the original request
            requestCode = respObj.speechMatches.requestCode;
            
            for (match in respObj.speechMatches.speechMatch) {
                console.log("possible match: " + respObj.speechMatches.speechMatch[match]);
                // regex comes in handy for dealing with these match strings
            }
        }        
    }
}

function speechFail(m) {
    console.log("speechFail: " + m.toString());
}

```

## RELEASE NOTES ##

### September 16, 2011 ###

* Initial release

## License

The MIT License

Copyright (c) 2011 Colin Turner (github.com/koolspin)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
