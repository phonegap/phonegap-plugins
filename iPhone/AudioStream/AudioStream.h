//
//  AudioStream.h
//  AudioStreamer PhoneGap Plugin
//
//  Created by Tommy-Carlos Williams on 20/07/11.
//  Copyright 2011 Devgeeks. All rights reserved.
//

#ifdef PHONEGAP_FRAMEWORK
    #import <PhoneGap/PGPlugin.h>
#else
    #import "PGPlugin.h"
#endif

#import "AudioStreamer.h"

@interface AudioStream : PGPlugin <UITabBarDelegate> {
    AudioStreamer *streamer;
	NSTimer *progressUpdateTimer;
    
    NSString* successCallback;
    NSString* failCallback;
    NSString* status;
    NSString* streamUrl;

}

@property (nonatomic, copy) NSString* successCallback;
@property (nonatomic, copy) NSString* failCallback;
@property (nonatomic, copy) NSString* status;
@property (nonatomic, copy) NSString* streamUrl;

- (void)play:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)stop:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
