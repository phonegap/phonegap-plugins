//
//  HockeyApp.h
//  jnsog
//
//  Created by Owen Brotherwood on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>

@interface HockeyApp : PGPlugin {
    
}

- (void) checkForUpdates:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void) crashTest:(NSArray*)arguments withDict:(NSDictionary*)options;

@end
