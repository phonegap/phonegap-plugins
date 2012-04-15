//
//  AppDelegate.m
//  localNotifications
//
//  Created by Andrew Dahlman on 1/26/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "AppDelegate.h"
#ifdef PHONEGAP_FRAMEWORK
	#import <PhoneGap/PhoneGapViewController.h>
#else
	#import "PhoneGapViewController.h"
#endif

@implementation AppDelegate

@synthesize invokeString;

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
	
	/*NSArray *keyArray = [launchOptions allKeys];
	if ([launchOptions objectForKey:[keyArray objectAtIndex:0]]!=nil) 
	{
		NSURL *url = [launchOptions objectForKey:[keyArray objectAtIndex:0]];
		self.invokeString = [url absoluteString];
		NSLog(@"localNotifications launchOptions = %@",url);
	}*/
	
	return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if localNotifications.plist specifies a protocol to handle
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
	// only valid if localNotifications.plist specifies a protocol to handle
	if(self.invokeString)
	{
		// this is passed before the deviceready event is fired, so you can access it in js when you receive deviceready
		NSString* jsString = [NSString stringWithFormat:@"var invokeString = \"%@\";", self.invokeString];
		[theWebView stringByEvaluatingJavaScriptFromString:jsString];
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


- (BOOL) execute:(InvokedUrlCommand*)command
{
	return [ super execute:command];
}

- (void)dealloc
{
	[ super dealloc ];
}

// ADD OUR NOTIFICATION CODE
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification 
{
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateInactive) {
        // WAS IN BG
        NSLog(@"I was in the background");
        
        NSString *notCB = [notification.userInfo objectForKey:@"background"];
        NSString * jsCallBack = [NSString 
                                 stringWithFormat:@"%@", notCB]; 
        [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];         
        
        /* Use this line if running on Cordova
        [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
        */
        
        application.applicationIconBadgeNumber = 0;
        
    }
    else {
        // WAS RUNNING
        NSLog(@"I was currently active");
        
        NSString *notCB = [notification.userInfo objectForKey:@"forground"];
        NSString * jsCallBack = [NSString 
                                 stringWithFormat:@"%@", notCB]; 
        
        /* Use this line if running on Cordova
        [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
        */
        
        [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
        
        application.applicationIconBadgeNumber = 0;
    }                 
}
@end
