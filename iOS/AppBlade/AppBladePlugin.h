//
//  AppBladePlugin.h
//  HelloWorld
//
//  Created by Michele Titolo on 5/14/12.
//  Copyright (c) 2012 AppBlade. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface AppBladePlugin : CDVPlugin

- (void)setupAppBlade:(NSMutableArray*)args withDict:(NSMutableDictionary*)options;

- (void)catchAndReportCrashes:(NSMutableArray*)args withDict:(NSMutableDictionary*)options;
- (void)allowFeedbackReporting:(NSMutableArray*)args withDict:(NSMutableDictionary*)options;
- (void)checkAuthentication:(NSMutableArray*)args withDict:(NSMutableDictionary*)options;

@end
