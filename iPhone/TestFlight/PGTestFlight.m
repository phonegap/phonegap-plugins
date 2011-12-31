//
//  PGTestFlight.m
//
//  Created by Shazron Abdullah on 11-09-13.
//  Copyright 2011 Nitobi Software Inc. All rights reserved.
//

#import "PGTestFlight.h"
#import "TestFlight.h"

#ifdef PHONEGAP_FRAMEWORK
    #import <PhoneGap/PluginResult.h>
#else
    #import "PluginResult.h"
#endif

@implementation PGTestFlight

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) addCustomEnvironmentInformation:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments pop];
    PluginResult* result = nil;
    
    NSString* key = [options objectForKey:@"key"];
    NSString* information = [options objectForKey:@"information"];
    
    if (key && information) {
        [TestFlight addCustomEnvironmentInformation:information forKey:key];
        result = [PluginResult resultWithStatus:PGCommandStatus_OK];
        [super writeJavascript:[result toSuccessCallbackString:callbackId]];
    } else {
        result = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:@"information or key property is missing."];
        [super writeJavascript:[result toErrorCallbackString:callbackId]];
    }
}

- (void) takeOff:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments pop];
    PluginResult* result = nil;
    
    NSString* teamToken = [options objectForKey:@"teamToken"];
    if (teamToken) {
        [TestFlight takeOff:teamToken];
        result = [PluginResult resultWithStatus:PGCommandStatus_OK];
        [super writeJavascript:[result toSuccessCallbackString:callbackId]];
    } else {
        result = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:@"teamToken property is missing."];
        [super writeJavascript:[result toErrorCallbackString:callbackId]];
    }
}

- (void)setOptions:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments pop];
    PluginResult* result = nil;
    
    if ([options count] > 0) {
        [TestFlight setOptions:options];
        result = [PluginResult resultWithStatus:PGCommandStatus_OK];
        [super writeJavascript:[result toSuccessCallbackString:callbackId]];
    } else {
        result = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:@"options dictionary is empty."];
        [super writeJavascript:[result toErrorCallbackString:callbackId]];
    }
}

- (void) passCheckpoint:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments pop];
    PluginResult* result = nil;
    
    NSString* checkpointName = [options objectForKey:@"checkpointName"];
    if (checkpointName) {
        [TestFlight passCheckpoint:checkpointName];
        result = [PluginResult resultWithStatus:PGCommandStatus_OK];
        [super writeJavascript:[result toSuccessCallbackString:callbackId]];
    } else {
        result = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:@"checkpointName property is missing."];
        [super writeJavascript:[result toErrorCallbackString:callbackId]];
    }
}

- (void) openFeedbackView:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments pop];
    
    [TestFlight openFeedbackView];
    
    PluginResult* result = [PluginResult resultWithStatus:PGCommandStatus_OK];
    [super writeJavascript:[result toSuccessCallbackString:callbackId]];
}

@end
