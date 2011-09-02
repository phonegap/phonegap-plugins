//
//  AudioEncode.h
//
//  By Lyle Pratt, September 2011.
//  MIT licensed
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#ifdef PHONEGAP_FRAMEWORK
    #import <PhoneGap/PGPlugin.h>
#else
    #import "PGPlugin.h"
#endif

@interface AudioEncode : PGPlugin {
    NSString* successCallback;
    NSString* failCallback;
}

@property (nonatomic, retain) NSString* successCallback;
@property (nonatomic, retain) NSString* failCallback;

- (void)encodeAudio:(NSArray*)arguments withDict:(NSDictionary*)options;
@end
