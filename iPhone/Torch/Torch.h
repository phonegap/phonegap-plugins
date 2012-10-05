//
//  Torch.h
//  PhoneGap Plugin
//
// Created by Shazron Abdullah May 26th 2011

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import <CORDOVA/CDVPlugin.h>

@interface Torch : CDVPlugin  {
	 AVCaptureSession* session;
}

@property (nonatomic, retain) AVCaptureSession* session;

- (void) turnOn:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) turnOff:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) isCapable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
