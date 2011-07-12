/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 * 
 * Copyright (c) 2005-2010, Nitobi Software Inc.
 */


#import "Movie.h"
#import <AudioToolbox/AudioServices.h>
#import <MediaPlayer/MediaPlayer.h>


@implementation PGMovie

@synthesize theMovie,stopReceived,repeat;

- (PGPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (PGMovie*)[super initWithWebView:(UIWebView*)theWebView];
    if (self) {
        stopReceived = false;
        repeat = false;
    }
	return self;
}


- (void) play:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSBundle * mainBundle = [NSBundle mainBundle];
    NSMutableArray *directoryParts = [NSMutableArray arrayWithArray:[(NSString*)[arguments objectAtIndex:0] componentsSeparatedByString:@"/"]];
    NSString       *filename       = [directoryParts lastObject];
    [directoryParts removeLastObject];
    
    NSMutableArray *filenameParts  = [NSMutableArray arrayWithArray:[filename componentsSeparatedByString:@"."]];
    NSString *directoryStr = [directoryParts componentsJoinedByString:@"/"];
    
    NSString *filePath = [mainBundle pathForResource:(NSString*)[filenameParts objectAtIndex:0]
                                              ofType:(NSString*)[filenameParts objectAtIndex:1]
                                         inDirectory:directoryStr];
    if (filePath == nil) {
        filePath = [mainBundle pathForResource:(NSString*)[filenameParts objectAtIndex:0]
                                              ofType:(NSString*)[filenameParts objectAtIndex:1]];
        if (filePath == nil) {
        
            NSLog(@"Can't find filename %@ in the app bundle", [arguments objectAtIndex:0]);
            return;
        }
    }
    // TODO Create a system facilitating handling callback responses in JavaScript easily, and no
    // longer in an ad-hoc fashion.  Getting error results of whether or not the Movie played, or
    // other errors occurring in the system is important.

    OSStatus error = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
	if (error) {
        NSLog(@"ERROR INITIALIZING AUDIO SESSION! %d\n", error);
        return;
    }

    UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;    
    AudioSessionSetProperty ( kAudioSessionProperty_AudioCategory, sizeof (sessionCategory), &sessionCategory );
    
    error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, self);
    if (error) {
        NSLog(@"ERROR Adding Property Listener %d\n", error);
        return;
    }

//	AudioSessionSetActive (true); 
    
    theMovie = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL fileURLWithPath: filePath]]; 
    NSLog(@"theMovie description = %@", [(NSObject *)theMovie description]);
   
    //[theMovie setOrientation:UIDeviceOrientationPortrait animated:NO]; // TODO: remove? no such selector

	theMovie.scalingMode = MPMovieScalingModeAspectFill; 
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_3_2
	theMovie.movieControlMode = MPMovieControlModeDefault;	
#endif

    // Register for the playback finished notification. 
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(myMovieFinishedCallback:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:theMovie]; 
	
    // Movie playback is asynchronous, so this method returns immediately. 
	[theMovie play]; 
} 

- (void) stop:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  {
    
    NSLog(@"Stop the movie!");
    stopReceived = true;
    NSLog(@"theMovie description = %@", [(NSObject *)theMovie description]);
    
    [theMovie stop];   
    
    NSLog(@"Finished stopping the movie.");
}

#pragma mark AudioSession listeners

void interruptionListener (
   void     *inClientData,
   UInt32   inInterruptionState
)
{
    if (inInterruptionState == kAudioSessionBeginInterruption) {}
    NSLog(@"Movie: interruptionListener");

}

void propListener(	void *                  inClientData,
					AudioSessionPropertyID	inID,
					UInt32                  inDataSize,
					const void *            inData)
{
    NSLog(@"Movie: audio prop Listener");
}


- (void) myMovieFinishedCallback:(NSNotification*)aNotification 
{
    NSLog(@"myMovieFinishedCallback");
    MPMoviePlayerController* myMovie = [aNotification object]; 
    NSLog(@"myMovie description = %@, theMovie description = %@, stopReceived = %d", [(NSObject *)myMovie description], theMovie, stopReceived);
	
    if(stopReceived) {
       [theMovie stop];   
       [[NSNotificationCenter defaultCenter] removeObserver:self 
                                             name:MPMoviePlayerPlaybackDidFinishNotification 
                                             object:myMovie]; 
    } 
	
	if(repeat) {
      [myMovie play]; 
    }
}

- (void) dealloc
{
	[theMovie release];
	[super dealloc];
}

@end
