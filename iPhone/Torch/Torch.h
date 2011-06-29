//
//  Torch.h
//  PhoneGap Plugin
//
// Created by Shazron Abdullah May 26th 2011

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PhoneGapCommand.h>
#else
#import "PhoneGapCommand.h"
#endif

@interface Torch : PGPlugin {

	 AVCaptureSession* session;
}

@property (nonatomic, retain) AVCaptureSession* session;

- (void) turnOn:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) turnOff:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
