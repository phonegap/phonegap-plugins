//
//  ClipboardPlugin.m
//  Clipboard plugin for PhoneGap
//
//  Copyright 2010 Michel Weimerskirch.
//

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#import <PhoneGap/PluginResult.h>
#else
#import "PGPlugin.h"
#import "PluginResult.h"
#endif
#import "ClipboardPlugin.h"

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
    
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsString:text];
  
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
}

@end
