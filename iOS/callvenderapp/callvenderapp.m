//
//  MyClass.m
//  hello
//
//  Created by kisshtink on 12-4-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "callvenderapp.h"

@implementation callvenderapp
@synthesize callbackID;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) run:(NSMutableString *)arguments withDict:(NSMutableDictionary *)options
{
    
    //The first argument in the arguments parameter is the callbackID.
    //We use this to send data back to the successCallback or failureCallback
    //through PluginResult.   
    self.callbackID = [arguments pop];
    
    //Get the string that javascript sent us 
    NSString *stringObtainedFromJavascript = [arguments objectAtIndex:0];                 
    NSString *stringObtainedFromJavascript1 = [arguments objectAtIndex:1];                 
    
    //Create the Message that we wish to send to the Javascript
    NSMutableString *stringToReturn = [NSMutableString stringWithString: @"StringReceived:"];
    //Append the received string to the string we plan to send out        
    [stringToReturn appendString: stringObtainedFromJavascript];
    //Create Plugin Result 
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:                        [stringToReturn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *appUrl = [NSURL URLWithString:stringObtainedFromJavascript ] ; 
    
    NSURL *appUrlStore = [NSURL URLWithString:  stringObtainedFromJavascript1] ; 
    
    
    if([[UIApplication sharedApplication] canOpenURL:appUrl])
    {
         [[UIApplication sharedApplication] openURL:appUrl];
        [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
    }
    else
    {
        
        [[UIApplication sharedApplication] openURL:appUrlStore];
        
         [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
  
    }
    
   
    
}
@end
