// PDFViewer based on ChildBrowser

//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//  Copyright 2012, Randy McMillan

#import "PDFViewerCommand.h"
#import <Cordova/CDVViewController.h>

@implementation PDFViewerCommand

@synthesize pdfViewer;

- (void)showPDF:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options	// args: url
{
	if (self.pdfViewer == nil) {
#if __has_feature(objc_arc)
			self.pdfViewer = [[PDFViewerViewController alloc] initWithScale:NO];
#else
			self.pdfViewer = [[[PDFViewerViewController alloc] initWithScale:NO] autorelease];
#endif
		self.pdfViewer.delegate				= self;
		self.pdfViewer.orientationDelegate	= self.viewController;
	}

	pdfViewer.modalPresentationStyle = UIModalPresentationPageSheet;
	[self.viewController presentModalViewController:pdfViewer animated:YES];

	NSString *pdfName = (NSString *)[arguments objectAtIndex:0];

	[self.pdfViewer loadPDF:pdfName];	// @"YingYang.pdf"];
}

- (void)close:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options	// args: url
{
	[self.pdfViewer closeViewer];
}

- (void)onClose
{
	[self.webView stringByEvaluatingJavaScriptFromString:@"window.plugins.PDFViewer.onClose();"];
}

#if !__has_feature(objc_arc)
	- (void)dealloc
	{
		self.pdfViewer = nil;

		[super dealloc];
	}

#endif

@end
