//
//  SAiOSAdPlugin.h
//  ADPlugin for PhoneGap
//
//  Created by shazron on 10-07-12.
//  Copyright 2010 Shazron Abdullah. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PhoneGapCommand.h>
#else
#import "PhoneGapCommand.h"
#endif
#import <iAd/iAd.h>

@interface SAiOSAdPlugin : PhoneGapCommand <ADBannerViewDelegate> {

	ADBannerView* adView;

	BOOL bannerIsVisible;
	BOOL bannerIsInitialized;
	BOOL bannerIsAtBottom;
}

@property (nonatomic, retain)	ADBannerView* adView;
@property (assign)				BOOL bannerIsVisible;
@property (assign)				BOOL bannerIsInitialized;
@property (assign)				BOOL bannerIsAtBottom;


- (void) prepare:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) showAd:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
