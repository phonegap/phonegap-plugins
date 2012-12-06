//
//  PhoneGap ! ChildBrowserCommand
// 
//
//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneGapCommand.h"
#import "ChildBrowserViewController.h"


 
@interface ChildBrowserCommand : PhoneGapCommand<ChildBrowserDelegate>  {

	ChildBrowserViewController* childBrowser;
}

@property (nonatomic, retain) ChildBrowserViewController *childBrowser;


- (void) showWebPage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) jsExec:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) onChildLocationChange:(NSString*)newLoc;

@end
