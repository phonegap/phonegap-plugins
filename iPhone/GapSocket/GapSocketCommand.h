//
//  PGSocket
//
//
//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif
#import "AsyncSocket.h"


@interface GapSocketCommand : PGPlugin  {

	NSMutableArray *connectedSockets;
}

- (void) connect:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) close:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) send:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
