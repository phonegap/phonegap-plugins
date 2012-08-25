//
//  ProgressHud.m
//
// Created by Olivier Louvignes on 05/31/2012.
//
// Copyright 2012 Olivier Louvignes. All rights reserved.
// MIT Licensed

#ifdef CORDOVA_FRAMEWORK
	#import <CORDOVA/CDVPlugin.h>
#else
	#import "CDVPlugin.h"
#endif

@interface SecureDeviceIdentifier : CDVPlugin {

	NSString* callbackID;
	NSString* secureUDID;

}

@property (nonatomic, copy) NSString* callbackID;
@property (nonatomic, assign) NSString* secureUDID;

//Instance Method
- (void) get:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
