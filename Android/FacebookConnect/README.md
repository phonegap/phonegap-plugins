# Cordova FacebookConnect Plugin #
by [Olivier Louvignes](http://olouv.com)

---
### [This plugin is hosted by the author](https://github.com/mgcrea/cordova-facebook-connect/tree/master)
---

## DESCRIPTION ##

* This plugin provides a simple way to use Facebook Graph API in Cordova.

* This plugin is built for Cordova >= v2.1.0 with ARC. Both iOS & Android are supported with the same javascript interface.

* For iOS, this plugin relies on the [Facebook iOS SDK](https://github.com/facebook/facebook-ios-sdk) that is bundled in the `FacebookSDK` folder (licensed under the Apache License, Version 2.0).

* For Android, this plugin relies on the [Facebook Android SDK](https://github.com/facebook/facebook-android-sdk) that is packaged as a .jar in the `libs` folder (licensed under the Apache License, Version 2.0).

* Regarding the existing implementation : [phonegap-plugin-facebook-connect](https://github.com/davejohnson/phonegap-plugin-facebook-connect) built by Dave Johnson, this version does not require the Facebook JS sdk (redundant to native sdk). It is also quite easier to use (unified login & initial /me request) and it does support multiple graph requests (strong callback handling).

## LICENSE ##

    The MIT License

    Copyright (c) 2012 Olivier Louvignes

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

## CREDITS ##

Contributors :

* [Olivier Louvignes](http://olouv.com), author.

