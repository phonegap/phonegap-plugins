//
//  calendarPlugin.h
//  Author: Felix Montanez
//  Date: 01-17-2011
//  Notes:
//
// 06/05/2013 - FIX for cordova 2.6.0 By Luongo Vincenzo

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>


@interface calendarPlugin : CDVPlugin <EKEventEditViewDelegate> {
    
	EKEventStore *eventStore;
    EKCalendar *defaultCalendar;
    //NSArray *events;
    
    //future plan to have global type variables
    
    
}

@property (nonatomic,retain) EKEventStore *eventStore;
@property (nonatomic,retain) EKCalendar *defaultCalendar;

//-(NSArray *)fetchEvents;

// Calendar Instance methods
- (void)createEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)getCalendarList:(NSMutableArray *) arguments withDict:(NSMutableDictionary*)options;

//- (void)modifyEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

//- (void)findEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

//- (void)deleteEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
