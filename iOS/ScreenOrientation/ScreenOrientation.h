//
//  ScreenOrientation.h
//
//  Created by Simon Cruise on 30/08/2012.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#import <Cordova/CDVPlugin.h>

@interface ScreenOrientation : CDVPlugin

-	(void) set:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
