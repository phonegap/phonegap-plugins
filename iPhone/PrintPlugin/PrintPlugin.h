//
//  PrintPlugin.h
//  Print Plugin
//
//  Created by Ian Tipton (github.com/itip) on 02/07/2011.
//  Copyright 2011 Ian Tipton. All rights reserved.
//  MIT licensed
//

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif


@interface PrintPlugin : PGPlugin {
}


- (void) print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void) isPrintingAvailable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;


@end
