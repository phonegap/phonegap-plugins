/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 * 
 * Copyright (c) 2005-2010, Nitobi Software Inc.
 */

#import "PGPlugin.h"
#import <AudioToolbox/AudioServices.h>
#import <MediaPlayer/MediaPlayer.h>


@interface PGMovie : PGPlugin {
    BOOL stopReceived;
    BOOL repeat;
    MPMoviePlayerController	*theMovie;
}

- (void) play:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) stop:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

void propListener (
   void                      *inClientData,
   AudioSessionPropertyID    inID,
   UInt32                    inDataSize,
   const void                *inData
);

void interruptionListener (
   void     *inClientData,
   UInt32   inInterruptionState
);

@property (nonatomic, retain ) MPMoviePlayerController	*theMovie;
@property (nonatomic ) BOOL stopReceived;
@property (nonatomic ) BOOL repeat;

@end
