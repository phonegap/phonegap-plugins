# Wikitude camera view plugin for Phonegap #

The Augmented Reality Camera view integrated with Wikitude SDK. 
By Sasa Coh, Spletart.

## Adding the Plugin to your project ##
This plugin requires the end user to install [the Wikitude World Browser](http://www.wikitude.com/tour/wikitude-world-browser/download).
If the app is not installed the user will be prompted to install it first time the plugin is used.

1. To install the plugin, move `wikitudecamera.js` to your project's www folder and include a reference to it 
in your html files. 
2. Create a folder called 'com/spletart/mobile' within your project's src/ folder.
3. And copy the java file into that new folder.

    `mkdir -p <your_project>/src/com/spletart/mobile`
	
    `cp ./WikitudeCamera.java <your_project>/src/com/spletart/mobile`

4. Include wikitudearintent.jar (from Wikitude SDK) to build path. Download it from [Wikitude SDK](http://www.wikitude.com/developer/documentation/wikitude-sdk)

5. Add a plugin line to `res/xml/plugins.xml`

    `<plugin name="WikitudeCamera" value="com.spletart.mobile.WikitudeCamera"/>`

## Using the plugin ##
The plugin creates the object `window.plugins.wikitudeCamera` with method `show(data, success, fail, options)`.
Argument `data` is a JSON array of POI's as specified in WikitudePOI class from Wikitude SDK. If you pass null then error will be reported.

The `success` and `fail` are callback functions. `options` allows you to change the strings used in the dialog box displayed 
if the user doesn't have Wikitude installed. The defaults are:

```javascript
{
	title : "AR Camera",
	installTitle : "Install Wikitude browser?",
	installMessage : "This requires the free Wikitude World Browser app. Would you like to install it now?",
	yesString : "Yes",
	noString : "No"
}
```

A full example could be:

```javascript
var data = [{ 
				longitude: 15.643724,
				latitude: 46.560732,
				altitude: 246,
				name: 'Maribor',
				description: 'Nice place to write phonegap plugins...',
			}
			//, {
			//	...the next POI
			//}
];			
window.plugins.wikitudeCamera.show(data, function(result) {
		alert("Code: " + result);
	}, function(error) {
		alert("Camera view failed: " + error);
	}, {
		title : "AR Camera",
		installTitle : "Install Wikitude browser?",
		installMessage : "This requires the free Wikitude World Browser app. Would you like to install it now?",
		yesString : "Yes",
		noString : "No"
	});
```

## Release Notes

0.1.0 Initial Release (october 2011)


## BUGS AND CONTRIBUTIONS ##
The latest version is available [on GitHub](http://github.com/sasacoh/phonegap-plugins/tree/master/Android/WikitudeCamera)
If you have a patch, fork my repo baby and send me a pull request. Submit bug reports on GitHub, please.
	
## Licence ##

The MIT License

Copyright (c) 2011 Spletart (sasacoh), All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.




	