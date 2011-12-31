/*
 Copyright 2009-2011 Urban Airship Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AppDelegate.h"
#ifdef PHONEGAP_FRAMEWORK
	#import <PhoneGap/PhoneGapViewController.h>
#else
	#import "PhoneGapViewController.h"
#endif

#import "PushNotification.h"

@implementation AppDelegate

@synthesize invokeString;
@synthesize launchNotification;

- (id) init
{	
	/** If you need to do any extra app-specific initialization, you can do it here
	 *  -jm
	 **/
    return [super init];
}

/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // ******** NOTE: modified the following block from the default app delegate as it assumes
    // your app will never receive push notifications

    //	NSArray *keyArray = [launchOptions allKeys];
    //	if ([launchOptions objectForKey:[keyArray objectAtIndex:0]]!=nil) 
    //	...
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    self.invokeString = [url absoluteString];
    
    // cache notification, if any, until webview finished loading, then process it if needed
    // assume will not receive another message before webview loaded
    self.launchNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    application.applicationIconBadgeNumber = 0;
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if UAPhoneGap.plist specifies a protocol to handle
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    // must call super so all plugins will get the notification, and their handlers will be called 
	// super also calls into javascript global function 'handleOpenURL'
    return [super application:application handleOpenURL:url];
}

-(id) getCommandInstance:(NSString*)className
{
	/** You can catch your own commands here, if you wanted to extend the gap: protocol, or add your
	 *  own app specific protocol to it. -jm
	 **/
	return [super getCommandInstance:className];
}

/**
 Called when the webview finishes loading.  This stops the activity view and closes the imageview
 */
- (void)webViewDidFinishLoad:(UIWebView *)theWebView 
{
	// only valid if UAPhoneGap.plist specifies a protocol to handle
	if (self.invokeString) {
		// this is passed before the deviceready event is fired, so you can access it in js when you receive deviceready
		NSString* jsString = [NSString stringWithFormat:@"var invokeString = \"%@\";", self.invokeString];
		[theWebView stringByEvaluatingJavaScriptFromString:jsString];
	}
    
    //Now that the web view has loaded, pass on the notfication
    if (launchNotification) {
        PushNotification *pushHandler = [self getCommandInstance:@"PushNotification"];
        
        //NOTE: this drops payloads outside of the "aps" key
        pushHandler.notificationMessage = [launchNotification objectForKey:@"aps"];
        
        //clear the launchNotification
        self.launchNotification = nil;
    }
    
	return [ super webViewDidFinishLoad:theWebView ];
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView 
{
	return [ super webViewDidStartLoad:theWebView ];
}

/**
 * Fail Loading With Error
 * Error - If the webpage failed to load display an error with the reason.
 */
- (void)webView:(UIWebView *)theWebView didFailLoadWithError:(NSError *)error 
{
	return [ super webView:theWebView didFailLoadWithError:error ];
}

/**
 * Start Loading Request
 * This is where most of the magic happens... We take the request(s) and process the response.
 * From here we can re direct links and other protocalls to different internal methods.
 */
- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return [ super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType ];
}


- (BOOL)execute:(InvokedUrlCommand*)command
{
	return [super execute:command];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PushNotification *pushHandler = [self getCommandInstance:@"PushNotification"];
    [pushHandler didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    PushNotification *pushHandler = [self getCommandInstance:@"PushNotification"];
    [pushHandler didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveNotification");
    
    // Get application state for iOS4.x+ devices, otherwise assume active
    UIApplicationState appState = UIApplicationStateActive;
    if ([application respondsToSelector:@selector(applicationState)]) {
        appState = application.applicationState;
    }
    
    // NOTE this is a 4.x only block -- TODO: add 3.x compatibility
    if (appState == UIApplicationStateActive) {
        PushNotification *pushHandler = [self getCommandInstance:@"PushNotification"];
        pushHandler.notificationMessage = [userInfo objectForKey:@"aps"];
        [pushHandler notificationReceived];
    } else {
        //save it for later
        self.launchNotification = userInfo;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSLog(@"active");
    
    //zero badge
    application.applicationIconBadgeNumber = 0;

    if (![self.webView isLoading] && self.launchNotification) {
        PushNotification *pushHandler = [self getCommandInstance:@"PushNotification"];
        pushHandler.notificationMessage = [self.launchNotification objectForKey:@"aps"];
        
        self.launchNotification = nil;
        
        [pushHandler performSelectorOnMainThread:@selector(notificationReceived) withObject:pushHandler waitUntilDone:NO];
    }
    
    [super applicationDidBecomeActive:application];
}

- (void)dealloc
{
  launchNotification = nil;
	[super dealloc];
}

@end
