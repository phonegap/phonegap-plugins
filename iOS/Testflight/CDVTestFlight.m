//
//  PGTestFlight.m
//
//  Created by Shazron Abdullah on 11-09-13.
//  Copyright 2011 Nitobi Software Inc. All rights reserved.
//
//  Updated by Will Froelich Apr-10-2012
//

#import "TestFlight.h"
#import "CDVTestFlight.h"

#ifdef CORDOVA_FRAMEWORK
    #import <Cordova/CDVPluginResult.h>
#else
    #import "PluginResult.h"
#endif

@implementation CDVTestFlight

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
    CDVPluginResult* result = nil;
    
    NSString* key = [options objectForKey:@"key"];
    NSString* information = [options objectForKey:@"information"];
    
    if (key && information) {
        [TestFlight addCustomEnvironmentInformation:information forKey:key];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [super writeJavascript:[result toSuccessCallbackString:callbackId]]; 
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"information or key property is missing."];
        [super writeJavascript:[result toErrorCallbackString:callbackId]];
    }
}

- (void) takeOff:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments pop];
    CDVPluginResult* result = nil;
    
    NSString* teamToken = [options objectForKey:@"teamToken"];
    if (teamToken) {
        [TestFlight takeOff:teamToken];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [super writeJavascript:[result toSuccessCallbackString:callbackId]];
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"teamToken property is missing."];
        [super writeJavascript:[result toErrorCallbackString:callbackId]];
    }
}

- (void)setOptions:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments pop];
    CDVPluginResult* result = nil;
    
    if ([options count] > 0) {
        [TestFlight setOptions:options];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [super writeJavascript:[result toSuccessCallbackString:callbackId]];
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"options dictionary is empty."];
        [super writeJavascript:[result toErrorCallbackString:callbackId]];
    }
}

- (void) passCheckpoint:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments pop];
    CDVPluginResult* result = nil;
    
    NSString* checkpointName = [options objectForKey:@"checkpointName"];
    if (checkpointName) {
        [TestFlight passCheckpoint:checkpointName];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [super writeJavascript:[result toSuccessCallbackString:callbackId]];
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"checkpointName property is missing."];
        [super writeJavascript:[result toErrorCallbackString:callbackId]];
    }
}

- (void) openFeedbackView:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments pop];
    
    [TestFlight openFeedbackView];
    
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [super writeJavascript:[result toSuccessCallbackString:callbackId]];
}

@end
