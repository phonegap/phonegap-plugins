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

-(void)show:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
	
	//NSLog(@"options: %@", options);
	//NSLog(@"arguments: %@", arguments);
	
	self.progressHUD = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
	self.progressHUD.mode = MBProgressHUDModeIndeterminate;

	[self set:arguments withDict:options];
	
}

-(void)set:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
	
	//NSLog(@"options: %@", options);
	//NSLog(@"arguments: %@", arguments);
	
	// The first argument in the arguments parameter is the callbackID.
	// We use this to send data back to the successCallback or failureCallback
	// through PluginResult.
	self.callbackID = [arguments pop];
	
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
	
	// Build returned result
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	// Create Plugin Result
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
	//Call  the Success Javascript function
	[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
	
}

-(void)hide:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
	
	//NSLog(@"options: %@", options);
	//NSLog(@"arguments: %@", arguments);
	
	// The first argument in the arguments parameter is the callbackID.
	// We use this to send data back to the successCallback or failureCallback
	// through PluginResult.
	self.callbackID = [arguments pop];

	// Hide HUD
	[MBProgressHUD hideHUDForView:self.webView.superview animated:YES];
	
	// Build returned result
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	// Create Plugin Result
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
	//Call  the Success Javascript function
	[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
	
	// Release objects
	[self.progressHUD release];
	
}

@end
