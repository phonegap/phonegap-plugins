//
//  MessageBox.m
//  
// Created by Olivier Louvignes on 11/26/2011.
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

#import "MessageBox.h" 

@implementation MessageBox 

@synthesize callbackID;

-(void)prompt:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
	
	//NSLog(@"options: %@", options);
	//NSLog(@"arguments: %@", arguments);
	
	// The first argument in the arguments parameter is the callbackID.
	// We use this to send data back to the successCallback or failureCallback
	// through PluginResult.
	self.callbackID = [arguments pop];
	
	// Compiling options with defaults
	NSString *title = [options objectForKey:@"title"] ?: @"Prompt";
	NSMutableString *message = [NSMutableString stringWithString: ([options objectForKey:@"message"] ?: @"")];
	NSString *type = [options objectForKey:@"type"] ?: @"text";
	NSString *placeholder = [options objectForKey:@"placeholder"] ?: @"";
    NSString *okButtonTitle = [options objectForKey:@"okButtonTitle"] ?: @"OK";
    NSString *cancelButtonTitle = [options objectForKey:@"cancelButtonTitle"] ?: @"Cancel";
	NSInteger textFieldPositionRow = (int)[options objectForKey:@"textFieldPositionRow"] ?: 1;
	
	// Increment textFieldPositionRow if there is a message
	if ([message length] != 0 && textFieldPositionRow == 1) {
		[message appendString: @"\n"];
		textFieldPositionRow = 2;
	}
	// Append line-break to the message
	[message appendString: @"\n"];
	
	// Create UIAlertView popup
	UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:title 
													 message:message
													delegate:self 
										   cancelButtonTitle:cancelButtonTitle 
										   otherButtonTitles:okButtonTitle, nil];

	// Create prompt textField
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 20.0 + textFieldPositionRow*25.0, 260.0, 25.0)]; // left, top, width, height
	[textField setBackgroundColor:[UIColor whiteColor]];
	if ([placeholder length] != 0) {
		NSLog(@"Placeholder!");
		[textField setPlaceholder:placeholder];
	}
	if ([[type lowercaseString] isEqualToString:@"password"]) [textField setSecureTextEntry:YES];
        if ([[type lowercaseString] isEqualToString:@"decimalpad"]) [textField setKeyboardType:UIKeyboardTypeDecimalPad];

	[prompt addSubview:textField];
	
	// Position fix for iOS < 4
	NSString *iOsVersion = [[UIDevice currentDevice] systemVersion];
	if ([iOsVersion intValue] < 4) {
		[prompt setTransform:CGAffineTransformMakeTranslation(0.0, 110.0)];
	}
	
	// Display prompt
	[prompt show];
    [prompt release];
	
	// Set cursor and show keyboard
	[textField becomeFirstResponder];
	
}

- (void)alertView:(UIAlertView *)view clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	//NSLog(@"Clicked %d", buttonIndex);
	
	// Retreive textField object from view
	UITextField *textField = [view.subviews objectAtIndex:5];

	// Build returned result
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	[result setObject:textField.text forKey:@"value"];
	[result setObject:[NSNumber numberWithInteger:buttonIndex] forKey:@"buttonIndex"];
	
	// Create Plugin Result
	PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsDictionary:result];
	
	// Checking if cancel was clicked
	if (buttonIndex != [view cancelButtonIndex]) {
		//Call  the Success Javascript function
		[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
	} else {    
		//Call  the Failure Javascript function
		[self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
	}

}

@end

/*
 https://github.com/callback/callback-ios/blob/master/PhoneGapLib/Classes/PluginResult.m
 https://github.com/callback/callback-ios/blob/master/PhoneGapLib/Classes/PluginResult.h
 
 
 -(PluginResult*) init;
 +(void) releaseStatus;
 +(PluginResult*) resultWithStatus: (PGCommandStatus) statusOrdinal;
 +(PluginResult*) resultWithStatus: (PGCommandStatus) statusOrdinal messageAsString: (NSString*) theMessage;
 +(PluginResult*) resultWithStatus: (PGCommandStatus) statusOrdinal messageAsArray: (NSArray*) theMessage;
 +(PluginResult*) resultWithStatus: (PGCommandStatus) statusOrdinal messageAsInt: (int) theMessage;
 +(PluginResult*) resultWithStatus: (PGCommandStatus) statusOrdinal messageAsDouble: (double) theMessage;
 +(PluginResult*) resultWithStatus: (PGCommandStatus) statusOrdinal messageAsDictionary: (NSDictionary*) theMessage;
 +(PluginResult*) resultWithStatus: (PGCommandStatus) statusOrdinal messageAsString: (NSString*) theMessage cast: (NSString*) theCast;
 +(PluginResult*) resultWithStatus: (PGCommandStatus) statusOrdinal messageAsArray: (NSArray*) theMessage cast: (NSString*) theCast;
 +(PluginResult*) resultWithStatus: (PGCommandStatus) statusOrdinal messageAsInt: (int) theMessage cast: (NSString*) theCast;
 +(PluginResult*) resultWithStatus: (PGCommandStatus) statusOrdinal messageAsDouble: (double) theMessage cast: (NSString*) theCast;
 +(PluginResult*) resultWithStatus: (PGCommandStatus) statusOrdinal messageAsDictionary: (NSDictionary*) theMessage cast: (NSString*) theCast;
 +(PluginResult*) resultWithStatus: (PGCommandStatus) statusOrdinal messageToErrorObject: (int) errorCode;
*/
