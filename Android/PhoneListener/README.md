PhoneListener
============

Installation
------------

**Modified by Matt McGrath to work on versions of PhoneGap 1.6 (cordova) upwards**

This plugin allows your application to monitor changes in the phone's state (RINGING, OFFHOOK and IDLE) so that you can respond to them appropriately (pause your Media stream, etc).

Add the plugin much like any other:

1.      Add the PhoneListener.js file to your 'assets/www' folder
2.      Create an 'org/devgeeks' folder under 'src' and add the PhoneListener.java file to it
3.		Add the PhoneListener.js to your html file. eg: `<script type="text/javascript" charset="utf-8" src="PhoneListener.js"></script>`
4.      Add the plugin to the 'res/xml/plugins.xml' file. eg: `<plugin name="PhoneListener" value="org.devgeeks.PhoneListener"/>`
5.		Make sure you have allowed the permission 'READ_PHONE_STATE' in your 'AndroidManifest.xml. eg: `<uses-permission android:name="android.permission.READ_PHONE_STATE" />`

### Example
```javascript
function onDeviceReady()
{
	PhoneListener.start(onPhoneStateChanged,onError);
	// or...
	// PhoneListener.stop(onSuccess,onError);
}

function onPhoneStateChanged(phoneState) 
{
	switch (phoneState) {
		case "RINGING":
			console.log('Phone is ringing.');
			break;
		case "OFFHOOK":
			console.log('Phone is off the hook.');
			break;
		case "IDLE":
			console.log('Phone has returned to the idle state.');
			break;
		default:
			// no default...
	}
}

function onError(error) {
	// do something...
}
function onSuccess() {
	// do something else...
}
```

## License

The MIT License

Copyright (c) 2011 Tommy-Carlos Williams (github.com/devgeeks)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
