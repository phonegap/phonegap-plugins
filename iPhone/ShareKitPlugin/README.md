#ShareKit plugin for Phonegap 

By Erick Camacho

## Adding ShareKit to a PhoneGap Project


Download [ShareKit](http://www.getsharekit.com) and install it on your project following the instructions provided in [the site](http://getsharekit.com/install/).

Most of the services used by ShareKit need API keys, add them in the SHKConfig.h you can find more information about the topic inside that file.

Both ShareKit and Phonegap use a class called Reachability. Thus, if you compile the project at this point, you will get the following compiler error:

    Command /Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/llvm-gcc-4.2 failed with exit code 1

    ld: duplicate symbol _OBJC_IVAR_$_Reachability.reachabilityRef in /Users/Shared/PhoneGap/Frameworks/PhoneGap.framework/PhoneGap and /Users/erick/Library/Developer/Xcode/DerivedData/example-astibrvgfpejembjdszybqhnmdee/Build/Intermediates/example.build/Debug-iphonesimulator/example.build/Objects-normal/i386/Reachability.o for architecture i386

To fix this error you need to delete the files Reachabily.h and Reachability.m from the ShareKit Folder in Xcode. Then modify the dependency in the file SHK.m, from this:

`#import "Reachability.h"`

To this:

    #ifdef PHONEGAP_FRAMEWORK
    #import <PhoneGap/Reachability.h>
    #else
    #import "Reachability.h"
    #endif
 
Now you should be able to successfully compile your project.


## Adding the Plugin to the Project


1. Copy ShareKitPlugin.h, ShareKitPlugin.m, SHKSharer+Phonegap.h and SHKSharer+Phonegap.m to your project. 
2. Add both files to the Plugins Folder in Xcode.
3. Copy the ShareKitPlugin.js to your www folder.
4. Modify the PhoneGap.plist file of your application. Under the key "Plugins" add another one with key name
ShareKitPlugin and value ShareKitPlugin.


## Using the plugin


Add the js file to your html. 

The plugin registers itself in the variable window.plugins.shareKit. It exposes the following methods:

1. `share( message, url )` Displays the ShareKit Form to share the given message and URL on a social network.

2. `isLoggedToTwitter( callback )` Returns wheter the user is logged in to twitter or no. Invokes the callback with an int argument :

	window.plugins.shareKit.isLoggedToTwitter( function( isLogged ) {
		if( isLogged ) {
			//do something
		} else {
			//do something
		}
	});

3. `isLoggedToFacebook( callback )` Returns wheter the user is logged in to Facebook or no. Invokes the callback with an int argument.

4. `logoutFromTwitter( )` Logouts the user from Twitter (By default, ShareKit keeps the user logged in. So if you want to log in with a different user
you must logout the current one first );

5. `logoutFromFacebook( )` Logouts the user from Facebook (By default, ShareKit keeps the user logged in. So if you want to log in with a different user
you must logout the current one first );

6. `facebookConnect( )` Shows the Facebook Login form, if the user is not logged in. Convenient method for login to Facebook without showing the post in the wall form.

7. `shareToFacebook(message, url )` Shows only the post in the wall form of Facebook if the user is logged in. 

8. `shareToTwitter(message, url)` Shares an item specifically with Twitter, will automatically shorten the URL

9. `shareToMail(subject, body)` Opens up the iOS mail dialog with pre-filled subject and body

## Running the example
The example is a project for XCode 4. It shows a basic use case for the plugin, in order to use it you must add the API keys of the services that you want to test in the SHKConfig.h file.

## Limitations

Currently the plugin can only share messages and URLs. In the future I will add functionality to share images as well.

Because in my current project I'm only sharing content to Twitter and Facebook, I've only added methods to logout from this two social networks. You can easily add methods to logout from other networks following these examples.


## License 


The MIT License

Copyright (c) 2011 Erick Camacho

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


