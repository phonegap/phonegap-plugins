//
//  WaitingDialog.h
//
//
//  Created by Guido Sabatini in 2012
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>


@interface WaitingDialog : CDVPlugin {
    
}

// UNCOMMENT THIS METHOD if you want to use the plugin with versions of cordova < 2.2.0
//- (void) show:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

// COMMENT THIS METHOD if you want to use the plugin with versions of cordova < 2.2.0
- (void) show:(CDVInvokedUrlCommand*)command;
- (void) hide:(CDVInvokedUrlCommand*)command;

@end