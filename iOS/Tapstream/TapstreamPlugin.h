//
//  TapstreamPlugin.h
//  
//  Created by Stephan Bönnemann on 7/1/12.
//  Copyright (c) 2012 Stephan Bönnemann, All rights reserved.
//

#ifdef CORDOVA_FRAMEWORK
#import <CORDOVA/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif

@interface TapstreamPlugin : CDVPlugin {
}
- (void) fireEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
@end
