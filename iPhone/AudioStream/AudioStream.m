//
//  AudioStream.m
//  AudioStreamer PhoneGap Plugin
//
//  Created by Tommy-Carlos Williams on 20/07/11.
//  Copyright 2011 Devgeeks. All rights reserved.
//
//  Borrowing heavily from the iPhoneStreamingPlayerViewController from 
//      Matt Gallagher's AudioStreamer sample application that goes with his 
//      AudioStreamer Classes this plugin is implementing

#import "AudioStream.h"
#import "AudioStreamer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>

@implementation AudioStream

@synthesize successCallback, failCallback, status, streamUrl;

#pragma mark creation and destruction
//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:ASStatusChangedNotification
                                                      object:streamer];
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
		
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
	if (streamer)
	{
		return;
	}
    
	[self destroyStreamer];
	
	NSString *escapedValue = [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                  nil,
                                                                                  (CFStringRef)streamUrl,
                                                                                  NULL,
                                                                                  NULL,
                                                                                  kCFStringEncodingUTF8)
                              autorelease];
	
	NSURL *url = [NSURL URLWithString:escapedValue];
    
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	progressUpdateTimer = [NSTimer
                           scheduledTimerWithTimeInterval:0.1
                           target:self
                           selector:@selector(updateProgress:)
                           userInfo:nil
                           repeats:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged:)
                                                 name:ASStatusChangedNotification
                                               object:streamer];
}

#pragma mark playback controls

#if __IPHONE_4_0
// Override canBecomeFirstResponder to receieve remote control events
-(BOOL)canBecomeFirstResponder 
{
	return YES;
}

// Process remote control events
-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
			if ([[self status] isEqualToString:@"isPlaying"]) {
                [self destroyStreamer];
            } else {
                if (streamUrl) {
                    [self createStreamer];
                    [streamer start];
                }
            }
            // otherwise, just ignore it, really...
			break;
		default:
			break;
	}
}
#endif
//
// buttonPressed:
//
// Parameters: 
//      streamUrl - url to stream
//
- (void) play:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSUInteger argc = [arguments count];
	
	if (argc < 2) { // at a minimum we need a url and a success callback
		return;	
	}
    
    [self setStreamUrl:[arguments objectAtIndex:0]];
    
    if (argc > 1) {
        self.successCallback = [arguments objectAtIndex:1];
    }
    
	if (argc > 2) {
		self.failCallback = [arguments objectAtIndex:0];	
	}
    
    [self createStreamer];
    [streamer start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString* jsCallBack = [[[NSString alloc] initWithString:@"window.plugins.AudioStream.loading = true;"] autorelease];
    [self writeJavascript: jsCallBack];
}

- (void)stop:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    [self destroyStreamer];
}

#pragma mark state callbacks
//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{    
	if ([streamer isWaiting])
	{
		[self setStatus:@"isWaiting"];
	}
	else if ([streamer isPlaying])
	{
		[self setStatus:@"isPlaying"];
	}
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
		[self setStatus:@"isPlaying"];
	}
    
	NSString* jsCallBack = [NSString stringWithFormat:@"%@(\"%@\");", self.successCallback, status];
    [self writeJavascript: jsCallBack];

}


//
// updateProgress:
//
// Invoked when the AudioStreamer
// reports that its playback progress has changed.
//
- (void)updateProgress:(NSTimer *)updatedTimer
{
    NSString* progressString = [[[NSString alloc] initWithString:@""] autorelease];
    
	if (streamer.bitRate != 0.0)
	{
		double progress = streamer.progress;
		double duration = streamer.duration;

		if (duration > 0)
		{
			progressString = [NSString stringWithFormat:@"Time Played: %.1f/%.1f seconds",
                              progress,
                              duration];
		}
	}
    
    NSString* jsCallBack = [NSString stringWithFormat:@"window.plugins.AudioStream.updateProgress('%@');", progressString];
    [self writeJavascript: jsCallBack];
}

#pragma mark dealloc and cleanup
//
// dealloc
//
// Releases instance memory.
//
- (void)dealloc
{
	[self destroyStreamer];
    
	if (progressUpdateTimer)
	{
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
	}
    
    [status release];
    status = nil;
    
    [successCallback release];
    successCallback = nil;
    
    [failCallback release];
    failCallback = nil;
	
    [super dealloc];
}


@end
