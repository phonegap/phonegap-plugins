//
//  Badge.m
//
//  Created by Simon Madine on 29/04/2010.
//  Copyright 2010 The Angry Robot Zombie Factory.
//  MIT licensed
//
//  Converted to Cordova by Joseph Stuhr.
//

#import "Badge.h"


@implementation Badge
- (void)setBadge:(NSMutableArray*)badgeNumber withDict:(NSMutableDictionary*)options {
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[ badgeNumber objectAtIndex:0] intValue]];
}
@end