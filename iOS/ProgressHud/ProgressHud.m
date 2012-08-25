//
//  ProgressHud.m
//
// Created by Olivier Louvignes on 04/25/2012.
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

#import "ProgressHud.h"

@implementation ProgressHud

@synthesize callbackID = _callbackID;
@synthesize progressHUD = _progressHUD;

-(void)show:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
	//NSLog(@"set:%@\n withDict:%@", arguments, options);

	self.progressHUD = nil;
	self.progressHUD = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
	self.progressHUD.mode = MBProgressHUDModeIndeterminate;

	[self set:arguments withDict:options];

}

-(void)set:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
	//NSLog(@"set:%@\n withDict:%@", arguments, options);

	// The first argument in the arguments parameter is the callbackID.
	// We use this to send data back to the successCallback or failureCallback
	// through PluginResult.
	self.callbackID = [arguments pop];

	// Build returned result
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

	//self.progressHUD = [MBProgressHUD HUDForView:self.webView.superview];
	if(!self.progressHUD) {
		//NSLog(@"set:!self.progressHUD");
		// Create Plugin Result
		CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_INVALID_ACTION messageAsDictionary:result];
		//Call  the Success Javascript function
		[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
		return;
	}

	// Compiling options with defaults
	NSString *mode = [options objectForKey:@"mode"] ?: nil;
	NSString *labelText = [options objectForKey:@"labelText"] ?: nil;
	NSString *detailsLabelText = [options objectForKey:@"detailsLabelText"] ?: nil;
	float progress = [[options objectForKey:@"progress"] floatValue] ?: 0;

	if([mode isEqualToString:@"indeterminate"]) self.progressHUD.mode = MBProgressHUDModeIndeterminate;
	else if([mode isEqualToString:@"determinate"]) self.progressHUD.mode = MBProgressHUDModeDeterminate;
	else if([mode isEqualToString:@"annular-determinate"]) self.progressHUD.mode = MBProgressHUDModeAnnularDeterminate;

	if(labelText) self.progressHUD.labelText = labelText;
	if(detailsLabelText) self.progressHUD.detailsLabelText= detailsLabelText;
	if(progress) self.progressHUD.progress = progress;

	// Create Plugin Result
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
	//Call  the Success Javascript function
	[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];

}

-(void)hide:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
	//NSLog(@"hide:%@\n withDict:%@", arguments, options);

	// The first argument in the arguments parameter is the callbackID.
	// We use this to send data back to the successCallback or failureCallback
	// through PluginResult.
	self.callbackID = [arguments pop];

	// Build returned result
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

	//self.progressHUD = [MBProgressHUD HUDForView:self.webView.superview];
	if(!self.progressHUD) {
		//NSLog(@"hide:!self.progressHUD");
		// Create Plugin Result
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_INVALID_ACTION messageAsDictionary:result];
		//Call  the Success Javascript function
		[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
		return;
	}

	// Hide HUD
	[self.progressHUD hide:YES];

	// Create Plugin Result
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
	//Call  the Success Javascript function
	[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];

}

@end
