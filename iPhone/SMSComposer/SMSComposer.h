//
//  SMSComposer.h
//
//  Created by Grant Sanders on 12/25/2010.


#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface SMSComposer : PGPlugin <MFMessageComposeViewControllerDelegate> {
}

- (void)showSMSComposer:(NSArray*)arguments withDict:(NSDictionary*)options;
@end
