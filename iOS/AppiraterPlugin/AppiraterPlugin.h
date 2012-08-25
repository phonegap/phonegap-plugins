//
//  AppiraterPlugin.h
//  What To Brew
//
//  Created by James Stuckey Weber on 3/27/12.
//  Copyright (c) 2012 ChinStr.apps, All rights reserved.
//

#ifdef CORDOVA_FRAMEWORK
#import <CORDOVA/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif

@interface AppiraterPlugin : CDVPlugin {
	NSString* callbackID;  
}
@property (nonatomic, copy) NSString* callbackID;

//Significant Event Method

- (void) sigEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) foreground:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
@end
