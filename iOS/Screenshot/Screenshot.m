//
//  Screenshot.h
//
//  Created by Simon Madine on 29/04/2010.
//  Copyright 2010 The Angry Robot Zombie Factory.
//   - Converted to Cordova 1.6.1 by Josemando Sobral.
//  MIT licensed
//
//  Modifications to support orientation change by @ffd8
//

#import "Screenshot.h"
#import "NSData+Base64.h"

@implementation Screenshot

@synthesize webView;

- (void)saveScreenshot:(NSArray*)arguments withDict:(NSDictionary*)options
{
	CGRect imageRect;
	CGRect screenRect = [[UIScreen mainScreen] bounds];

	// statusBarOrientation is more reliable than UIDevice.orientation
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

	if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) { 
		// landscape check
		imageRect = CGRectMake(0, 0, CGRectGetHeight(screenRect), CGRectGetWidth(screenRect));
	} else {
		// portrait check
		imageRect = CGRectMake(0, 0, CGRectGetWidth(screenRect), CGRectGetHeight(screenRect));
	}

	UIGraphicsBeginImageContext(imageRect.size);

	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextTranslateCTM(ctx, 0, 0);
	CGContextFillRect(ctx, imageRect);

	[webView.layer renderInContext:ctx];

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
	UIGraphicsEndImageContext();

	UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil message:@"Image Saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


- (void)saveScreenshotAsFile:(NSArray*)arguments withDict:(NSDictionary*)options
{
	NSUInteger argc = [arguments count];
	NSString* successCallback = nil, *fileName = nil, *returnBase64, *encodedString = @"false";		
    
	if (argc < 2) {
		NSLog(@"Screenshot.saveScreenshotAsFile: Not Enough Parameters.");
		return;
	} else {
        successCallback = [arguments objectAtIndex:0];
		fileName = [arguments objectAtIndex:1];
		returnBase64 = [arguments objectAtIndex:2];
	}
    
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect imageRect = CGRectMake(0, 0, CGRectGetWidth(screenRect), CGRectGetHeight(screenRect));
	UIGraphicsBeginImageContext(imageRect.size);	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextTranslateCTM(ctx, 0, 0);
	CGContextFillRect(ctx, imageRect);	
	[webView.layer renderInContext:ctx];
    
	UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(image1, nil, nil, nil);
    
	if (returnBase64) {
		NSData *imageData = UIImagePNGRepresentation(image1);
		encodedString = [imageData base64EncodedString];
	} else {
		encodedString = @"false";
	}
    
	UIGraphicsEndImageContext();
    
	[UIImagePNGRepresentation(image1) writeToFile:fileName atomically:YES];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:encodedString];
    [self writeJavascript: [pluginResult toSuccessCallbackString:successCallback]];
}

@end