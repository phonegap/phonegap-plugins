//
//  ShareKitPlugin.m
//
//  Created by Erick Camacho on 28/07/11.
//  MIT Licensed
//

#import "ShareKitPlugin.h"

#import "SHKTwitter.h"
#import "SHKFacebook.h"
#import "SHKMail.h"


@interface ShareKitPlugin (PrivateMethods)

- (void)IsLoggedToService:(BOOL)isLogged callback:(NSString *) callback;

@end

@implementation ShareKitPlugin


- (void) share:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options { 
    
    NSString *message = [arguments objectAtIndex:1];
    SHKItem *item;

    if ([arguments count] == 3) {
        NSURL *itemUrl = [NSURL URLWithString:[arguments objectAtIndex:2]];  
        item = [SHKItem URL:itemUrl title:message contentType:SHKURLContentTypeWebpage];
    } else {
        item = [SHKItem text:message];
    }
        
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [SHK setRootViewController:self.viewController];

	[actionSheet showInView:self.viewController.view];
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
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsInt: isLogged ];
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
    [SHK setRootViewController:self.viewController];
        [SHKFacebook loginToService];
    }
}

- (void)shareToFacebook:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
        
    [SHK setRootViewController:self.viewController];
    
    SHKItem *item;
    
    NSString *message = [arguments objectAtIndex:1];
    if ([arguments objectAtIndex:2]==NULL) {
        NSURL *itemUrl = [NSURL URLWithString:[arguments objectAtIndex:2]];  
        item = [SHKItem URL:itemUrl title:message contentType:SHKURLContentTypeWebpage];
    } else {
        item = [SHKItem text:message];
    }
    
    [SHKFacebook shareItem:item];
    
}

- (void)shareToTwitter:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    [SHK setRootViewController:self.viewController];
    
    SHKItem *item;
    
    NSString *message = [arguments objectAtIndex:1];
    if ([arguments objectAtIndex:2]==NULL) {
        NSURL *itemUrl = [NSURL URLWithString:[arguments objectAtIndex:2]];  
        item = [SHKItem URL:itemUrl title:message contentType:SHKURLContentTypeWebpage];
    } else {
        item = [SHKItem text:message];
    }
    
    [SHKTwitter shareItem:item];

}

- (void)shareToMail:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    [SHK setRootViewController:self.viewController];
    
    SHKItem *item;
    
    NSString *subject = [arguments objectAtIndex:1];
    NSString *body = [arguments objectAtIndex:2];

    item = [SHKItem text:body];
    item.title = subject;

    [SHKMail shareItem:item];
    
}

@end
