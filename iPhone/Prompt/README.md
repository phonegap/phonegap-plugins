# Prompt plugin for Phonegap #
By Paul Panserrieu, Zenexity

## ChangeLog ##

* 11/15/2011 Fixing the textField background for ios 5.

## Credits ##
This plugin is highly inspirated by a blog post from Jeff Lamarche 
( http://iphonedevelopment.blogspot.com/2009/02/alert-view-with-prompt.html )
and others PhoneGap plugins.

## Adding the Plugin to your project ##
Copy the .h and .mm file to the Plugins directory in your project. 
Copy the .js file to your www directory and reference it from your html file(s)

## Usage ##

    window.plugins.Prompt.show(
        "My Prompt Title",
        function (userText) { ...}, // ok callback
        function () { }, // cancel callback 
        "Ok", // ok button title (optional)
        "Cancel" // cancel button title (optional)
    );

## Licence ##

The MIT License

Copyright (c) 2011 Paul Panserrieu, Zenexity

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


