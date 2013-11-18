# WebIntents plugin for Phonegap #
By Boris Smus

## Adding the Plugin to your project ##
1. To install the plugin, move webintent.js to your project's www folder and include a reference to it in your html files. 
2. Create a folder called "borismus" within your project's src/com/ folder and move the java file into it.

## Using the plugin ##
The plugin creates the object `window.plugins.webintent` with three methods:

### startActivity ###
Launches an Android intent. For example:


    window.plugins.webintent.startActivity({
        action: WebIntent.ACTION_VIEW,
        url: 'geo:0,0?q=' + address}, 
        function() {}, 
        function() {alert('Failed to open URL via Android Intent')};
    );


### hasExtra ###
checks if this app was invoked with the specified extra. For example:

    window.plugins.webintent.hasExtra(WebIntent.EXTRA_TEXT, 
        function(has) {
            // has is true iff it has the extra
        }, function() {
            // Something really bad happened.
        }
    );
 
### getExtra ###
Gets the extra that this app was invoked with. For example:

    window.plugins.webintent.getExtra(WebIntent.EXTRA_TEXT, 
        function(url) {
            // url is the value of EXTRA_TEXT
        }, function() {
            // There was no extra supplied.
        }
    );
	
## Licence ##

The MIT License

Copyright (c) 2010 Boris Smus

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