//
//  SAiOSAdPlugin.m
//  Ad Plugin for PhoneGap
//
//  Created by shazron on 10-07-12.
//  Copyright 2010 Shazron Abdullah. All rights reserved.
//

#import "SAiOSAdPlugin.h"

@interface SAiOSAdPlugin(PrivateMethods)

- (void) __prepare:(BOOL)atBottom;
- (void) __showAd:(BOOL)show;

@end


@implementation SAiOSAdPlugin

@synthesize adView;
@synthesize bannerIsVisible, bannerIsInitialized, bannerIsAtBottom;

#pragma mark -
#pragma mark Public Methods

- (void) prepare:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	NSUInteger argc = [arguments count];
	if (argc > 1) {
		return;
	}
	
	NSString* atBottomValue = [arguments objectAtIndex:0];
	[self __prepare:[atBottomValue boolValue]];
}

- (void) showAd:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	NSUInteger argc = [arguments count];
	if (argc > 1) {
		return;
	}
	
	NSString* showValue = [arguments objectAtIndex:0];
	[self __showAd:[showValue boolValue]];
}

#pragma mark -
#pragma mark Private Methods

- (void) __prepare:(BOOL)atBottom
{
	NSLog(@"SAiOSAdPlugin Prepare Ad At Bottom: %d", atBottom);
	
	Class adBannerViewClass = NSClassFromString(@"ADBannerView");
	if (adBannerViewClass && !self.adView)
	{
		adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
		adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];		
		adView.delegate = self;

		self.bannerIsAtBottom = atBottom;
		self.bannerIsVisible = NO;
		self.bannerIsInitialized = YES;
	}
}

- (void) __showAd:(BOOL)show
{
	NSLog(@"SAiOSAdPlugin Show Ad: %d", show);
	
	if (!self.bannerIsInitialized){
		[self __prepare:NO];
	}
	
	if (!(NSClassFromString(@"ADBannerView") && self.adView)) { // ad classes not available
		return;
	}
	
	if (show == self.bannerIsVisible) { // same state, nothing to do
		return;
	}
	
	CGRect adViewFrame = adView.frame;
	CGRect webViewFrame = webView.frame;
	CGRect screenFrame = [ [ UIScreen mainScreen ] applicationFrame ];
	
	//CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	
	[UIView beginAnimations:@"blah" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	if (show)
	{
//		CGFloat bannerHeight = 0.0;
//		
//		// First, setup the banner's content size and adjustment based on the current orientation
//		if(UIInterfaceOrientationIsLandscape(self.appViewController.interfaceOrientation))
//		{
//			adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
//			bannerHeight = 32.0;
//		}
//		else
//		{
//			adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
//			bannerHeight = 50.0;
//		}
		
		adViewFrame.size.width = screenFrame.size.width;
		
		if (self.bannerIsAtBottom) 
		{
			adViewFrame.origin.y = screenFrame.size.height - adViewFrame.size.height;
			
			self.adView.frame = adViewFrame;

		}
		else // aka: at the top
		{
			webViewFrame.origin.y += adViewFrame.size.height;
		}

		
		webViewFrame.size.height -= adViewFrame.size.height;

		webView.frame = webViewFrame;
		[ webView.superview addSubview:self.adView];
		
		self.bannerIsVisible = YES;
	}
	else 
	{
		if (self.bannerIsAtBottom) 
		{

		}
		else // aka: at the top
		{
			webViewFrame.origin.y = screenFrame.origin.y;
		}

		
		webViewFrame.size.height += adViewFrame.size.height;
		
		webView.frame = webViewFrame;
		[ adView removeFromSuperview];
		
		
		self.bannerIsVisible = NO;
	}
	
	[UIView commitAnimations];
	
}

#pragma mark -
#pragma ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	Class adBannerViewClass = NSClassFromString(@"ADBannerView");
    if (adBannerViewClass)
    {
		NSString* jsString = 
		@"(function(){"
		"var e = document.createEvent('Events');"
		"e.initEvent('iAdBannerViewDidLoadAdEvent');"
		"document.dispatchEvent(e);"
		"})();";

		[super writeJavascript:jsString];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError*)error
{
	Class adBannerViewClass = NSClassFromString(@"ADBannerView");
    if (adBannerViewClass)
    {
		NSString* jsString = 
		@"(function(){"
		"var e = document.createEvent('Events');"
		"e.initEvent('iAdBannerViewDidFailToReceiveAdWithErrorEvent');"
		"e.error = '%@';"
		"document.dispatchEvent(e);"
		"})();";
		
		[super writeJavascript:[NSString stringWithFormat:jsString, [error description]]];
    }
}

@end
