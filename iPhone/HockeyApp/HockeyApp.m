// 
// HockeyApp.m 
// 
// Created by Owen Brotherwood on 8/24/11. 
// Copyright 2011 __MyCompanyName__. All rights reserved. 
//

#import "HockeyApp.h" 
#import "BWHockeyManager.h"

@implementation HockeyApp

- (void) checkForUpdates:(NSArray*)arguments withDict:(NSDictionary*)options 
{ 
    [[BWHockeyManager sharedHockeyManager] checkForUpdate]; 
}

@end
