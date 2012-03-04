//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//  Copyright 2012, Randy McMillan
// Continued maintainance @RandyMcMillan 2010/2011/2012

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#endif
//#else
#ifdef CORDOVA_FRAMEWORK
#import <CORDOVA/CDVPlugin.h>
#endif
#import "ChildBrowserViewController.h"


#ifdef PHONEGAP_FRAMEWORK
    @interface ChildBrowserCommand : PGPlugin <ChildBrowserDelegate>  {
#endif
#ifdef CORDOVA_FRAMEWORK
    @interface ChildBrowserCommand : CDVPlugin <ChildBrowserDelegate>  {
#endif
	ChildBrowserViewController* childBrowser;
}

@property (nonatomic, retain) ChildBrowserViewController *childBrowser;


- (void) showWebPage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
-(void) onChildLocationChange:(NSString*)newLoc;

@end
