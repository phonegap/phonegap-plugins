//
//  BonjourPlugin.h
//  BonjourPlugin -  PhoneGap/Cordova Plug-In
//
//  Created by Justin D'Arcangelo on 12/11/12.
//  Copyright (c) 2012 Entropi Software. All rights reserved.
//

#import <Cordova/CDVPlugin.h>
#import <Foundation/NSNetServices.h>

@interface BonjourPlugin : CDVPlugin <NSNetServiceBrowserDelegate, NSNetServiceDelegate>

- (void)startServiceDiscovery:(CDVInvokedUrlCommand *)command;
- (void)stopServiceDiscovery:(CDVInvokedUrlCommand *)command;

@end
