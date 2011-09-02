//
//  AudioEncode.m
//
//  By Lyle Pratt, September 2011.
//  MIT licensed
//

#import "AudioEncode.h"

@implementation AudioEncode

@synthesize successCallback, failCallback;

- (void)encodeAudio:(NSArray*)arguments withDict:(NSDictionary*)options
{
    self.successCallback = [[arguments objectAtIndex:1] retain];
    self.failCallback = [[arguments objectAtIndex:2] retain];
	NSString* audioPath = [arguments objectAtIndex:0];
    
	NSURL* audioURL = [NSURL fileURLWithPath:audioPath];
	AVURLAsset* audioAsset = [[AVURLAsset alloc] initWithURL:audioURL options:nil];
    AVAssetExportSession* exportSession = [[AVAssetExportSession alloc] initWithAsset:audioAsset presetName:AVAssetExportPresetAppleM4A];
	
	NSURL* exportURL = [NSURL fileURLWithPath:[[audioPath componentsSeparatedByString:@".wav"] objectAtIndex:0]];
	NSURL* destinationURL = [exportURL URLByAppendingPathExtension:@"m4a"];

    exportSession.outputURL = destinationURL;
	exportSession.outputFileType = AVFileTypeAppleM4A;
	
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
    
        if (AVAssetExportSessionStatusCompleted == exportSession.status) {
            NSLog(@"AVAssetExportSessionStatusCompleted");
            [self performSelectorOnMainThread:@selector(doSuccessCallback:) withObject:[exportSession.outputURL path] waitUntilDone:NO];
        } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
            // a failure may happen because of an event out of your control
            // for example, an interruption like a phone call comming in
            // make sure and handle this case appropriately
            NSLog(@"AVAssetExportSessionStatusFailed");
            [self performSelectorOnMainThread:@selector(doFailCallback:) withObject:[NSString stringWithFormat:@"%i", exportSession.status] waitUntilDone:NO];
            
        } else {
            NSLog(@"Export Session Status: %d", exportSession.status);
        }
        
        [exportSession release];
    }];
    
	
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *error = noErr;
	if ([fileMgr removeItemAtPath:audioPath error:&error] != YES) {
		NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    }
    
}



-(void) doSuccessCallback:(NSString*)path {
    NSLog(@"doing success callback");
    NSString* jsCallback = [NSString stringWithFormat:@"%@(\"%@\");", self.successCallback, path];
    [self writeJavascript: jsCallback];
    [self.successCallback release];
}

-(void) doFailCallback:(NSString*)status {
    NSLog(@"doing fail callback");
    NSString* jsCallback = [NSString stringWithFormat:@"%@(\"%@\");", self.failCallback, status];
    [self writeJavascript: jsCallback];
    [self.failCallback release];
}

@end
