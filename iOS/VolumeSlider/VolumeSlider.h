//
//  	VolumeSlider.h
//  	Volume Slider Cordova Plugin
//
//  	Created by Tommy-Carlos Williams on 20/07/11.
//  	Copyright 2011 Tommy-Carlos Williams. All rights reserved.
//      MIT Licensed
//

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif
#import <MediaPlayer/MediaPlayer.h>


@interface VolumeSlider : CDVPlugin <UITabBarDelegate> {
	NSString* callbackId;
	UIView* mpVolumeViewParentView;
	MPVolumeView* myVolumeView;
}

@property (nonatomic, copy) NSString* callbackId;
@property (nonatomic, retain) UIView* mpVolumeViewParentView;
@property (nonatomic, retain) MPVolumeView* myVolumeView;

- (void)createVolumeSlider:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)showVolumeSlider:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)hideVolumeSlider:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
