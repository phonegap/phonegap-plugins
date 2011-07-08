/**
 * Bundle File Reader Plugin
 * Copyright (c) 2011 Tim Fischbach (github.com/tf)
 * MIT licensed
 */

#import "BundleFileReader.h"

@implementation BundleFileReader

/**
 * See bundle_file_reader.js for documentation.
 */
- (void)readResource:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
	NSString* callbackId = [arguments objectAtIndex:0];
	NSString* resource = [arguments objectAtIndex:1];
	NSString* type = [arguments objectAtIndex:2];
	NSString* dir = [arguments objectAtIndex:3];

	PluginResult* result = nil;
	NSString* jsString = nil;

	NSString* filePath = [[NSBundle mainBundle] pathForResource:resource ofType:type inDirectory:dir];

	if (filePath) {
		NSData* data =  [[NSData alloc] initWithContentsOfFile:filePath];
		NSString* strBuffer = nil;

		if (data) {
			strBuffer = [[NSString alloc] initWithBytes: [data bytes] length: [data length] encoding: NSUTF8StringEncoding];
		}
		else {
			strBuffer = [[NSString alloc] initWithString: @""];
		}

		result = [PluginResult resultWithStatus: PGCommandStatus_OK messageAsString: [ strBuffer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
		jsString = [result toSuccessCallbackString:callbackId];

		[strBuffer release];
		[data release];
	}
	else {
		result = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsString: @"Bundle resource not found." ];
		jsString = [result toErrorCallbackString:callbackId];
	}

	if (jsString) {
		[self writeJavascript: jsString];
	}
}

@end
