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
	UIView* mpVolumeViewParentView;
	MPVolumeView* myVolumeView;
}

@property (nonatomic, retain) UIView* mpVolumeViewParentView;
@property (nonatomic, retain) MPVolumeView* myVolumeView;

- (void)createVolumeSlider:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)showVolumeSlider:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hideVolumeSlider:(NSArray*)arguments withDict:(NSDictionary*)options;

@end
