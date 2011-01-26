//
//  BarcodeScanner.m
//
//  Created by Matt Kane on 12/01/2011.
//  Copyright 2011 Matt Kane. All rights reserved.
//

#import "BarcodeScanner.h"


@implementation BarcodeScanner

@synthesize successCallback, failCallback;

- (void) scan:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{	
	NSUInteger argc = [arguments count];
	
	if (argc < 1) {
		return;	
	}
	self.successCallback = [arguments objectAtIndex:0];
	if (argc > 1) {
		self.failCallback = [arguments objectAtIndex:1];	
	}
	//if (argc > 2) {
		// TODO: Choose the readers to load
	//}
	
	ZXingWidgetController *widgetController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
	QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
	NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
	[qrcodeReader release];
	widgetController.readers = readers;
	[readers release];
	[[super appViewController ]  presentModalViewController:widgetController animated:YES];
	[widgetController release];
}

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
	NSString* jsCallBack = [NSString stringWithFormat:@"%@(\"%@\");", self.successCallback, [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
	[self writeJavascript: jsCallBack];
	[[super appViewController ]  dismissModalViewControllerAnimated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
	[self writeJavascript: [NSString stringWithFormat:@"%@();", self.failCallback]];
	[[super appViewController ]  dismissModalViewControllerAnimated:YES];
}

@end
