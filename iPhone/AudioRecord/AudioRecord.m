//
//  AudioRecord.m
//
//  By Lyle Pratt, September 2011.
//  MIT licensed
//

#import "AudioRecord.h"

@implementation AudioRecord

- (void) startAudioRecord:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
	NSString* callbackId = [arguments objectAtIndex:0];
#pragma unused(callbackId)
	
	NSString* mediaId = [arguments objectAtIndex:1];
    
    //Use Super's audio file.
	CDVAudioFile* audioFile = [super audioFileForResource:[arguments objectAtIndex:2] withId: mediaId];
    NSString* jsString = nil;
    
    NSString* FormatIDString = [options objectForKey:@"FormatID"];
    
    //Default is LinearPCM
    NSNumber* FormatID = [NSNumber numberWithInt:kAudioFormatLinearPCM];
    
    if(FormatIDString == @"kAudioFormatLinearPCM") {
        FormatID = [NSNumber numberWithInt:kAudioFormatLinearPCM];
    }
    else if(FormatIDString == @"kAudioFormatAppleLossless") {
        FormatID = [NSNumber numberWithInt:kAudioFormatAppleLossless];
    }
    else if(FormatIDString == @"kAudioFormatAppleIMA4") {
        FormatID = [NSNumber numberWithInt:kAudioFormatAppleIMA4];
    }
    else if(FormatIDString == @"kAudioFormatiLBC") {
        FormatID = [NSNumber numberWithInt:kAudioFormatiLBC];
    }
    else if(FormatIDString == @"kAudioFormatULaw") {
        FormatID = [NSNumber numberWithInt:kAudioFormatULaw];
    }
    else if(FormatIDString == @"kAudioFormatALaw") {
        FormatID = [NSNumber numberWithInt:kAudioFormatALaw];
    }
    
    
    NSNumber* SampleRate = [options objectForKey:@"SampleRate"];
    NSNumber* NumberOfChannels = [options objectForKey:@"NumberOfChannels"];
    NSNumber* LinearPCMBitDepth = [options objectForKey:@"LinearPCMBitDepth"];
    
	if (audioFile != nil) {
		
		NSError* error = nil;

		if (audioFile.recorder != nil) {
			[audioFile.recorder stop];
			audioFile.recorder = nil;
		}
        
        NSDictionary* recorderSettingsDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                        FormatID,AVFormatIDKey,
                        SampleRate,AVSampleRateKey,
                        NumberOfChannels,AVNumberOfChannelsKey,
                        LinearPCMBitDepth,AVLinearPCMBitDepthKey,
                        [NSNumber numberWithInt:0],AVLinearPCMIsBigEndianKey,
                        [NSNumber numberWithInt:0],AVLinearPCMIsFloatKey,
                        nil];
        
        
		// create a new recorder for each start record
		audioFile.recorder = [[CDVAudioRecorder alloc] initWithURL:audioFile.resourceURL settings:recorderSettingsDict error:&error];
	
		if (error != nil) {
			NSLog(@"Failed to initialize AVAudioRecorder: %@\n", error);
			audioFile.recorder = nil;
			jsString = [NSString stringWithFormat: @"%@(\"%@\",%d,%d);", @"Cordova.Media.onStatus", mediaId, MEDIA_ERROR, MEDIA_ERR_ABORTED];
			
		} else {
			audioFile.recorder.delegate = self;
			audioFile.recorder.mediaId = mediaId;
			[audioFile.recorder record];
			NSLog(@"Started recording audio sample '%@'", audioFile.resourcePath);
            jsString = [NSString stringWithFormat: @"%@(\"%@\",%d,%d);", @"Cordova.Media.onStatus", mediaId, MEDIA_STATE, MEDIA_RUNNING];
		}
	}
    if (jsString) {
       [super writeJavascript:jsString]; 
    }
	return;
}

- (void) stopAudioRecord:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
	NSString* callbackId = [arguments objectAtIndex:0];
#pragma unused(callbackId)
	NSString* mediaId = [arguments objectAtIndex:1];

    //Use Super's soundCache
	CDVAudioFile* audioFile = [super audioFileForResource:[arguments objectAtIndex:2] withId:mediaId];
    NSString* jsString = nil;
	
	if (audioFile != nil && audioFile.recorder != nil) {
		NSLog(@"Stopped recording audio sample '%@'", audioFile.resourcePath);
		[audioFile.recorder stop];
        jsString = [NSString stringWithFormat: @"%@(\"%@\",%d,%d);", @"Cordova.Media.onStatus", mediaId, MEDIA_STATE, MEDIA_STOPPED];
	} else {
        jsString = [NSString stringWithFormat: @"%@(\"%@\",%d,%d);", @"Cordova.Media.onStatus", mediaId, MEDIA_ERROR, MEDIA_NONE];
    }
    if (jsString) {
        [super writeJavascript:jsString]; 
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder*)recorder successfully:(BOOL)flag {

	CDVAudioRecorder* aRecorder = (CDVAudioRecorder*)recorder;
	NSString* mediaId = aRecorder.mediaId;
    
    //Use Super's soundCache
	CDVAudioFile* audioFile = [[super soundCache] objectForKey: [aRecorder.url path]]; //mediaId];
	NSString* jsString = nil;

	
	if (audioFile != nil) {
		NSLog(@"Finished recording audio sample '%@'", audioFile.resourcePath);
		if (flag){
			jsString = [NSString stringWithFormat: @"%@(\"%@\",%d,%d);", @"Cordova.Media.onStatus", mediaId, MEDIA_STATE, MEDIA_STOPPED];
		} else {
			jsString = [NSString stringWithFormat: @"%@(\"%@\",%d,%d);", @"Cordova.Media.onStatus", mediaId, MEDIA_ERROR, MEDIA_ERR_DECODE];
		}
		[super writeJavascript:jsString];
	}
}

@end
