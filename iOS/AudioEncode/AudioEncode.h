//
//  AudioEncode.h
//
//  By Lyle Pratt, September 2011.
//    Updated Oct 2012 by Keenan Wyrobek for Cordova 2.1.0
//  MIT licensed
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Cordova/CDV.h>

@interface AudioEncode : CDVPlugin{
    NSString* callbackId;
}

@property (nonatomic, retain) NSString* callbackId;

- (void)encodeAudio:(NSArray*)arguments withDict:(NSDictionary*)options;
@end
