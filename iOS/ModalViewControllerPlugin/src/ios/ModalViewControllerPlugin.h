//
//  ModalViewControllerPlugin.h
//  ModalViewControllerPlugin -  PhoneGap/Cordova Plug-In
//
//  Created by Justin D'Arcangelo on 12/11/12.
//  Copyright (c) 2012 Entropi Software. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface ModalViewControllerPlugin : CDVPlugin

- (void)presentModalViewController:(CDVInvokedUrlCommand *)command;
- (void)dismissModalViewController:(CDVInvokedUrlCommand *)command;

@end
