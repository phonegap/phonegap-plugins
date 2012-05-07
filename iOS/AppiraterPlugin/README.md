# AppiraterPlugin #
by James Stuckey Weber

This plugin allows you to call Appirater userDidSignificantEvent and appEnteredForeground from javascript (sigEvent and foreground correspondingly). The  Appirater appLaunched function should be called in the AppDelegate class as specified by the Appirater install log.

## Adding the Plugin to your Project ##

1. Install [Appirater](https://github.com/arashpayan/appirater).
    1a). Add  call the Appirater class before return 'YES' of didFinishLaunchingWithOptions function in AppDelegate.m
        [Appirater appLaunched:YES];
    1b) If the latest version of Appirater is not working with Phonegap (checked at May 7, 2012). Use the previous version of Appirater from Class folder of the plugin.
2. Add the AppiraterPlugin folder to the Plugins folder in XCode, using "Create groups for any added folders".
3. Add the 'Appirater.js' file to your www folder and link to it from your html files.
4. Add new entry key 'AppiraterPlugin' with value 'AppiraterPlugin' to 'Plugins' in 'PhoneGap.plist/Cordova.plist'

## JAVASCRIPT INTERFACE ##


## LICENSE ##

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.