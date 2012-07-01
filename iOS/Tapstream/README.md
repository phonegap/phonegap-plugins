# Tapstream API via JavaScript/Cordova
Author: Stephan Bönnemann | [@boennemann](http://twitter.com/boennemann)

If you aren't familiar with [Tapstream](http://tapstream.com/) visit their Website and read through the Developer section.

# Installation

1. Drop the `Tapstream.framework` into Xcode. Make sure you check `Create group for any given folders` & `Copy items into destination group's folder (if needed)`. 
2. Drop the `TapstreamPlugin.h` & `TapstreamPlugin.m` files into your `Plugins` folder. (Check same boxes as before)
3. Go to your `AppDelegate.m` and add the following at the beginning of the file:
    `#import "Tapstream/Tapstream.h"`
4. Go to the `application:didFinishLaunchingWithOptions` method in the same file and add the following (replace the arguments of course):
    `[[Tapstream shared] setAccountName:@"TAPSTREAM_ACCOUNT_NAME" developerSecret:@"DEV_SECRET_KEY"];`
5. Add `TapstreamPlugin` & `TapstreamPlugin` in the plugins section of your `Cordova.plist`.
6. Embed the `TapstreamPlugin.js` file inside of your App.

# Usage

You may now use the `fireEvent` method like so:

    plugins.TapstreamPlugin.fireEvent('conversion');

If you want to fire a oneTimeOnly Event do it like so:

    plugins.TapstreamPlugin.fireEvent('conversion',true);

# License

<<<<<<< HEAD
Original Repo: https://github.com/boennemann/tapstream-plugin

=======
>>>>>>> 4829ab1c48051b6334e8675a02a22a6a0f71f7e8
Please be aware that the `Tapstream.framework` is intellectual property of 2012 Paperlabs Inc. All rights reserved. Created by Benjamin Fox. 
I included it inside of this repo just for convenience.
You may always download it at https://tapstream.com/sdk/ios/ .
Documentation may be found here: https://tapstream.com/developer/ios_sdk_documentation/

I'm not related to Tapstream/Paperlabs in any kind of way.
(Except being a happy customer)

The MIT License

Copyright (c) 2012 Stephan Bönnemann

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
