//
//  ActionSheet.m
//  
// Created by Olivier Louvignes on 11/27/2011.
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

#import "ActionSheet.h" 

@implementation ActionSheet 

@synthesize callbackID;

-(void)create:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
	
	//NSLog(@"options: %@", options);
	//NSLog(@"arguments: %@", arguments);
	
	// The first argument in the arguments parameter is the callbackID.
	// We use this to send data back to the successCallback or failureCallback
	// through PluginResult.
	self.callbackID = [arguments pop];
	
	// Compiling options with defaults
	NSString *title = [options objectForKey:@"title"] ?: @"";
	NSString *style = [options objectForKey:@"style"] ?: @"black-translucent";
	NSArray *items = [options objectForKey:@"items"];
	NSInteger cancelButtonIndex = [[options objectForKey:@"cancelButtonIndex"] intValue] ?: false;
	NSInteger destructiveButtonIndex = [[options objectForKey:@"destructiveButtonIndex"] intValue] ?: false;
	
	// Create actionSheet
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
												   delegate:self
										  cancelButtonTitle:nil
									 destructiveButtonTitle:nil
										  otherButtonTitles:nil];
	
	// Style actionSheet, defaults to BlackTranslucent
	if([style isEqualToString:@"black-opaque"]) actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	else actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	
	// Fill with elements
	for(int i = 0; i < [items count]; i++) {
		[actionSheet addButtonWithTitle:[items objectAtIndex:i]];
	}
	// Handle cancelButtonIndex
	if([options objectForKey:@"cancelButtonIndex"]) {
		actionSheet.cancelButtonIndex = cancelButtonIndex;
	}
	// Handle destructiveButtonIndex
	if([options objectForKey:@"destructiveButtonIndex"]) {
		actionSheet.destructiveButtonIndex = destructiveButtonIndex;
	}

	// Toggle ActionSheet
    [actionSheet showInView:self.webView.superview];

}

/*-(void)show:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
	// Toggle ActionSheet
    [self.actionSheet showInView:self.webView.superview];
}*/

// ActionSheet generic dismiss
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	//NSLog(@"didDismissWithButtonIndex:%d", buttonIndex);
	
	// Build returned result
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	[result setObject:[NSNumber numberWithInteger:buttonIndex] forKey:@"buttonIndex"];
	
	// Create Plugin Result
	PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsDictionary:result];
	
	// Checking if cancel was clicked
	if (buttonIndex != actionSheet.cancelButtonIndex) {
		//Call  the Failure Javascript function
		[self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
	// Checking if destructive was clicked
	} else if (buttonIndex != actionSheet.destructiveButtonIndex) {
		//Call  the Success Javascript function
		[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
	// Other button was clicked
	} else {    
		//Call  the Success Javascript function
		[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
	}
	
	// Release objects
	[actionSheet release];
}

@end
