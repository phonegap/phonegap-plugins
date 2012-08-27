# Application Preference plugin for Phonegap #
By Tue Topholm / Sugee

## Adding the Plugin to your project ##
Copy the .h and .m file to the Plugins directory in your project. Copy the .js file to your www directory and reference it from your html file(s). 


## Using the plugin ##
The plugin creates the object `window.plugins.applicationPreferences` with two methods `get(name, success, fail)` and 
`set(name, value, success, fail)`. `name` is the name of the setting you want, `value` is the value of the setting you want to set.

`success` and `fail` are callback functions. Success is passed the settings value as a string.
A full get example could be:

    window.plugins.applicationPreferences.get('name_identifier', function(result) {
            alert("We got a setting: " + result);
        }, function(error) {
		    alert("Failed to retrieve a setting: " + error);
	    }
	);

A full set example could be:

    window.plugins.applicationPreferences.set('name_identifier','homer' function() {
            alert("It is saved");
        }, function(error) {
		    alert("Failed to retrieve a setting: " + error);
	    }
	);

## Registering the plugin ## 

1. Opne Cordovo.plist file in Xcode
2. To the plugins Dictionary add a new String item
3. Name and value of the item would be "applicationPreferences"


## BUGS AND CONTRIBUTIONS ##
The latest release version is available [on GitHub](https://github.com/ttopholm/phonegap-plugins/)
If you have a patch, fork my repo and send me a pull request. Submit bug reports on GitHub, please.
	
## Licence ##

The MIT License

Copyright (c) 2011 Tue Topholm / Sugee

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
