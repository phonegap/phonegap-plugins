//
//  MessageBox.h
//
// Created by Olivier Louvignes on 11/26/11.
// Updated on 04/08/2012 for Cordova
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

#import <Foundation/Foundation.h>
#ifdef CORDOVA_FRAMEWORK
#import <CORDOVA/CDVPlugin.h>
#else
#import "CORDOVA/CDVPlugin.h"
#endif

@interface MessageBox : CDVPlugin {
	NSString* callbackID;
}

@property (nonatomic, copy) NSString* callbackID;

// Instance Method
- (void) prompt:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
