# ClipboardManager plugin for Phonegap #
By Omer Saatcioglu
Enhanced by Guillaume Charhon

## Adding the Plugin to your project ##
1. To install the plugin, move clipboardmanager.js to your project's www folder and include a reference to it in your html files. 
2. Create a folder called 'src/com/saatcioglu/phonegap/clipboardmanager' within your project's src folder.
3. Copy ClipboardManagerPlugin.java into that new folder.
4. Add in your plugins.xml (located in /res/xml/)
<plugin name="ClipboardManager" value="com.saatcioglu.phonegap.clipboardmanager.ClipboardManagerPlugin"/>

## Using the plugin ##
The plugin creates the object `window.plugins.clipboardManager` with the methods 

`copy(str, success, fail)` that copies the given string
`paste(success, fail)` that returns the text from the Clipboard

`success` and `fail` are callback functions. 

An example for copy:

	window.plugins.clipboardManager.copy(
		"the text to copy",
		function(r){alert("copy is successful")},
		function(e){alert(e)}
	);

An example for paste:

	window.plugins.clipboardManager.paste(
		function(r){alert("The text in the clipboard is " + r)},
		function(e){alert(e)}
	);

	
## Licence ##
The MIT License

Copyright (c) 2010 Matt Kane

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