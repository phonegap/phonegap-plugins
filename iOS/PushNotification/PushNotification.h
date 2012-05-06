//
//  PushNotification.h
//
// Created by Olivier Louvignes on 06/05/12.
// Inspired by Urban Airship Inc orphaned PushNotification phonegap plugin.
//
// Copyright 2012 Olivier Louvignes. All rights reserved.
// MIT Licensed

#import <Foundation/Foundation.h>
#ifdef CORDOVA_FRAMEWORK
	#import <Cordova/CDVPlugin.h>
#else
	#import "CDVPlugin.h"
#endif

@interface PushNotification : CDVPlugin {

	NSString* callbackID;
	NSMutableArray* pendingNotifications;

}

@property (nonatomic, copy) NSString* callbackID;
@property (nonatomic, retain) NSMutableArray* pendingNotifications;

- (void)registerDevice:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError*)error;
- (void)didReceiveRemoteNotification:(NSDictionary*)userInfo;
- (void)getPendingNotifications:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
+ (NSMutableDictionary*)getRemoteNotificationStatus;
- (void)getRemoteNotificationStatus:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)setApplicationIconBadgeNumber:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;

@end
