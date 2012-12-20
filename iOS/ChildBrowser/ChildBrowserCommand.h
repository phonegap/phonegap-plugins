//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//  Copyright 2012, Randy McMillan

#import <Cordova/CDVPlugin.h>
#import "ChildBrowserViewController.h"

@interface ChildBrowserCommand : CDVPlugin <ChildBrowserDelegate>{}

@property (nonatomic, strong) ChildBrowserViewController* childBrowser;

- (void)showWebPage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)onChildLocationChange:(NSString*)newLoc;

@end
