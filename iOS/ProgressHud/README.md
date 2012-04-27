# Cordova ProgressHud Plugin #
by `Olivier Louvignes`

## DESCRIPTION ##

* This plugin provides a simple way to use a native loading component from IOS. It does comply with the latest (future-2.x) cordova standards.

* It relies on `[MBProgressHUD](https://github.com/jdg/MBProgressHUD)` to work (MIT license, included in ./libs).

## SETUP ##

Using this plugin requires [Cordova iOS](https://github.com/apache/incubator-cordova-ios).

1. Make sure your Xcode project has been [updated for Cordova](https://github.com/apache/incubator-cordova-ios/blob/master/guides/Cordova%20Upgrade%20Guide.md)
2. Drag and drop the `ProgressHud` folder from Finder to your Plugins folder in XCode, using "Create groups for any added folders"
3. Add the .js files to your `www` folder on disk, and add reference(s) to the .js files using <script> tags in your html file(s)

    <script type="text/javascript" src="/js/plugins/ProgressHud.js"></script>

4. Add new entry with key `ProgressHud` and value `ProgressHud` to `Plugins` in `Cordova.plist/Cordova.plist`

## JAVASCRIPT INTERFACE ##

    // After device ready, create a local alias
    var progressHud = window.plugins.progressHud;

    // Complex example with loading
    progressHud.show({mode: "determinate", progress:0, labelText: 'Loading...', detailsLabelText: 'Connecting...'}, function() {
        console.warn('show(), arguments=' + Array.prototype.slice.call(arguments).join(', '));
    });

    var interval = setInterval(function() {

        i++;

        if(i > n) {
            progressHud.hide();
            return clearInterval(interval);
        }

        var progress = Math.round((i / n) * 100) / 100,
            detailsLabelText = 'Processing ' + i + '/' + n;
        if (i == n) {
            detailsLabelText = 'Finalizing...'
        }

        progressHud.set({progress: progress, detailsLabelText: detailsLabelText});

    }, 1000);

* Check [source](http://github.com/mgcrea/phonegap-plugins/tree/master/iOS/ProgressHud/ProgressHud.js) for additional configuration.

## BUGS AND CONTRIBUTIONS ##

Patches welcome! Send a pull request. Since this is not a part of Cordova Core (which requires a CLA), this should be easier.

Post issues on [Github](https://github.com/phonegap/phonegap-plugins/issues)

The latest code (my fork) will always be [here](http://github.com/mgcrea/phonegap-plugins/tree/master/iOS/ProgressHud)

## LICENSE ##

Copyright 2012 Olivier Louvignes. All rights reserved.

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## CREDITS ##

Inspired by :

* [MBProgressHUD project](https://github.com/jdg/MBProgressHUD)
