//
//  calendarPlugin.m
//
//  Created by Felix Montanez on 01-17-2012
//  MIT Licensed
//
//  Copyright 2012 AMFMMultiMedia. All Rights Reserved.
//

#import "calendarPlugin.h"
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>

@implementation calendarPlugin
@synthesize eventStore;
@synthesize defaultCalendar;


-(void)createEvent:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options 
{
    
    store = [[EKEventStore alloc] init];
    myEvent = [EKEvent eventWithEventStore: store];
    
    NSString* title      = [arguments objectAtIndex:1];
    NSString* location   = [arguments objectAtIndex:2];
    NSString* message    = [arguments objectAtIndex:3];
    NSString *startDate  = [arguments objectAtIndex:4];
    NSString *endDate    = [arguments objectAtIndex:5];
    
    
    //creating the dateformatter object
    NSDateFormatter *sDate = [[[NSDateFormatter alloc] init] autorelease];
    [sDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myStartDate = [sDate dateFromString:startDate];
    
    
    NSDateFormatter *eDate = [[[NSDateFormatter alloc] init] autorelease];
    [eDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myEndDate = [eDate dateFromString:endDate];
    
    
    myEvent.title = title;
    myEvent.location = location;
    myEvent.notes = message;
    myEvent.startDate = myStartDate;
    myEvent.endDate = myEndDate;
    myEvent.calendar = store.defaultCalendarForNewEvents;
    
    
    EKAlarm *reminder = [EKAlarm alarmWithRelativeOffset:-2*60*60];
    
    [myEvent addAlarm:reminder];
    
    NSError *error;
    BOOL saved = [store saveEvent:myEvent span:EKSpanThisEvent
                            error:&error];
    if (saved) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:@"Saved to Calendar" delegate:self
                                              cancelButtonTitle:@"Thank you!"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [store release];
        
    }
}

//delegate method for EKEventEditViewDelegate
-(void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    [self dismissModalViewControllerAnimated:YES];
    [self release];
}
@end
