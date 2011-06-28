//
//  Badge.h
//
//  Created by Simon Madine on 29/04/2010.
//  Copyright 2010 The Angry Robot Zombie Factory.
//  MIT licensed
//

#import <Foundation/Foundation.h>


#ifdef PHONEGAP_FRAMEWORK
    #import <PhoneGap/PhoneGapCommand.h>
#else
    #import "PhoneGapCommand.h"
#endif
@interface Badge : PhoneGapCommand {
}
- (void)setBadge:(NSMutableArray*)badgeNumber withDict:(NSMutableDictionary*)options;
@end
