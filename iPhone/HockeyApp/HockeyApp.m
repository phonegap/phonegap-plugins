//
//  HockeyApp.m
//
//  Created by Owen Brotherwood on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HockeyApp.h"
#import "BWHockeyManager.h"
#import "BWQuincyManager.h"


@implementation HockeyApp

- (void) init:(NSArray*)arguments withDict:(NSDictionary*)options
{   
    // collect appIdentifier from JavaScript or just hardcode it here.
    NSString* appIdentifier = [options valueForKey:@"appIdentifier"];
    [[BWHockeyManager sharedHockeyManager] setAppIdentifier:appIdentifier];
    [[BWQuincyManager sharedQuincyManager] setAppIdentifier:appIdentifier];    
}

// produces a requester with HockeyApp
- (void) checkForUpdate:(NSArray*)arguments withDict:(NSDictionary*)options
{
    [[BWHockeyManager sharedHockeyManager] checkForUpdate];
}

- (void) showUpdateView:(NSArray*)arguments withDict:(NSDictionary*)options
{
    [[BWHockeyManager sharedHockeyManager] showUpdateView];
}

- (void) isUpdateAvailable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString *jsString;
    NSString *callback = [arguments objectAtIndex:0]; // no error checking ...
    
    if ([[BWHockeyManager sharedHockeyManager] isUpdateAvailable]){
        jsString = [NSString stringWithFormat:@"%@(\"1\");",callback];
    }else{
        jsString = [NSString stringWithFormat:@"%@(\"\");",callback];
    }
    [self writeJavascript:jsString]; // magic ...
}

- (void) initiateAppDownload:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString *jsString;
    NSString *callback = [arguments objectAtIndex:0]; // no error checking ...
    
    if ([[BWHockeyManager sharedHockeyManager] initiateAppDownload]){
        jsString = [NSString stringWithFormat:@"%@(\"1\");",callback];
    }else{
        jsString = [NSString stringWithFormat:@"%@(\"\");",callback];
    }
    [self writeJavascript:jsString]; // magic ...
}

- (void) crashTest:(NSArray*)arguments withDict:(NSDictionary*)options
{
    CFRelease(NULL); // this will crash :)	
}


@end
	
