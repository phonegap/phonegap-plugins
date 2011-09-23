//
//  HockeyApp.h
//
//  Created by Owen Brotherwood on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>

@interface HockeyApp : PGPlugin {
    
}

- (void) init:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void) checkForUpdate:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void) showUpdateView:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void) isUpdateAvailable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) initiateAppDownload:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) crashTest:(NSArray*)arguments withDict:(NSDictionary*)options;

@end
