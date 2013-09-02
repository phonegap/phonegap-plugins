//
//  ClipboardPlugin.m
//  Clipboard plugin for PhoneGap
//
//  Copyright 2010 Michel Weimerskirch.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>
#import "ClipboardPlugin.h"
#import <Cordova/JSONKit.h>

@implementation ClipboardPlugin

-(void)setText:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	NSString     *text       = [arguments objectAtIndex:0];

	[pasteboard setValue:text forPasteboardType:@"public.text"];
}

-(void)getText:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSString* callbackID = [arguments pop];
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];

	NSString *text = [pasteboard valueForPasteboardType:@"public.text"];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVPluginCommandStatus_OK messageAsString:text];
    //PluginResult* pluginResult = [PluginResult resultWithStatus:PluginCommandStatus_OK messageAsString:text];

    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
}

@end
