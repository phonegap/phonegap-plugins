//
//  AudioRecord.h
//
//  By Lyle Pratt, September 2011.
//  MIT licensed
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>


#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVSound.h>
#else
#import "CDVSound.h"
#endif

@interface AudioRecord : CDVSound <AVAudioRecorderDelegate> {
}

- (void)startAudioRecord:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) stopAudioRecord:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
