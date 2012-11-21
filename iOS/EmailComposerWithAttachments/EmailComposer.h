//
//  EmailComposer.h
//
//
//  Created by Jesse MacFadyen on 10-04-05.
//  Copyright 2010 Nitobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Cordova/CDVPlugin.h>


@interface EmailComposer : CDVPlugin <MFMailComposeViewControllerDelegate> {
    
    
}

// UNCOMMENT THIS METHOD if you want to use the plugin with versions of cordova < 2.2.0
//- (void) showEmailComposer:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

// COMMENT THIS METHOD if you want to use the plugin with versions of cordova < 2.2.0
- (void) showEmailComposer:(CDVInvokedUrlCommand*)command;

@end