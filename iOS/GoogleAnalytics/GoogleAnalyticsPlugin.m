//
//  GoogleAnalyticsPlugin.m
//  Google Analytics plugin for PhoneGap
//
//  Created by Jesse MacFadyen on 11-04-21.
//  Updated to 1.x by Olivier Louvignes on 11-11-24.
//  Updated to 1.5 by Chris Kihneman on 12-04-09.
//  MIT Licensed
//

#import "GoogleAnalyticsPlugin.h"

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;

@implementation GoogleAnalyticsPlugin

- (void) startTrackerWithAccountID:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	NSString* accountId = [arguments objectAtIndex:0];

	[[GANTracker sharedTracker] startTrackerWithAccountID:accountId
										   dispatchPeriod:kGANDispatchPeriodSec
												 delegate:self];

}

- (void) trackEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{

	NSString* category = [options valueForKey:@"category"];
	NSString* action = [options valueForKey:@"action"];
	NSString* label = [options valueForKey:@"label"];
	int value = [[options valueForKey:@"value"] intValue];

	NSError *error;

	if (![[GANTracker sharedTracker] trackEvent:category
										 action:action
										  label:label
										  value:value
									  withError:&error]) {
		// Handle error here
		NSLog(@"GoogleAnalyticsPlugin.trackEvent Error::",[error localizedDescription]);
	}


	NSLog(@"GoogleAnalyticsPlugin.trackEvent::%@, %@, %@, %d",category,action,label,value);

}

- (void) setCustomVariable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    
	int index = [[options valueForKey:@"index"] intValue];
	NSString* name = [options valueForKey:@"name"];
	NSString* value = [options valueForKey:@"value"];
    
	NSError *error;
    
	if (![[GANTracker sharedTracker] setCustomVariableAtIndex:index 
                                                         name:name 
                                                        value:value 
                                                    withError:&error]) {
		// Handle error here
		NSLog(@"GoogleAnalyticsPlugin.setCustonVariable Error::%@",[error localizedDescription]);
	}
    
    
	NSLog(@"GoogleAnalyticsPlugin.setCustomVariable::%d, %@, %@", index, name, value);
    
}

- (void) trackPageview:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	NSString* pageUri = [arguments objectAtIndex:0];
	NSError *error;
	if (![[GANTracker sharedTracker] trackPageview:pageUri
										 withError:&error]) {
		// TODO: Handle error here
	}
}

- (void) hitDispatched:(NSString *)hitString
{
	NSString* callback = [NSString stringWithFormat:@"window.plugins.googleAnalyticsPlugin.hitDispatched(%d);",
						  hitString];
	[ self.webView stringByEvaluatingJavaScriptFromString:callback];

}

- (void) trackerDispatchDidComplete:(GANTracker *)tracker
                  eventsDispatched:(NSUInteger)hitsDispatched
              eventsFailedDispatch:(NSUInteger)hitsFailedDispatch
{
	NSString* callback = [NSString stringWithFormat:@"window.plugins.googleAnalyticsPlugin.trackerDispatchDidComplete(%d);",
							hitsDispatched];
	[ self.webView stringByEvaluatingJavaScriptFromString:callback];

}

- (void) dealloc
{
	[[GANTracker sharedTracker] stopTracker];
	[ super dealloc ];
}

@end
