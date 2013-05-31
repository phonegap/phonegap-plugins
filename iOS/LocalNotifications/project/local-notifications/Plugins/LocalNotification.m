//
//  LocalNotification.m
//	Phonegap LocalNotification Plugin
//	Copyright (c) Greg Allen 2011 & 2012 Drew Dahlman
//	MIT Licensed

#import "LocalNotification.h"


@implementation LocalNotification
- (void)addNotification:(CDVInvokedUrlCommand*)command; {
	
	CDVPluginResult* pluginResult = nil;
	
	@try {
		
		NSMutableDictionary *repeatDict = [[NSMutableDictionary alloc] init];
		[repeatDict setObject:[NSNumber numberWithInt:NSDayCalendarUnit] forKey:@"daily"];
		[repeatDict setObject:[NSNumber numberWithInt:NSWeekCalendarUnit] forKey:@"weekly"];
		[repeatDict setObject:[NSNumber numberWithInt:NSMonthCalendarUnit] forKey:@"monthly"];
		[repeatDict setObject:[NSNumber numberWithInt:NSYearCalendarUnit] forKey:@"yearly"];
		[repeatDict setObject:[NSNumber numberWithInt:0] forKey:@""];
	
		// notif settings
		double timestamp = [[command.arguments objectAtIndex:0] doubleValue];
		NSString *msg = [command.arguments objectAtIndex:1];
		bool hasAction = ([[command.arguments objectAtIndex:2] intValue] == 1)?YES:NO;
		NSString *action = [command.arguments objectAtIndex:3];
		NSString *repeat = [command.arguments objectAtIndex:4];
		NSInteger badge = [[command.arguments objectAtIndex:5] intValue];
		NSString *notificationId = [command.arguments objectAtIndex:6];		
		NSString *bg = [command.arguments objectAtIndex:7];
		NSString *fg = [command.arguments objectAtIndex:8];
		NSString *sound = ([[command.arguments objectAtIndex:9] isEqualToString:@"none"])?nil:[command.arguments objectAtIndex:9];
		
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
		
		UILocalNotification *notif = [[UILocalNotification alloc] init];
		notif.fireDate = date;
		notif.hasAction = hasAction;
		notif.timeZone = [NSTimeZone defaultTimeZone];
		notif.repeatInterval = [[repeatDict objectForKey: repeat] intValue];
		
		notif.alertBody = ([msg isEqualToString:@""])?nil:msg;
		notif.alertAction = action;

		notif.soundName = sound;
		notif.applicationIconBadgeNumber = badge;
		
		NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:notificationId,@"notificationId",bg,@"background",fg,@"foreground",nil];

		notif.userInfo = userDict;
		
		[[UIApplication sharedApplication] scheduleLocalNotification:notif];
		NSLog(@"Notification Set: %@ (ID: %@, Badge: %i, sound: %@,background: %@, foreground: %@)", date, notificationId, badge, sound,bg,fg);
		//[notif release];
		
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
			
	} @catch (NSException* exception) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)cancelNotification:(CDVInvokedUrlCommand*)command; {
	CDVPluginResult* pluginResult = nil;
	
	@try {
		NSString *notificationId = [command.arguments objectAtIndex:0];
		NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
		
		for (UILocalNotification *notification in notifications) {
			NSString *notId = [notification.userInfo objectForKey:@"notificationId"];
			if ([notificationId isEqualToString:notId]) {
				NSLog(@"Notification Canceled: %@", notificationId);
				[[UIApplication sharedApplication] cancelLocalNotification:notification];
			}
		}
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	} @catch (NSException* exception) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	
}

- (void)cancelAllNotifications:(CDVInvokedUrlCommand*)command; {
	CDVPluginResult* pluginResult = nil;
	
	@try {
		NSLog(@"All Notifications cancelled");
		[[UIApplication sharedApplication] cancelAllLocalNotifications];
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	} @catch (NSException* exception) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
