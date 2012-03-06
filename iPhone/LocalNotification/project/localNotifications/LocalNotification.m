//
//  LocalNotification.m
//	Phonegap LocalNotification Plugin
//	Copyright (c) Greg Allen 2011
//	MIT Licensed

#import "LocalNotification.h"


@implementation LocalNotification
- (void)addNotification:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    
    // notif settings
	double timestamp = [[options objectForKey:@"date"] doubleValue];
	NSString *msg = [options objectForKey:@"message"];
	NSString *action = [options objectForKey:@"action"];
	NSString *notificationId = [options objectForKey:@"id"];
    NSString *sound = [options objectForKey:@"sound"];
    NSString *bg = [options objectForKey:@"background"];
    NSString *fg = [options objectForKey:@"foreground"];
	NSInteger badge = [[options objectForKey:@"badge"] intValue];
	bool hasAction = ([[options objectForKey:@"hasAction"] intValue] == 1)?YES:NO;
	
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
	
	UILocalNotification *notif = [[UILocalNotification alloc] init];
	notif.fireDate = date;
	notif.hasAction = hasAction;
	notif.timeZone = [NSTimeZone defaultTimeZone];
	
	notif.alertBody = ([msg isEqualToString:@""])?nil:msg;
	notif.alertAction = action;
    
    notif.soundName = sound;
    notif.applicationIconBadgeNumber = 0;
	
	NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:notificationId,@"notificationId",bg,@"background",fg,@"forground",nil];
    
    notif.userInfo = userDict;
	
	[[UIApplication sharedApplication] scheduleLocalNotification:notif];
	NSLog(@"Notification Set: %@ (ID: %@, Badge: %i, sound: %@,callback: %@)", date, notificationId, badge, sound,bg);
	//[notif release];
}

- (void)cancelNotification:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
	NSString *notificationId = [arguments objectAtIndex:0];
	NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
	for (UILocalNotification *notification in notifications) {
		NSString *notId = [notification.userInfo objectForKey:@"notificationId"];
		if ([notificationId isEqualToString:notId]) {
			NSLog(@"Notification Canceled: %@", notificationId);
			[[UIApplication sharedApplication] cancelLocalNotification:notification];
		}
	}
}

- (void)cancelAllNotifications:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
	NSLog(@"All Notifications cancelled");
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}



@end