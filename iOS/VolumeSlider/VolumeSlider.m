//
//  	VolumeSlider.m
//  	Volume Slider Cordova Plugin
//
//  	Created by Tommy-Carlos Williams on 20/07/11.
//  	Copyright 2011 Tommy-Carlos Williams. All rights reserved.
//      MIT Licensed
//

#import "VolumeSlider.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation VolumeSlider

@synthesize mpVolumeViewParentView, myVolumeView, callbackId;

#ifndef __IPHONE_3_0
@synthesize webView;
#endif

-(CDVPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (VolumeSlider*)[super initWithWebView:theWebView];
    return self;
}

- (void)dealloc
{	
	[mpVolumeViewParentView release];
	[myVolumeView release];
    [super dealloc];
}


#pragma mark -
#pragma mark VolumeSlider

- (void) createVolumeSlider:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{	
	self.callbackId = arguments.pop;
	NSUInteger argc = [arguments count];
	
	if (argc < 3) { // at a minimum we need x origin, y origin and width...
		return;	
	}
	
	CGFloat originx,originy,width;
	CGFloat height = 30;
	
	originx = [[arguments objectAtIndex:0] floatValue];
	originy = [[arguments objectAtIndex:1] floatValue];
	width = [[arguments objectAtIndex:2] floatValue];
	if (argc < 4) {
		height = [[arguments objectAtIndex:3] floatValue];
	}
	
	CGRect viewRect = CGRectMake(
								 originx, 
								 originy, 
								 width, 
								 height
								 );
	self.mpVolumeViewParentView = [[[UIView alloc] initWithFrame:viewRect] autorelease];
	[self.webView.superview addSubview:mpVolumeViewParentView];
	
	mpVolumeViewParentView.backgroundColor = [UIColor clearColor];
	self.myVolumeView =
	[[MPVolumeView alloc] initWithFrame: mpVolumeViewParentView.bounds];
	[mpVolumeViewParentView addSubview: myVolumeView];
	self.myVolumeView.showsVolumeSlider = NO;
}

- (void)showVolumeSlider:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	self.myVolumeView.showsVolumeSlider = YES;
	self.mpVolumeViewParentView.hidden = NO;
}

- (void)hideVolumeSlider:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	self.mpVolumeViewParentView.hidden = YES;
	self.myVolumeView.showsVolumeSlider = NO;
}



@end
