//
//  AppBladePlugin.m
//  HelloWorld
//
//  Created by Michele Titolo on 5/14/12.
//  Copyright (c) 2012 AppBlade. All rights reserved.
//

#import "AppBladePlugin.h"
#import "AppBlade.h"

enum {
    ABProjectID = 0,
    ABToken,
    ABSecretKey,
    ABTimestamp
};

@implementation AppBladePlugin

- (void)setupAppBlade:(NSMutableArray*)args withDict:(NSMutableDictionary*)options
{
    NSArray* keys = [args objectAtIndex:0];
    NSLog(@"Setup with stuff: %@", keys);
    NSString* project = [keys objectAtIndex:ABProjectID];
    NSString* token = [keys objectAtIndex:ABToken];
    NSString* secret = [keys objectAtIndex:ABSecretKey];
    NSString* timestamp = [keys objectAtIndex:ABTimestamp];
    
    AppBlade *blade = [AppBlade sharedManager];
    blade.appBladeProjectID = project;
    blade.appBladeProjectToken = token;
    blade.appBladeProjectSecret = secret;
    blade.appBladeProjectIssuedTimestamp = timestamp;
}

- (void)catchAndReportCrashes:(NSMutableArray *)args withDict:(NSMutableDictionary *)options
{
    NSLog(@"Catch and Report Crashes");
    [[AppBlade sharedManager] catchAndReportCrashes];
}

- (void)checkAuthentication:(NSMutableArray *)args withDict:(NSMutableDictionary *)options
{
    NSLog(@"Check approval");
    [[AppBlade sharedManager] checkApproval];
}

- (void)allowFeedbackReporting:(NSMutableArray *)args withDict:(NSMutableDictionary *)options
{
    NSLog(@"Allow Feedback");
    [[AppBlade sharedManager] allowFeedbackReporting];
}

@end
