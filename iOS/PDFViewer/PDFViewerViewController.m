// PDFViewer based on ChildBrowser

// /  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//  Copyright 2012, Randy McMillan

#import "PDFViewerViewController.h"
#import "UIImage+PDF.h"

@implementation PDFViewerViewController

@synthesize delegate, orientationDelegate;
@synthesize closeBtn;

@synthesize pdfView;
@synthesize scrollView;
@synthesize imageView;
@synthesize toolBar;

/*
 *   // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 *   - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 *    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 *        // Custom initialization
 *    }
 *    return self;
 *   }
 */

+ (NSString *)resolveImageResource:(NSString *)resource
{
	NSString	*systemVersion	= [[UIDevice currentDevice] systemVersion];
	BOOL		isLessThaniOS4	= ([systemVersion compare:@"4.0" options:NSNumericSearch] == NSOrderedAscending);

	if (isLessThaniOS4) {
		return [NSString stringWithFormat:@"%@.png", resource];
	} else {
		if (([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES) && ([[UIScreen mainScreen] scale] == 2.00)) {
			return [NSString stringWithFormat:@"%@@2x.png", resource];
		}
	}

	return resource;// if all else fails
}

- (PDFViewerViewController *)initWithScale:(BOOL)enabled
{
	self = [super init];
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];

	// [self loadPDF:@"YingYang.pdf"];
	NSLog(@"View did load");
}

- (void)loadPDF:(NSString *)pdfName
{
	NSLog(@"Opening Url : %@", pdfName);

	//    NSString* url = (NSString*)[arguments objectAtIndex:0];

	UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage originalSizeImageWithPDFNamed:pdfName]];
	// imageView.center = self.view.center;

	self.imageView.image = tempImageView.image;

	// [ self.pdfView addSubview:imageView ];

#define VIEWBOUNDS [[UIScreen mainScreen] bounds]

	// [scrollView  setBounds:self.view.superview.frame];//VIEWBOUNDS];
	//  [imageView setBounds:self.view.superview.frame];//VIEWBOUNDS];
	// [pdfView setBounds:self.view.superview.frame];//VIEWBOUNDS];

	// [scrollView  setBounds:CGRectMake(scrollView.superview.center.x, scrollView.superview.center.y, 100, 100)];

	scrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);

	imageView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);

	//     imageView.center = self.view.superview.center;

	[tempImageView release];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];

	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	NSLog(@"View did UN-load");
	pdfView = nil;
}

- (void)dealloc
{
	self.delegate				= nil;
	self.orientationDelegate	= nil;

#if !__has_feature(objc_arc)
		[super dealloc];
#endif
}

- (void)closeBrowser
{
	if (self.delegate != nil) {
		[self.delegate onClose];
	}

	if ([self respondsToSelector:@selector(presentingViewController)]) {
		// Reference UIViewController.h Line:179 for update to iOS 5 difference - @RandyMcMillan
		[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
	} else {
		[[self parentViewController] dismissModalViewControllerAnimated:YES];
	}
}

- (IBAction)onDoneButtonPress:(id)sender
{
	[self closeBrowser];
}

/*- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
 *    NSLog (@"webView:didFailLoadWithError");
 *    [spinner stopAnimating];
 *    addressLabel.text = @"Failed";
 *    if (error != NULL) {
 *        UIAlertView *errorAlert = [[UIAlertView alloc]
 *                                   initWithTitle: [error localizedDescription]
 *                                   message: [error localizedFailureReason]
 *                                   delegate:nil
 *                                   cancelButtonTitle:@"OK"
 *                                   otherButtonTitles:nil];
 *        [errorAlert show];
 *        [errorAlert release];
 *    }
 *   }
 */

#pragma mark CDVOrientationDelegate

- (BOOL)shouldAutorotate
{
	if ((self.orientationDelegate != nil) && [self.orientationDelegate respondsToSelector:@selector(shouldAutorotate)]) {
		return [self.orientationDelegate shouldAutorotate];
	}

	return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
	if ((self.orientationDelegate != nil) && [self.orientationDelegate respondsToSelector:@selector(supportedInterfaceOrientations)]) {
		return [self.orientationDelegate supportedInterfaceOrientations];
	}

	return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ((self.orientationDelegate != nil) && [self.orientationDelegate respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)]) {
		return [self.orientationDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
	}

	return YES;
}

@end
