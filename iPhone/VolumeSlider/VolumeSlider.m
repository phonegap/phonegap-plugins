//
//  	VolumeSlider.m
//  	Volume Slider PhoneGap Plugin
//
//  	Created by Tommy-Carlos Williams on 20/07/25.
//  	Copyright 2011 Tommy-Carlos Williams. All rights reserved.
//      MIT Licensed
//

#import "VolumeSlider.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation VolumeSlider

@synthesize mpVolumeViewParentView, myVolumeView;

#ifndef __IPHONE_3_0
@synthesize webView;
#endif

-(PGPlugin*) initWithWebView:(UIWebView*)theWebView
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

- (void) createVolumeSlider:(NSArray*)arguments withDict:(NSDictionary*)options
{	
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

- (void)showVolumeSlider:(NSArray*)arguments withDict:(NSDictionary*)options
{
	self.myVolumeView.showsVolumeSlider = YES;
}

- (void)hideVolumeSlider:(NSArray*)arguments withDict:(NSDictionary*)options
{
	self.myVolumeView.showsVolumeSlider = NO;
}



@end
