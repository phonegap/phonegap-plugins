//
//  AudioRecord.h
//
//  By Lyle Pratt, September 2011.
//  MIT licensed
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>

#ifdef PHONEGAP_FRAMEWORK
    #import <PhoneGap/PGPlugin.h>
    #import <PhoneGap/Sound.h>
#else
    #import "PGPlugin.h"
    #import "Sound.h"
#endif

@interface AudioRecord : PGSound <AVAudioRecorderDelegate> {
}

- (void)startAudioRecord:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) stopAudioRecord:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
