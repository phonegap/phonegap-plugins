# Testflight #

_Originally by Created by `Shazron Abdullah, Nitobi Software Inc.`_
_Updated for Cordova 1.6.0 by `Will Froelich`_

### Plugin for [Testflight SDK 1.0](https://testflightapp.com/sdk/) ###

---

## How to install: ##

1. Download and install [Testflight SDK 1.0](https://testflightapp.com/sdk/download)
2. Add `CDVTestFlight.h` and `CDVTestFlight.m` to your XCode project's plugins folder
3. Add `TestFlight.js` to your `www` folder and include it
4. In `Cordova.plist`, under plugins, add a row with key: `TestFlightSDK`  and value:  `CDVTestFlight`
5. In `Cordova.plist`, under ExternalHosts, add a row with the value: `*.testflightapp.com`

---

## How to use ##

Testflight becomes available to Javascript as `window.plugins.testFlight`

You can make an reference to it by adding in your global scope, or you can call it directly.

The Testflight SDK needs an initializer before you can send it data, which is done with the takeOff method.

Example:

    var testFlight = window.plugins.testFlight;

    testFlight.takeOff(
        function(){
            console.log("Success!");
        },

        function() {
            console.error("Failed!");
        },
        
        "YOUR_TESTFLIGHT_TEAM_TOKEN"
    );

See TestFlight.js for all the available methods

## LICENSE ##

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.