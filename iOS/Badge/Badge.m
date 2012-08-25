/*
 *  This code is adapted from the work of Michael Nachbaur 
 *  by Simon Madine of The Angry Robot Zombie Factory
 *   - Converted to Cordova 1.6.1 by Joseph Stuhr.
 *  2012-04-19
 *  MIT licensed
 *
 */

#import "Badge.h"

@implementation Badge

- (void)setBadge:(NSMutableArray*)badgeNumber withDict:(NSMutableDictionary*)options {
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[ badgeNumber objectAtIndex:0] intValue]];
}

@end