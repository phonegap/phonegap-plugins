# PhoneGap DataProxy Plugin #
by Brian Antonelli

Allows you to request data from any URL within your project. This gets around pesky cross-domain security issues when JSONP is not an option.
Also, this will allow for multiple concurrent asynchronous requests as it tracks each request separately.

Example:
window.plugins.dataProxy.getData("http://www.phonegap.com", window.navigator.userAgent, 
function(r){
	console.log("Success: " + r);
},
function(e){
	console.log("Failure: " + e);
});


## Adding the Plugin to your project ##

Using this plugin requires [PhoneGap for iPhone] (http://github.com/phonegap/phonegap-iphone).

1. Add the DataProxy.h and DataProxy.m files to your "Plugins" folder in your PhoneGap project
2. Add the DataProxy.js files to your "www" folder on disk, and add a reference to the .js file as <link> tags in your html file(s)

## RELEASE NOTES ##

### 7-8-2011 ###
* Initial release

## LICENSE ##

The MIT License

Copyright (c) 2011 Brian Antonelli

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

