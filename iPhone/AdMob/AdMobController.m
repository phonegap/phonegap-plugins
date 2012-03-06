//
//  AdMobController.m
//  idive
//
//  Created by Robert Wallstrom on 11/28/11.
//  Copyright (c) 2011 Smithimage. All rights reserved.
//

#import "AdMobController.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "SampleConstants.h"

@implementation AdMobController

@synthesize adBanner = adBanner_;
@synthesize siteId;

- (PGPlugin*)initWithWebView:(UIWebView*)theWebView 
{
    self = (AdMobController*) [super initWithWebView:theWebView];
    return [super initWithWebView:theWebView];
}

- (void) createBanner:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSLog(@"Create banner executed");
    if(self.adBanner)
        return;
    
    if([options objectForKey:@"siteId"])
    {
        NSLog(@"Setting site Id");
        self.siteId=[[options objectForKey:@"siteId"] description];
    }
    
    // Note that the GADBannerView checks its frame size to determine what size
    // creative to request. 
    //Initialize the banner off the screen so that it animates up when displaying
    self.adBanner = [[[GADBannerView alloc] initWithFrame:[self createRectangle:options]] autorelease];
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID
    // before compiling.
    self.adBanner.adUnitID = self.siteId;
    self.adBanner.delegate = self;
    [self.adBanner setRootViewController:self.appViewController];
    [self.webView.superview addSubview:self.adBanner];
}

- (void) loadBanner:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{    
    NSLog(@"Load banner executed");
    if(!self.adBanner)
        [self createBanner:arguments withDict:options];
    
    GADRequest *request = [self createRequest];
    [self setLocation:&request withDict:options];
    [self.adBanner loadRequest:request];
}

- (void) moveBanner:(NSMutableArray *) argumnets withDict: (NSMutableDictionary *) options 
{
    if(!self.adBanner)
        [self createBanner:argumnets withDict:options];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.adBanner.frame = [self createRectangle:options]; 
    }];
}

- (void) deleteBanner:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    [self.adBanner removeFromSuperview];
    self.adBanner = nil;
} 


- (void) setLocation:(GADRequest**) request withDict: (NSMutableDictionary*) options
{
    CGFloat latitude = 0.0f;
    CGFloat longitude = 0.0f;
    
    if([options objectForKey:@"latitude"] && [options objectForKey:@"longitude"])
    {
        latitude=[[options objectForKey:@"latitude"] floatValue];
        longitude=[[options objectForKey:@"longitude"] floatValue];
        [*request setLocationWithLatitude:longitude longitude:latitude accuracy:1.0f];
    }
}

- (CGRect) createRectangle:(NSMutableDictionary *) options 
{
    CGFloat positionX = GAD_SIZE_320x50.width;
    CGFloat positionY = self.webView.superview.frame.size.height - (GAD_SIZE_320x50.height);
    CGFloat width = GAD_SIZE_320x50.width;
    CGFloat height = GAD_SIZE_320x50.height;
    
    if([options objectForKey:@"positionX"])
    {
        positionX=[[options objectForKey:@"positionX"] floatValue];
    }
    if([options objectForKey:@"positionY"])
    {
        positionY=[[options objectForKey:@"positionY"] floatValue];
    }
    if([options objectForKey:@"width"])
    {
        width=[[options objectForKey:@"width"] floatValue];
    }    
    if([options objectForKey:@"height"])
    {
        height=[[options objectForKey:@"height"] floatValue];
    }
    
    return CGRectMake(positionX, positionY, width, height);
}

- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    //Make the request for a test ad
    //request.testDevices = [NSArray arrayWithObjects:
      //                     GAD_SIMULATOR_ID,                               // Simulator
        //                   nil];
    
    return request;
}

// Sent when an ad request loaded an ad.  This is a good opportunity to add this
// view to the hierarchy if it has not yet been added.  If the ad was received
// as a part of the server-side auto refreshing, you can examine the
// hasAutoRefreshed property of the view.
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    NSLog(@"Received ad");
    [self.webView stringByEvaluatingJavaScriptFromString:@"window.plugins.AdMob.adViewDidReceiveAdCallback();"];
    
}

// Sent when an ad request failed.  Normally this is because no network
// connection was available or no ads were available (i.e. no fill).  If the
// error was received as a part of the server-side auto refreshing, you can
// examine the hasAutoRefreshed property of the view.
- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
    NSString* jsString = [NSString stringWithFormat:@"window.plugins.AdMob.didFailToReceiveAdWithErrorCallback(%@);", 
                          [error localizedFailureReason]];
	[self.webView stringByEvaluatingJavaScriptFromString:jsString];

}

#pragma mark Click-Time Lifecycle Notifications

// Sent just before presenting the user a full screen view, such as a browser,
// in response to clicking on an ad.  Use this opportunity to stop animations,
// time sensitive interactions, etc.
//
// Normally the user looks at the ad, dismisses it, and control returns to your
// application by calling adViewDidDismissScreen:.  However if the user hits the
// Home button or clicks on an App Store link your application will end.  On iOS
// 4.0+ the next method called will be applicationWillResignActive: of your
// UIViewController (UIApplicationWillResignActiveNotification).  Immediately
// after that adViewWillLeaveApplication: is called.
- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
	[self.webView stringByEvaluatingJavaScriptFromString:@"window.plugins.AdMob.adViewWillPresentScreenCallback();"];

}

// Sent just before dismissing a full screen view.
- (void)adViewWillDismissScreen:(GADBannerView *)adView
{
	[self.webView stringByEvaluatingJavaScriptFromString:@"window.plugins.AdMob.adViewWillDismissScreenAdCallback();"];
}

// Sent just after dismissing a full screen view.  Use this opportunity to
// restart anything you may have stopped as part of adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
	[self.webView stringByEvaluatingJavaScriptFromString:@"window.plugins.AdMob.adViewDidDismissScreenCallback();"];
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).  The normal UIApplicationDelegate methods, like
// applicationDidEnterBackground:, will be called immediately before this.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
	[self.webView stringByEvaluatingJavaScriptFromString:@"window.plugins.AdMob.adViewWillLeaveApplicationCallback();"];

}

- (void) dealloc
{
    if (self.adBanner)
	{
        [self.adBanner removeFromSuperview];
        self.adBanner = nil;
	}
	
    self.siteId = nil;
    [super dealloc];
}


@end
