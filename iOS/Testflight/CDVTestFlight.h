//
//  PGTestFlight.h
//
//  Created by Shazron Abdullah on 11-09-13.
//  Copyright 2011 Nitobi Software Inc. All rights reserved.
//
//  Updated by Will Froelich Apr-10-2012
//
#ifdef CORDOVA_FRAMEWORK
    #import <Cordova/CDVPlugin.h>
#else
	#import "CDVPlugin.h"
#endif 

@interface CDVTestFlight : CDVPlugin

- (void)addCustomEnvironmentInformation:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)takeOff:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)setOptions:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)passCheckpoint:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)openFeedbackView:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;;

@end
