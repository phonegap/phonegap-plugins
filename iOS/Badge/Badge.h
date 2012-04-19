/*
 *  This code is adapted from the work of Michael Nachbaur 
 *  by Simon Madine of The Angry Robot Zombie Factory
 *   - Converted to Cordova 1.6.1 by Joseph Stuhr.
 *  2012-04-19
 *  MIT licensed
 *
 */

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
