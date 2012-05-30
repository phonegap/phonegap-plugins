
//
//  AppDelegate.m
//  Socializer
//
//  Created by Kerri Shotts on 5/22/12.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SHK.h"
#import "SHKConfiguration.h"
#import "MySHKConfiguration.h"
#import "SHKFacebook.h"

#ifdef CORDOVA_FRAMEWORK
    #import <Cordova/CDVPlugin.h>
    #import <Cordova/CDVURLProtocol.h>
#else
    #import "CDVPlugin.h"
    #import "CDVURLProtocol.h"
#endif


@implementation AppDelegate

@synthesize window, viewController;

- (id) init
{	
	/** If you need to do any extra app-specific initialization, you can do it here
	 *  -jm
	 **/
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage]; 
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
    [CDVURLProtocol registerURLProtocol];
    
    return [super init];
}

#pragma UIApplicationDelegate implementation

/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{    
    NSURL* url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    NSString* invokeString = nil;
    
    if (url && [url isKindOfClass:[NSURL class]]) {
        invokeString = [url absoluteString];
		NSLog(@"Socializer launchOptions = %@", url);
    }    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
    self.window.autoresizesSubviews = YES;
    
    CGRect viewBounds = [[UIScreen mainScreen] applicationFrame];
    
    self.viewController = [[[MainViewController alloc] init] autorelease];
    self.viewController.useSplashScreen = YES;
    self.viewController.wwwFolderName = @"www";
    self.viewController.startPage = @"index.html";
    self.viewController.invokeString = invokeString;
    self.viewController.view.frame = viewBounds;
    
    // check whether the current orientation is supported: if it is, keep it, rather than forcing a rotation
    BOOL forceStartupRotation = YES;
    UIDeviceOrientation curDevOrientation = [[UIDevice currentDevice] orientation];
    
    if (UIDeviceOrientationUnknown == curDevOrientation) {
        // UIDevice isn't firing orientation notifications yet… go look at the status bar
        curDevOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    }
    
    if (UIDeviceOrientationIsValidInterfaceOrientation(curDevOrientation)) {
        for (NSNumber *orient in self.viewController.supportedOrientations) {
            if ([orient intValue] == curDevOrientation) {
                forceStartupRotation = NO;
                break;
            }
        }
    } 
    
    if (forceStartupRotation) {
        NSLog(@"supportedOrientations: %@", self.viewController.supportedOrientations);
        // The first item in the supportedOrientations array is the start orientation (guaranteed to be at least Portrait)
        UIInterfaceOrientation newOrient = [[self.viewController.supportedOrientations objectAtIndex:0] intValue];
        NSLog(@"AppDelegate forcing status bar to: %d from: %d", newOrient, curDevOrientation);
        [[UIApplication sharedApplication] setStatusBarOrientation:newOrient];
    }
    
    [self.window addSubview:self.viewController.view];
    [self.window makeKeyAndVisible];

    // support sharekit
    DefaultSHKConfigurator *configurator = [[MySHKConfiguration alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    [SHK flushOfflineQueue];
    
    return YES;
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if Socializer-Info.plist specifies a protocol to handle
- (BOOL) application:(UIApplication*)application handleOpenURL:(NSURL*)url 
{
    if (!url) { 
        return NO; 
    }
    
	// calls into javascript global function 'handleOpenURL'
    NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", url];
    [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // all plugins will get the notification, and their handlers will be called 
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];
    
    return [self handleOpenURL:url];  
//    return YES;    
}

- (BOOL)handleOpenURL:(NSURL*)url
{
  NSString* scheme = [url scheme];
  NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
  if ([scheme hasPrefix:prefix])
  return [SHKFacebook handleOpenURL:url];
  return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 
{
  return [self handleOpenURL:url];
}



- (void) dealloc
{
	[super dealloc];
}

@end
