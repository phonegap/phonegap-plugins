# Share plugin for Android/Phonegap
By Kevin Schaul - @foxyNinja7

## Using the plugin

### PhoneGap 1.0 and later

* Add java code to your project's build source

* Register the plugin in the plugins.xml file

```xml
<plugin name="Share" value="com.schaul.plugins.share.Share"/>
```

* Call the plugin, specifying subject, text, success function, and failure function

```javascript
window.plugins.share.show({
	subject: 'I like turtles',
	text: 'http://www.mndaily.com'},
	function() {}, // Success function
	function() {alert('Share failed')} // Failure function
);
```

## Release notes

### 5/29/2012
* Updated for Cordova 1.6+ by @devgeeks

### 8/22/2011
* Updated for PhoneGap 1.0

### 7/11/2011
* Initial release

## License

The MIT License

Copyright (c) 2011 Kevin Schaul

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