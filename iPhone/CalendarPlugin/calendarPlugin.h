//
//  calendarPlugin.h
//
//  Created by Felix Montanez on 01-17-2012
//  MIT Licensed
//
//  Contributors:
//  Abdurrahman Qadan
//  Michael Brooks
//
//  
//


#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>

@interface calendarPlugin : PGPlugin <EKEventEditViewDelegate> {
    
	EKEventStore *eventStore;
    EKCalendar *defaultCalendar;
    
    EKEvent *myEvent;
    EKEventStore *store;
    
}

@property (nonatomic,retain) EKEventStore *eventStore;
@property (nonatomic,retain) EKCalendar *defaultCalendar;


// Calendar Instance methods
- (void)createEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end