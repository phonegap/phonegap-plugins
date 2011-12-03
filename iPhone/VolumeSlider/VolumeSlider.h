//
//  	VolumeSlider.h
//  	Volume Slider PhoneGap Plugin
//
//  	Created by Tommy-Carlos Williams on 20/07/25.
//  	Copyright 2011 Tommy-Carlos Williams. All rights reserved.
//      MIT Licensed
//

#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif
#import <MediaPlayer/MediaPlayer.h>


@interface VolumeSlider : PGPlugin <UITabBarDelegate> {
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
