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
    NSString* successCallback;
    NSString* failCallback;
    NSString* printHTML;
    
    //Options
    NSInteger dialogLeftPos;
    NSInteger dialogTopPos;
}

@property (nonatomic, copy) NSString* successCallback;
@property (nonatomic, copy) NSString* failCallback;
@property (nonatomic, copy) NSString* printHTML;

//Print Settings
@property NSInteger dialogLeftPos;
@property NSInteger dialogTopPos;

//Print HTML
- (void) print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

//Find out whether printing is supported on this platform.
- (void) isPrintingAvailable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
