//
//  ExtractZipFilePlugin.m
//
//  Created by Shaun Rowe on 10/05/2012.
//  Copyright (c) 2012 Pobl Creative Cyf. All rights reserved.
//

#import "ExtractZipFilePlugin.h"
#import "SSZipArchive.h"

@implementation ExtractZipFilePlugin

@synthesize callbackID;

- (void)extract:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{    
    callbackID = [arguments pop];
    
    NSString *file = [arguments objectAtIndex:0];
    NSString *destination = [arguments objectAtIndex:1];

    CDVPluginResult *result;
    if([SSZipArchive unzipFileAtPath:file toDestination:destination delegate:nil]) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[destination stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self writeJavascript:[result toSuccessCallbackString:callbackID]];
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[@"Could not extract archive" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self writeJavascript:[result toErrorCallbackString:callbackID]];        
    }
}

@end