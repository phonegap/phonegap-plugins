//
//  ClipboardPlugin.m
//  Clipboard plugin for PhoneGap
//
//  Copyright 2010 Michel Weimerskirch.
//

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif
#import "ClipboardPlugin.h"

@implementation ClipboardPlugin

-(void)setText:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	NSString     *text       = [arguments objectAtIndex:0];

	[pasteboard setValue:text forPasteboardType:@"public.utf8-plain-text"];
}

@end
