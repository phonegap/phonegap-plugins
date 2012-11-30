//
//  EmailComposer.h
//
//  Version 1.1
//
//  Created by Guido Sabatini in 2012.
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