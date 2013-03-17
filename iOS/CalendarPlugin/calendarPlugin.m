//
//  calendarPlugin.h
//  basePackage
//
//  Created by Liu Ley on 13-2-28.
//  Copyright (c) 2013年 SINA SAE. All rights reserved.
//

#import "calendarPlugin.h"


@implementation calendarPlugin
@synthesize callbackId;
//yyyy-MM-dd HH:mm
-(void)createEventQuiet:(CDVInvokedUrlCommand *)command
{
    eventStore=[[EKEventStore alloc] init];
    defaultCalendar =  [eventStore defaultCalendarForNewEvents];
    NSError *error=nil;
    
    self.callbackId=command.callbackId;
    NSArray *options=command.arguments;
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted) {
            // 同意
        } else {
            // 不同意
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"权限未被授权"];
            [super writeJavascript:[result toErrorCallbackString:self.callbackId]];
            return ;
        }
    }];
    
    //title fromdate todate location notes alermRule repeateRule 
    
    defaultCalendar = [eventStore defaultCalendarForNewEvents];
    EKEvent *myEvent=[EKEvent eventWithEventStore:eventStore];
    
    NSString* title      = [options objectAtIndex:0];
    NSString *startDate  = [options objectAtIndex:1];
    NSString *endDate    = [options objectAtIndex:2];
    NSString* location   = [options objectAtIndex:3];
    NSString* message    = [options objectAtIndex:4];
    NSString* url        = [options objectAtIndex:5];
    NSNumber* alarmOffset = [options objectAtIndex:6];
    NSNumber* recur =   [options objectAtIndex:7];
    
    
    NSDate *from=[self convertDateFromString:startDate];
    NSDate *to=[self convertDateFromString:endDate];
    
    myEvent.title=title;
    
    NSDate *now=[NSDate date];
    myEvent.startDate=from!=nil?from:now;
    now=[NSDate dateWithTimeIntervalSinceNow:60*5];
    myEvent.endDate=to!=nil?to:now;
    
    myEvent.location=location;
    myEvent.notes=message;
    myEvent.URL=[NSURL URLWithString:url];
    
    if (alarmOffset!=nil && [alarmOffset class]!=[NSNull class]) {
        [myEvent addAlarm:[EKAlarm alarmWithRelativeOffset:[alarmOffset integerValue]]];
    }
    if (recur!=nil && [recur class]!=[NSNull class]) {
        NSInteger recurValue=[recur integerValue];
        if (recurValue<1 || recurValue>5) {
            // no recur
        } else {
            EKRecurrenceRule *rule;
            rule=[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:[self ruleFrequency:recurValue] interval:1 end:nil];
            [myEvent addRecurrenceRule:rule];
        }
    }
    myEvent.calendar=defaultCalendar;
    
    BOOL success=[eventStore saveEvent:myEvent span:EKSpanThisEvent commit:YES error:&error];
    [eventStore release];
    
    if (success) {
        // success
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [super writeJavascript:[result toSuccessCallbackString:self.callbackId]];
        return ;
    } else {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
        [super writeJavascript:[result toErrorCallbackString:self.callbackId]];
        return ;
    }
}

-(void)createEventDefault:(CDVInvokedUrlCommand *)command
{
    self.callbackId=command.callbackId;
    eventStore=[[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted) {
            // 同意
        } else {
            // 不同意
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"权限未被授权"];
            [super writeJavascript:[result toErrorCallbackString:self.callbackId]];
            return ;
        }
    }];
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    addController.eventStore = eventStore;
    [eventStore release];
    
    [self.viewController presentModalViewController:addController animated:YES];
    
    addController.editViewDelegate = self;
    [addController release];
}

-(void)getEventList:(CDVInvokedUrlCommand *)command
{
    self.callbackId=command.callbackId;
    eventStore=[[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted) {
            // 同意
            return;
        } else {
            // 不同意
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"权限未被授权"];
            [super writeJavascript:[result toErrorCallbackString:self.callbackId]];
            return ;
        }
    }];
    NSArray *options=command.arguments;
    NSString *startDate = [options objectAtIndex:0];
    NSString *endDate   = [options objectAtIndex:1];
    NSDate *from=[self convertDateFromString:startDate];
    NSDate *to=[self convertDateFromString:endDate];
    NSPredicate *predicate=[eventStore predicateForEventsWithStartDate:from
                                                               endDate:to
                                                             calendars:[eventStore calendarsForEntityType:EKEntityTypeEvent]];
    NSArray *resultEventList=[eventStore eventsMatchingPredicate:predicate];
    NSMutableArray *eventList=[[NSMutableArray alloc] init];
    for (EKEvent *event in resultEventList) {
        // 将event转换成可用数据
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        [dic setValue:event.title forKey:@"title"];
        [dic setValue:event.location forKey:@"location"];
        [dic setValue:event.URL.absoluteString forKey:@"url"];
        [dic setValue:[self convertDateToString:event.startDate]  forKey:@"startDate"];
        [dic setValue:[self convertDateToString:event.endDate] forKey:@"endDate"];
        [dic setValue:[NSNumber numberWithBool:event.isDetached] forKey:@"isRepeat"];
        [dic setValue:[NSNumber numberWithBool:event.isAllDay] forKey:@"isAllDay"];
        [eventList addObject:dic];
        [dic release];
    }
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:eventList];
    [super writeJavascript:[result toSuccessCallbackString:self.callbackId]];
}

-(void)getCalendars:(CDVInvokedUrlCommand *)command
{
    self.callbackId=command.callbackId;
    eventStore=[[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted) {
            // 同意
            return;
        } else {
            // 不同意
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"权限未被授权"];
            [super writeJavascript:[result toErrorCallbackString:self.callbackId]];
            return ;
        }
    }];
    NSArray *calendars=[eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSMutableArray *calist=[[NSMutableArray alloc] init];
    for (EKCalendar *cal in calendars) {
        // 遍历
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        [dic setValue:cal.title forKey:@"title"];
        [dic setValue:cal.calendarIdentifier forKey:@"identifier"];
        [calist addObject:dic];
        [dic release];
    }
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:calist];
    [super writeJavascript:[result toSuccessCallbackString:self.callbackId]];
}

#pragma mark - private
-(EKRecurrenceFrequency)ruleFrequency:(NSInteger)index
{
    switch (index) {
        case 1:
            return EKRecurrenceFrequencyDaily;
            break;
        case 2:
            return EKRecurrenceFrequencyWeekly;
            break;
        case 3:
            return EKRecurrenceFrequencyMonthly;
            break;
        case 4:
            return EKRecurrenceFrequencyYearly;
            break;
        default:
            return EKRecurrenceFrequencyDaily;
            break;
    }
}

-(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

-(NSString *) convertDateToString:(NSDate *)uiDate
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *date=[formatter stringFromDate:uiDate];
    return date;
}


//delegate method for EKEventEditViewDelegate
-(void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    [self.viewController dismissModalViewControllerAnimated:YES];
    NSString *resultString=@"unknown";
    BOOL success=NO;
    switch (action) {
        case EKEventEditViewActionCanceled:
            resultString=@"canceled";
            break;
        case EKEventEditViewActionDeleted:
            resultString=@"delete";
            success=YES;
            break;
        case EKEventEditViewActionSaved:
            resultString=@"saved";
            success=YES;
            break;
        default:
            break;
    }
    if (success) {
        // success
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:resultString];
        [super writeJavascript:[result toSuccessCallbackString:self.callbackId]];
    } else {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:resultString];
        [super writeJavascript:[result toErrorCallbackString:self.callbackId]];
    }
}
@end
