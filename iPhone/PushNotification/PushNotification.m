/*
 Copyright 2009-2011 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "PushNotification.h"

@implementation PushNotification

@synthesize notificationMessage;
@synthesize registerSuccessCallback;
@synthesize registerErrorCallback;

@synthesize callbackId;
@synthesize notificationCallbackId;

- (void)dealloc {
    [notificationMessage release];
    [registerSuccessCallback release];
    [registerErrorCallback release];

    self.notificationCallbackId = nil;

    [super dealloc];
}

- (void)registerAPN:(NSMutableArray *)arguments
           withDict:(NSMutableDictionary *)options {

    NSUInteger argc = [arguments count];
    if (argc > 0 && [[arguments objectAtIndex:0] length] > 0) {
        //self.registerSuccessCallback = [arguments objectAtIndex:0];
        self.callbackId = [arguments objectAtIndex:0];
    }

    if (argc > 1 && [[arguments objectAtIndex:1] length] > 0) {
        self.registerErrorCallback = [arguments objectAtIndex:1];
    }

    UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeNone;
    if ([options objectForKey:@"badge"]) {
        notificationTypes |= UIRemoteNotificationTypeBadge;
    }
    if ([options objectForKey:@"sound"]) {
        notificationTypes |= UIRemoteNotificationTypeSound;
    }
    if ([options objectForKey:@"alert"]) {
        notificationTypes |= UIRemoteNotificationTypeAlert;
    }

    if (notificationTypes == UIRemoteNotificationTypeNone)
        NSLog(@"PushNotification.registerAPN: Push notification type is set to none");

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];

}

- (void)isEnabled:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    NSString *jsStatement = [NSString stringWithFormat:@"navigator.pushNotification.isEnabled = %d;", type != UIRemoteNotificationTypeNone];
    NSLog(@"JSStatement %@",jsStatement);
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString: @" " withString: @""];
    [results setValue:token forKey:@"deviceToken"];
    
    #if !TARGET_IPHONE_SIMULATOR
        // Get Bundle Info for Remote Registration (handy if you have more than one app)
        [results setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] forKey:@"appName"];
        [results setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"appVersion"];
        
        // Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
        NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];

        // Set the defaults to disabled unless we find otherwise...
        NSString *pushBadge = @"disabled";
        NSString *pushAlert = @"disabled";
        NSString *pushSound = @"disabled";

        // Check what Registered Types are turned on. This is a bit tricky since if two are enabled, and one is off, it will return a number 2... not telling you which
        // one is actually disabled. So we are literally checking to see if rnTypes matches what is turned on, instead of by number. The "tricky" part is that the
        // single notification types will only match if they are the ONLY one enabled.  Likewise, when we are checking for a pair of notifications, it will only be
        // true if those two notifications are on.  This is why the code is written this way
        if(rntypes == UIRemoteNotificationTypeBadge){
          pushBadge = @"enabled";
        }
        else if(rntypes == UIRemoteNotificationTypeAlert){
          pushAlert = @"enabled";
        }
        else if(rntypes == UIRemoteNotificationTypeSound){
          pushSound = @"enabled";
        }
        else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)){
          pushBadge = @"enabled";
          pushAlert = @"enabled";
        }
        else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)){
          pushBadge = @"enabled";
          pushSound = @"enabled";
        }
        else if(rntypes == ( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
          pushAlert = @"enabled";
          pushSound = @"enabled";
        }
        else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
          pushBadge = @"enabled";
          pushAlert = @"enabled";
          pushSound = @"enabled";
        }

        [results setValue:pushBadge forKey:@"pushBadge"];
        [results setValue:pushAlert forKey:@"pushAlert"];
        [results setValue:pushSound forKey:@"pushSound"];

        // Get the users Device Model, Display Name, Unique ID, Token & Version Number
        UIDevice *dev = [UIDevice currentDevice];
        [results setValue:dev.uniqueIdentifier forKey:@"deviceUuid"];
        [results setValue:dev.name forKey:@"deviceName"];
        [results setValue:dev.model forKey:@"deviceModel"];
        [results setValue:dev.systemVersion forKey:@"deviceSystemVersion"];

    #endif

    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsDictionary:results];
    [self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackId]];
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", error);

    if (registerErrorCallback) {
        NSString *jsStatement = [NSString stringWithFormat:@"%@({error:'%@'});",
                                 registerErrorCallback, error];
        [super writeJavascript:jsStatement];
    }
}

- (void)notificationReceived {
    NSLog(@"Notification received");
    NSLog(@"Msg: %@", [notificationMessage descriptionWithLocale:[NSLocale currentLocale] indent:4]);

    if (notificationMessage) {
        NSMutableString *jsonStr = [NSMutableString stringWithString:@"{"];
        if ([notificationMessage objectForKey:@"alert"]) {
            [jsonStr appendFormat:@"alert:'%@',", [[notificationMessage objectForKey:@"alert"]
                                                      stringByReplacingOccurrencesOfString:@"'"
                                                                                withString:@"\\'"]];
        }
        if ([notificationMessage objectForKey:@"badge"]) {
            [jsonStr appendFormat:@"badge:%d,", [[notificationMessage objectForKey:@"badge"] intValue]];
        }
        if ([notificationMessage objectForKey:@"sound"]) {
            [jsonStr appendFormat:@"sound:'%@',", [notificationMessage objectForKey:@"sound"]];
        }
        [jsonStr appendString:@"}"];

        NSString *jsStatement = [NSString stringWithFormat:@"window.plugins.pushNotification.notificationCallback(%@);", jsonStr];
        [self writeJavascript:jsStatement];
        NSLog(@"run JS: %@", jsStatement);

//        PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsDictionary:notificationMessage];
//        [self writeJavascript:[pluginResult toSuccessCallbackString:self.]];
//
        self.notificationMessage = nil;
    }
}

@end
