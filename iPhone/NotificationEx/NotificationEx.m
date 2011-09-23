//
//  Notification.m
//  PhoneGap
//
//  Created by Michael Nachbaur on 16/04/09.
//  Copyright 2009 Decaf Ninja Software. All rights reserved.
//  
//  With modifications by Shazron Abdullah, Nitobi Software Inc.
//

#import "NotificationEx.h"
#ifdef PHONEGAP_FRAMEWORK
    #import <PhoneGap/Categories.h>
#else
    #import "Categories.h"
#endif 
#import "UIColor-Expanded.h"


@implementation NotificationEx

@synthesize loadingView;

- (void)loadingStart:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	if (self.loadingView != nil) {
		return;
	}
	
	CGFloat strokeOpacity, backgroundOpacity;
	CGFloat boxLength = [NExLoadingView defaultBoxLength];
	BOOL fullScreen = YES;
	BOOL bounceAnimation = NO;
	NSString* colorCSSString;
	NSString* labelText;
	
	strokeOpacity = [[options objectForKey:@"strokeOpacity"] floatValue];
	backgroundOpacity = [[options objectForKey:@"backgroundOpacity"] floatValue];
	
	id fullScreenValue = [options objectForKey:@"fullScreen"];
	if (fullScreenValue != nil)
	{
		fullScreen = [fullScreenValue boolValue];
		if (!fullScreen) { // here we take into account rectSquareLength, if any
			boxLength = fmax(boxLength, [[options objectForKey:@"boxLength"] floatValue]);
		}
	}

	id bounceAnimationValue = [options objectForKey:@"bounceAnimation"];
	if (bounceAnimationValue != nil)
	{
		bounceAnimation = [bounceAnimationValue boolValue];
	}
	
	colorCSSString = [options objectForKey:@"strokeColor"];
	labelText = [options objectForKey:@"labelText"];
	
	if (!labelText) {
		labelText = [NExLoadingView defaultLabelText];
	}
	
	UIColor* strokeColor = [NExLoadingView defaultStrokeColor];
	
	if (strokeOpacity <= 0) {
		strokeOpacity = [NExLoadingView defaultStrokeOpacity];
	} 

	if (backgroundOpacity <= 0) {
		backgroundOpacity = [NExLoadingView defaultBackgroundOpacity];
	} 
	
	if (colorCSSString) {
		UIColor* tmp = [UIColor colorWithName:colorCSSString];
		if (tmp) {
			strokeColor = tmp;
		} else {
			tmp = [UIColor colorWithHexString:colorCSSString];
			if (tmp) {
				strokeColor = tmp;
			}
		}
	} 
	
	self.loadingView = [NExLoadingView loadingViewInView:[super appViewController].view strokeOpacity:strokeOpacity 
									backgroundOpacity:backgroundOpacity 
										  strokeColor:strokeColor fullScreen:fullScreen labelText:labelText 
									  bounceAnimation:bounceAnimation boxLength:boxLength];
	
	NSRange minMaxDuration = NSMakeRange(2, 3600);// 1 hour max? :)
	NSString* durationKey = @"duration";
	// the view will be shown for a minimum of this value if durationKey is not set
	self.loadingView.minDuration = [options integerValueForKey:@"minDuration" defaultValue:minMaxDuration.location withRange:minMaxDuration];
	
	// if there's a duration set, we set a timer to close the view
	if ([options valueForKey:durationKey]) {
		NSTimeInterval duration = [options integerValueForKey:durationKey defaultValue:minMaxDuration.location withRange:minMaxDuration];
		[self performSelector:@selector(loadingStop:withDict:) withObject:nil afterDelay:duration];
	}
}

- (void)loadingStop:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	if (self.loadingView != nil) 
	{
		NSLog(@"Loading stop");
		NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:self.loadingView.timestamp] - self.loadingView.minDuration;
		
		if (diff >= 0) {
			[self.loadingView removeView]; // the superview will release (see removeView doc), so no worries for below
			self.loadingView = nil;
		} else {
			[self performSelector:@selector(loadingStop:withDict:) withObject:nil afterDelay:-1*diff];
		}
	}
}

- (void)activityStart:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSLog(@"Activity starting");
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
}

- (void)activityStop:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSLog(@"Activitiy stopping ");
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}


@end
