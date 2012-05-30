//
//  MySHKConfiguration.m
//  Socializer
//
//  Created by Kerri Shotts on 5/29/12.
//

#import "MySHKConfiguration.h"

@implementation MySHKConfiguration
/* 
 App Description 
 ---------------
 These values are used by any service that shows 'shared from XYZ'
 */
- (NSString*)appName {
	return @"MyApp";
}

- (NSString*)appURL {
	return @"http://www.example.com";
}

// Facebook - https://developers.facebook.com/apps
// SHKFacebookAppID is the Application ID provided by Facebook
// SHKFacebookLocalAppID is used if you need to differentiate between several iOS apps running against a single Facebook app. Useful, if you have full and lite versions of the same app,
// and wish sharing from both will appear on facebook as sharing from one main app. You have to add different suffix to each version. Do not forget to fill both suffixes on facebook developer ("URL Scheme Suffix"). Leave it blank unless you are sure of what you are doing. 
// The CFBundleURLSchemes in your App-Info.plist should be "fb" + the concatenation of these two IDs.
// Example: 
//    SHKFacebookAppID = 555
//    SHKFacebookLocalAppID = lite
// 
//    Your CFBundleURLSchemes entry: fb555lite
- (NSString*)facebookAppId {
	return @"1234567890";
}

- (NSString*)facebookLocalAppId {
	return @"";
}

//Change if your app needs some special Facebook permissions only. In most cases you can leave it as it is.
- (NSArray*)facebookListOfPermissions {    
    return [NSArray arrayWithObjects:@"publish_stream", @"offline_access", nil];
}

// Read It Later - http://readitlaterlist.com/api/signup/ 
- (NSString*)readItLaterKey {
	return @"12342517293587192873491287351298374";
}

// Twitter - http://dev.twitter.com/apps/new
/*
 Important Twitter settings to get right:
 
 Differences between OAuth and xAuth
 --
 There are two types of authentication provided for Twitter, OAuth and xAuth.  OAuth is the default and will
 present a web view to log the user in.  xAuth presents a native entry form but requires Twitter to add xAuth to your app (you have to request it from them).
 If your app has been approved for xAuth, set SHKTwitterUseXAuth to 1.
 
 Callback URL (important to get right for OAuth users)
 --
 1. Open your application settings at http://dev.twitter.com/apps/
 2. 'Application Type' should be set to BROWSER (not client)
 3. 'Callback URL' should match whatever you enter in SHKTwitterCallbackUrl.  The callback url doesn't have to be an actual existing url.  The user will never get to it because ShareKit intercepts it before the user is redirected.  It just needs to match.
 */

/*
 If you want to force use of old-style, pre-IOS5 twitter framework, for example to ensure
 twitter accounts don't end up in the devices account store, set this to true.
 */
- (NSNumber*)forcePreIOS5TwitterAccess {
	return [NSNumber numberWithBool:true];
}

- (NSString*)twitterConsumerKey {
	return @"13412531253123425341";
}

- (NSString*)twitterSecret {
	return @"1234123516413634573456235423451234";
}
// You need to set this if using OAuth, see note above (xAuth users can skip it)
- (NSString*)twitterCallbackUrl {
	return @"http://www.example.com/callback";
}
// To use xAuth, set to 1
- (NSNumber*)twitterUseXAuth {
	return [NSNumber numberWithInt:0];
}
// Enter your app's twitter account if you'd like to ask the user to follow it when logging in. (Only for xAuth)
- (NSString*)twitterUsername {
	return @"";
}

/* Name of the plist file that defines the class names of the sharers to use. Usually should not be changed, but this allows you to subclass a sharer and have the subclass be used. Also helps, if you want to exclude some sharers - you can create your own plist, and add it to your project. This way you do not need to change original SHKSharers.plist, which is a part of subproject - this allows you upgrade easily as you did not change ShareKit itself */
- (NSString*)sharersPlistName {
	return @"MySHKSharers.plist";
}

@end
