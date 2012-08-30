//
//  ClipboardPlugin.m
//  Clipboard plugin for PhoneGap
//
//  Copyright 2010 Michel Weimerskirch.
//



#import "ClipboardPlugin.h"
#import <Cordova/CDVPlugin.h>


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
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:text];
  
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
}

@end
