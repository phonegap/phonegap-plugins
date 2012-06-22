//
//  ProgressHud.m
//
// Created by Olivier Louvignes on 05/31/2012.
//
// Copyright 2012 Olivier Louvignes. All rights reserved.
// MIT Licensed

#import "SecureDeviceIdentifier.h"
#import "SecureUDID.h"

@implementation SecureDeviceIdentifier

@synthesize callbackID = _callbackID;
@synthesize secureUDID = _secureUDID;

-(void)get:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
	//NSLog(@"get:%@\n withDict:%@", arguments, options);

	// The first argument in the arguments parameter is the callbackID.
	// We use this to send data back to the successCallback or failureCallback
	// through PluginResult.
	self.callbackID = [arguments pop];

	// Compiling options with defaults
	NSString *domain = [options objectForKey:@"domain"] ?: @"";
	NSString *key = [options objectForKey:@"key"] ?: @"";
	self.secureUDID = [SecureUDID UDIDForDomain:domain usingKey:key];

	// Create Plugin Result
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:self.secureUDID];
	//Call  the Success Javascript function
	[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];

}

@end
