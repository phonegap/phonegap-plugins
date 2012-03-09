//
//  Badge.h
//
//  Created by Simon Madine on 29/04/2010.
//  Copyright 2010 The Angry Robot Zombie Factory.
//  MIT licensed
//
//  Converted to Cordova by Joseph Stuhr.
//

#import <Foundation/Foundation.h>

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif

@interface Badge : CDVPlugin {
}

- (void)setBadge:(NSMutableArray*)badgeNumber withDict:(NSMutableDictionary*)options;

@end