//
//  Torch.m
//  PhoneGap Plugin
//
// Created by Shazron Abdullah May 26th 2011
//

#import "Torch.h"

@interface Torch (PrivateMethods)

- (void) setup;

@end


@implementation Torch

@synthesize session;

#ifdef PHONEGAP_FRAMEWORK
- (PGPlugin*) initWithWebView:(UIWebView*)theWebView
#endif

#ifdef CORDOVA_FRAMEWORK
- (CDVPlugin*) initWithWebView:(UIWebView*)theWebView
#endif

{
    self = (Torch*)[super initWithWebView:theWebView];
    if (self) {
		[self setup];
    }
    return self;
}

- (void) setup
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) 
	{
        AVCaptureDevice* captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([captureDevice hasTorch] && [captureDevice hasFlash] && captureDevice.torchMode == AVCaptureTorchModeOff)
		{
			AVCaptureDeviceInput* deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error: nil];
			AVCaptureVideoDataOutput* videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
			
			AVCaptureSession* captureSession = [[AVCaptureSession alloc] init];
			
			[captureSession beginConfiguration];
			[captureDevice lockForConfiguration:nil];
			
			[captureSession addInput:deviceInput];
			[captureSession addOutput:videoDataOutput];
			
			[captureDevice unlockForConfiguration];
			
			[videoDataOutput release];
			
			[captureSession commitConfiguration];
			[captureSession startRunning];
			
			self.session = captureSession;
			[captureSession release];
        }
		else {
			NSLog(@"Torch not available, hasFlash: %d hasTorch: %d torchMode: %d", 
				  captureDevice.hasFlash,
				  captureDevice.hasTorch,
				  captureDevice.torchMode
				  );
		}

    }
	else {
		NSLog(@"Torch not available, AVCaptureDevice class not found.");
	}
}

- (void) turnOn:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	// test if this class even exists to ensure flashlight is turned on ONLY for iOS 4 and above
	Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
	if (captureDeviceClass != nil) {
		
		AVCaptureDevice* captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
		
		[captureDevice lockForConfiguration:nil];
		
		[captureDevice setTorchMode:AVCaptureTorchModeOn];
		[captureDevice setFlashMode:AVCaptureFlashModeOn];
		
		[captureDevice unlockForConfiguration];
		
		[super writeJavascript:@"window.plugins.torch._isOn = true;"];
	}	
}

- (void) turnOff:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
	if (captureDeviceClass != nil) 
	{
		AVCaptureDevice* captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
		
		[captureDevice lockForConfiguration:nil];
		
		[captureDevice setTorchMode:AVCaptureTorchModeOff];
		[captureDevice setFlashMode:AVCaptureFlashModeOff];
		
		[captureDevice unlockForConfiguration];

		[super writeJavascript:@"window.plugins.torch._isOn = false;"];
	}	
}

- (void) dealloc
{
	[self turnOff:nil withDict:nil];
	self.session = nil;
	
	[super dealloc];
}

@end
