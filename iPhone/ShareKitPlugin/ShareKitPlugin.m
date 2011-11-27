//
//  ShareKitPlugin.m
//
//  Created by Erick Camacho on 28/07/11.
//  MIT Licensed
//

#import "ShareKitPlugin.h"

#import "SHKTwitter.h"
#import "SHKFacebook.h"


@interface ShareKitPlugin (PrivateMethods)

- (void)IsLoggedToService:(BOOL)isLogged callback:(NSString *) callback;

@end

@implementation ShareKitPlugin


- (void) share:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options { 
    
    NSString *message = [arguments objectAtIndex:1];
    NSURL *itemUrl = [NSURL URLWithString:[arguments objectAtIndex:2]];
	SHKItem *item = [SHKItem URL:itemUrl title:message];
    
    
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [[SHK currentHelper] setRootViewController:self.appViewController];

	[actionSheet showInView:self.appViewController.view];
}

- (void)isLoggedToTwitter:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSString *callback = [arguments objectAtIndex:0];   
    [self IsLoggedToService:[SHKTwitter isServiceAuthorized] callback:callback];
}

- (void)isLoggedToFacebook:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    
    NSString *callback = [arguments objectAtIndex:0];   
    [self IsLoggedToService:[SHKFacebook isServiceAuthorized] callback:callback];
}

- (void)IsLoggedToService:(BOOL)isLogged callback:(NSString *) callback {
    
    PluginResult* pluginResult = [PluginResult resultWithStatus: PGCommandStatus_OK messageAsInt: isLogged ];
    [self writeJavascript:[pluginResult toSuccessCallbackString:callback]];    
}


- (void)logoutFromTwitter:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {    
    [SHKTwitter logout];
}

- (void)logoutFromFacebook:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
   
    [SHKFacebook logout];
}

- (void)facebookConnect:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    if (![SHKFacebook isServiceAuthorized]) {
        [[SHK currentHelper] setRootViewController:self.appViewController];
        [SHKFacebook loginToService];
    }
}

- (void)shareToFacebook:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
        
    [[SHK currentHelper] setRootViewController:self.appViewController];
    
    SHKItem *item;
    
    NSString *message = [arguments objectAtIndex:1];
    if ([arguments objectAtIndex:2]) {
        NSURL *itemUrl = [NSURL URLWithString:[arguments objectAtIndex:2]];  
        item = [SHKItem URL:itemUrl title:message];
    } else {
        item = [SHKItem text:message];
    }
    
    [SHKFacebook shareItem:item];
    
}

- (void)shareToTwitter:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    [[SHK currentHelper] setRootViewController:self.appViewController];
    
    SHKItem *item;
    
    NSString *message = [arguments objectAtIndex:1];
    if ([arguments objectAtIndex:2]) {
        NSURL *itemUrl = [NSURL URLWithString:[arguments objectAtIndex:2]];  
        item = [SHKItem URL:itemUrl title:message];
    } else {
        item = [SHKItem text:message];
    }
    
    [SHKTwitter shareItem:item];

}

- (void)shareToMail:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    [[SHK currentHelper] setRootViewController:self.appViewController];
    
    SHKItem *item;
    
    NSString *message = [arguments objectAtIndex:1];
    if ([arguments objectAtIndex:2]) {
        NSURL *itemUrl = [NSURL URLWithString:[arguments objectAtIndex:2]];  
        item = [SHKItem URL:itemUrl title:message];
    } else {
        item = [SHKItem text:message];
    }
    
    [SHKMail shareItem:item];
    
}

@end
