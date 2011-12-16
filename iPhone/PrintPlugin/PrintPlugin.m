//
//  PrintPlugin.m
//  Print Plugin
//
//  Created by Ian Tipton (github.com/itip) on 02/07/2011.
//  Copyright 2011 Ian Tipton. All rights reserved.
//  MIT licensed
//

#import "PrintPlugin.h"

@interface PrintPlugin (Private)
- (BOOL) isPrintServiceAvailable;
@end

@implementation PrintPlugin


- (void) isPrintingAvailable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	NSString* callbackID = [arguments pop];
	PluginResult* result;

	if ([self isPrintServiceAvailable])
	{
		result = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsString:@"Printing is available."];
		[self writeJavascript: [result toSuccessCallbackString:callbackID]];
		return;
	}

	result = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsString:@"Device doesn't support printing or printing is not available."];
	[self writeJavascript: [result toErrorCallbackString:callbackID]];
}

- (void) print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options{
	NSString* callbackID = [arguments pop];
	VERIFY_ARGUMENTS(arguments, 7, callbackID)

	NSString* html = [arguments pop];
	UIPrintInfoOutputType outputType = [[arguments pop] intValue];
	NSString* jobName = [arguments pop];
	UIPrintInfoDuplex duplex = [[arguments pop] intValue];
	UIPrintInfoOrientation orientation = [[arguments pop] intValue];
	BOOL showsPageRange = [[arguments pop] boolValue];
	CGRect presentFromRect = CGRectFromString([arguments pop]);


	__block PluginResult* result;


	if (![self isPrintServiceAvailable])
	{
		result = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:@"Device doesn't support printing or printing is not available."];
		[self writeJavascript: [result toErrorCallbackString:callbackID]];
		return;
	}

	UIPrintInteractionController* controller = [UIPrintInteractionController sharedPrintController];
	if (!controller)
	{
		result = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:@"Couldn't get shared UIPrintInteractionController!"];
		[self writeJavascript: [result toErrorCallbackString:callbackID]];
		return;
	}

	UIPrintInfo* printInfo = [UIPrintInfo printInfo];
	printInfo.outputType = outputType;
	printInfo.duplex = duplex;
	printInfo.orientation = orientation;

	if ([jobName length] > 0) {
		printInfo.jobName = jobName;
	}

	controller.printInfo = printInfo;
	controller.showsPageRange = showsPageRange;

	//Set the base URL to be the www directory.
	NSURL* baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"www" ofType:nil ]];

	//Load page into a webview and use its formatter to print the page
	UIWebView *webViewPrint = [[UIWebView alloc] init];
	webViewPrint.dataDetectorTypes = UIDataDetectorTypeNone;
	[webViewPrint loadHTMLString:html baseURL:baseURL];

	UIViewPrintFormatter *viewFormatter = [webViewPrint viewPrintFormatter];
	controller.printFormatter = viewFormatter;

	//Respond to Print-Job Completion and Errors
	void (^completionHandler)(UIPrintInteractionController*, BOOL, NSError*) =
		^(UIPrintInteractionController* printController, BOOL completed, NSError* error)
	{
		if (!completed && error)
		{
			result = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:error.localizedDescription];
			[self writeJavascript: [result toErrorCallbackString:callbackID]];
		}
		else if (!completed)
		{
			result = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:@"Print job not completed."];
			[self writeJavascript: [result toErrorCallbackString:callbackID]];
		}
		else
		{
			result = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsString:@"Print job completed."];
			[self writeJavascript: [result toSuccessCallbackString:callbackID]];
		}
		[webViewPrint release];
	};

	//Show the Print dialog
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && !CGRectIsEmpty(presentFromRect))
	{
		[controller presentFromRect:presentFromRect inView:self.webView animated:YES completionHandler:completionHandler];
	}
	else
	{
		[controller presentAnimated:YES completionHandler:completionHandler];
	}
}


-(BOOL) isPrintServiceAvailable
{
	Class printControllerClass = NSClassFromString(@"UIPrintInteractionController");
	if (printControllerClass)
	{
		UIPrintInteractionController* controller = [UIPrintInteractionController sharedPrintController];
		return controller && [UIPrintInteractionController isPrintingAvailable];
	}

	return NO;
}

@end
