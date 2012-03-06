//
//  GoogleAnalyticsPlugin.h
//  Google Analytics plugin for PhoneGap
//
//  Created by Jesse MacFadyen on 11-04-21.
//  Updated to 1.x by Olivier Louvignes on 11-11-24.
//  MIT Licensed
//

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif
#import "GANTracker.h"

@interface GoogleAnalyticsPlugin : PGPlugin <GANTrackerDelegate> {

}

- (void) startTrackerWithAccountID:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) trackEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) setCustomVariable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) trackPageview:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
