//
//  Torch.h
//  PhoneGap Plugin
//
// Created by Shazron Abdullah May 26th 2011

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#endif

#ifdef CORDOVA_FRAMEWORK
#import <CORDOVA/CDVPlugin.h>
#endif

#ifdef PHONEGAP_FRAMEWORK
@interface Torch : PGPlugin {
#endif

#ifdef CORDOVA_FRAMEWORK
@interface Torch : CDVPlugin  {
#endif

	 AVCaptureSession* session;
}

@property (nonatomic, retain) AVCaptureSession* session;

- (void) turnOn:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) turnOff:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
