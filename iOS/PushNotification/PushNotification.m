//
//  PushNotification.m
//
// Created by Olivier Louvignes on 06/05/12.
// Inspired by Urban Airship Inc orphaned PushNotification phonegap plugin.
//
// Copyright 2012 Olivier Louvignes. All rights reserved.
// MIT Licensed

#import "PushNotification.h"
#ifdef CORDOVA_FRAMEWORK
	#import <Cordova/JSONKit.h>
#else
	#import "JSONKit.h"
#endif

@implementation PushNotification

@synthesize callbackID;
@synthesize pendingNotifications = _pendingNotifications;

- (NSMutableArray*)pendingNotifications {
	if(_pendingNotifications == nil) {
		_pendingNotifications = [[NSMutableArray alloc] init];
	}
	return _pendingNotifications;
}

- (void)registerDevice:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
	//NSLog(@"registerDevice:%@\n withDict:%@", arguments, options);

	// The first argument in the arguments parameter is the callbackID.
	// We use this to send data back to the successCallback or failureCallback
	// through PluginResult.
	self.callbackID = [arguments pop];

	UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeNone;
	if ([options objectForKey:@"badge"]) {
		notificationTypes |= UIRemoteNotificationTypeBadge;
	}
	if ([options objectForKey:@"sound"]) {
		notificationTypes |= UIRemoteNotificationTypeSound;
	}
	if ([options objectForKey:@"alert"]) {
		notificationTypes |= UIRemoteNotificationTypeAlert;
	}

	if (notificationTypes == UIRemoteNotificationTypeNone)
		NSLog(@"PushNotification.registerDevice: Push notification type is set to none");

	//[[UIApplication sharedApplication] unregisterForRemoteNotifications];
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];

}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	//NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken:%@", deviceToken);

	NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
						stringByReplacingOccurrencesOfString:@">" withString:@""]
					   stringByReplacingOccurrencesOfString: @" " withString: @""];

    NSMutableDictionary *results = [PushNotification getRemoteNotificationStatus];
    [results setValue:token forKey:@"deviceToken"];

	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:results];
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
	//NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", error);

	NSMutableDictionary *results = [NSMutableDictionary dictionary];
	[results setValue:[NSString stringWithFormat:@"%@", error] forKey:@"error"];

	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:results];
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
}

- (void)didReceiveRemoteNotification:(NSDictionary*)userInfo {
	//NSLog(@"didReceiveRemoteNotification:%@", userInfo);

	NSString *jsStatement = [NSString stringWithFormat:@"window.plugins.pushNotification.notificationCallback(%@);", [userInfo JSONString]];
	[self writeJavascript:jsStatement];
}

- (void)getPendingNotifications:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
	//NSLog(@"getPendingNotifications:%@\n withDict:%@", arguments, options);

	// The first argument in the arguments parameter is the callbackID.
	// We use this to send data back to the successCallback or failureCallback
	// through PluginResult.
	self.callbackID = [arguments pop];

	NSMutableDictionary *results = [NSMutableDictionary dictionary];
	[results setValue:self.pendingNotifications forKey:@"notifications"];

	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:results];
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];

	[self.pendingNotifications removeAllObjects];
}

+ (NSMutableDictionary*)getRemoteNotificationStatus {
    
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    
    NSUInteger type = 0;
    // Set the defaults to disabled unless we find otherwise...
    NSString *pushBadge = @"0";
    NSString *pushAlert = @"0";
    NSString *pushSound = @"0";
    
#if !TARGET_IPHONE_SIMULATOR
    
    // Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
    type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    // Check what Registered Types are turned on. This is a bit tricky since if two are enabled, and one is off, it will return a number 2... not telling you which
    // one is actually disabled. So we are literally checking to see if rnTypes matches what is turned on, instead of by number. The "tricky" part is that the
    // single notification types will only match if they are the ONLY one enabled.  Likewise, when we are checking for a pair of notifications, it will only be
    // true if those two notifications are on.  This is why the code is written this way
    if(type == UIRemoteNotificationTypeBadge){
        pushBadge = @"1";
    }
    else if(type == UIRemoteNotificationTypeAlert) {
        pushAlert = @"1";
    }
    else if(type == UIRemoteNotificationTypeSound) {
        pushSound = @"1";
    }
    else if(type == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)) {
        pushBadge = @"1";
        pushAlert = @"1";
    }
    else if(type == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)) {
        pushBadge = @"1";
        pushSound = @"1";
    }
    else if(type == ( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)) {
        pushAlert = @"1";
        pushSound = @"1";
    }
    else if(type == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)) {
        pushBadge = @"1";
        pushAlert = @"1";
        pushSound = @"1";
    }
    
#endif
    
    // Affect results
    [results setValue:[NSString stringWithFormat:@"%d", type] forKey:@"type"];
	[results setValue:[NSString stringWithFormat:@"%d", type != UIRemoteNotificationTypeNone] forKey:@"enabled"];
    [results setValue:pushBadge forKey:@"pushBadge"];
    [results setValue:pushAlert forKey:@"pushAlert"];
    [results setValue:pushSound forKey:@"pushSound"];
    
    return results;
    
}

- (void)getRemoteNotificationStatus:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
	//NSLog(@"getRemoteNotificationStatus:%@\n withDict:%@", arguments, options);

	// The first argument in the arguments parameter is the callbackID.
	// We use this to send data back to the successCallback or failureCallback
	// through PluginResult.
	self.callbackID = [arguments pop];

	NSMutableDictionary *results = [PushNotification getRemoteNotificationStatus];
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:results];
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
}

- (void)setApplicationIconBadgeNumber:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
	//NSLog(@"setApplicationIconBadgeNumber:%@\n withDict:%@", arguments, options);
    
	// The first argument in the arguments parameter is the callbackID.
	// We use this to send data back to the successCallback or failureCallback
	// through PluginResult.
	self.callbackID = [arguments pop];
    
    int badge = [[options objectForKey:@"badge"] intValue] ?: 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
	[results setValue:[NSNumber numberWithInt:badge] forKey:@"badge"];
    [results setValue:[NSNumber numberWithInt:1] forKey:@"success"];
    
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:results];
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
}

- (void) dealloc {
	[_pendingNotifications dealloc];
	[super dealloc];
}

@end
