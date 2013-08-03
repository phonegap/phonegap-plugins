//
//  SMSComposer.h
//
//  Created by Grant Sanders on 12/25/2010.

//  CDVSMSComposer Template Created Jan 7 2013
//  Copyright 2013 @RandyMcMillan

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface CDVSMSComposer : CDVPlugin <MFMessageComposeViewControllerDelegate>{}

//- (void)showSMSComposer:(NSArray *)arguments withDict:(NSDictionary *)options;
- (void)showSMSComposer:(CDVInvokedUrlCommand*)command;

@end
