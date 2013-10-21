//
//  calendarPlugin.h
//  basePackage
//
//  Created by Liu Ley on 13-2-28.
//  Copyright (c) 2013年 SINA SAE. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Cordova/CDVPlugin.h>

#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>


@interface calendarPlugin : CDVPlugin <EKEventEditViewDelegate> {
    
	EKEventStore *eventStore;
    EKCalendar *defaultCalendar;
}
@property(nonatomic,retain) NSString *callbackId;
-(void)createEventDefault:(CDVInvokedUrlCommand *)command;
-(void)createEventQuiet:(CDVInvokedUrlCommand *)command;
-(void)getCalendars:(CDVInvokedUrlCommand *)command;
@end