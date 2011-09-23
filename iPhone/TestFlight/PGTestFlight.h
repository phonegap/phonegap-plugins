//
//  PGTestFlight.h
//
//  Created by Shazron Abdullah on 11-09-13.
//  Copyright 2011 Nitobi Software Inc. All rights reserved.
//
#ifdef PHONEGAP_FRAMEWORK
    #import <PhoneGap/PGPlugin.h>
#else
	#import "PGPlugin.h"
#endif 

@interface PGTestFlight : PGPlugin

- (void)addCustomEnvironmentInformation:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)takeOff:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)setOptions:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)passCheckpoint:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)openFeedbackView:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;;

@end
