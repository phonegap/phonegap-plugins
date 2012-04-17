//
//  NetworkActivityIndicator.h
//  
//
//  Created by Tue Topholm on 16/03/11.
//  Copyright 2011 Sugee. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif

@interface NetworkActivityIndicator : CDVPlugin {}

- (void) setIndicator:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
