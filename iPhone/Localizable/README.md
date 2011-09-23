# Localizable plugin for Phonegap #
By Tue Topholm / Sugee

Uses the Localizable.strings on Iphone, so you can have localization of your phonegap app.

#Creating Localizable.strings ##

In a sample app, we are going to support two languages English and Italian. Create a new Phonegap project in Xcode. After you have created your project, open the project location in Finder and create two directories called `en.lproj` and `a.lproj`. These two directories become the language project for your application. All the English language resources will stored in the folder `en.lproj` and the Danish language resources will be stored in `da.lproj` folder. The resource files that contain the localizable string are called "strings" file and their default name is "Localizable.strings". So, we will create two new strings file in Xcode, select Resources and click on File -> New File -> Resource (under Mac OS X) -> Strings file and click on Next, name your file `Localizable.strings` and save it in en.lproj directory. Repeat the same process by saving it in da.lproj directory. Now you can see them in Xcode under Localizable.strings.

Here is how it could look like:

In the `en` file, you could write
"HelloKey" = "Hello";

In the `da` file, you could write
"HelloKey" = "Hallo";


## Adding the Plugin to your project ##
Copy the .h and .m file to the Plugins directory in your project. Copy the .js file to your www directory and reference it from your html file(s).
Remember to add it to the plugins in PhoneGap.plist 


## Using the plugin ##
The plugin creates the object `window.plugins.localizable` with one method `get(name, success)`. `name` is the name of the key you want.

`success` is a callback function. Success is passed the settings value as a string.
A full get example could be:

    window.plugins.localizable.get('username', function(result) {
            alert("We got a setting: " + result);
        });


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
