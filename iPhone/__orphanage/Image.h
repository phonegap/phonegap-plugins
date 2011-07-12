/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 * 
 * Copyright (c) 2005-2010, Nitobi Software Inc.
 */


#import <Foundation/Foundation.h>
#import "PGPlugin.h"

@interface PGImage : PGPlugin {
	IBOutlet UIWindow *window;
	
	UIImagePickerController *picker;	// added by urbian
	NSString *photoUploadUrl;			// added by urbian
	NSString *lastUploadedPhoto;		// added by urbian
	NSURLConnection *conn;				// added by urbian
	NSMutableData *receivedData;		// added by urbian	

}

@property (nonatomic, retain) UIImagePickerController *picker;
@property (nonatomic, retain) UIWindow *window;

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image2 editingInfo:(NSDictionary *)editingInfo;
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker;

@end
