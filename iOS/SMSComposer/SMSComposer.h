//
//  SMSComposer.h
//
//  Created by Grant Sanders on 12/25/2010.


#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface SMSComposer : CDVPlugin <MFMessageComposeViewControllerDelegate> {
}

- (void)showSMSComposer:(NSArray*)arguments withDict:(NSDictionary*)options;
@end
