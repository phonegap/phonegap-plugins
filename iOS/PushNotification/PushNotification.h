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

	NSMutableDictionary* callbackIds;
	NSMutableArray* pendingNotifications;

}

@property (nonatomic, retain) NSMutableDictionary* callbackIds;
@property (nonatomic, retain) NSMutableArray* pendingNotifications;

- (void)registerDevice:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError*)error;
- (void)didReceiveRemoteNotification:(NSDictionary*)userInfo;
- (void)getPendingNotifications:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
+ (NSMutableDictionary*)getRemoteNotificationStatus;
- (void)getRemoteNotificationStatus:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)setApplicationIconBadgeNumber:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)cancelAllLocalNotifications:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)getDeviceUniqueIdentifier:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;

@end

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
