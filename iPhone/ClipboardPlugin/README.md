# PhoneGap ClipboardPlugin #
by Michel Weimerskirch

## Adding the Plugin to your project ##

Using this plugin requires [PhoneGap for iPhone](http://github.com/phonegap/phonegap-iphone).

1. Add the ClipboardPlugin.h and ClipboardPlugin.m files to your "Plugins" folder in your PhoneGap project
2. Add the clipboardPlugin.js files to your "www" folder on disk, and add a reference to the .js file as <link> tags in your html file(s)
3. Add new entry with key `ClipboardPlugin` and value `ClipboardPlugin` to `Plugins` in `PhoneGap.plist`

## Examples

    window.plugins.clipboardPlugin.setText("omg\n this rules")
    window.plugins.clipboardPlugin.getText(function(text) {alert(text)})

This plugin supports copying and pasting only text and no other data types right now, as it uses the Uniform Type Identifier public.text, but it could be extended to work with any UTI, e.g. by passing the type as optional parameter.

## RELEASE NOTES ##

### 20111126 ###
* Fix bug with multiline clipboard data

### 20101223 ###
* Added support for getting clipboard text.

### 20100812 ###
* Initial release
* Currently only supports setting clipboard text. Retrieving clipboard text will be added later.

## LICENSE ##

The MIT License

Copyright (c) 2010 Michel Weimerskirch

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

