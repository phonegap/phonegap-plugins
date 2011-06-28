//
//  ClipboardPlugin.h
//  Clipboard plugin for PhoneGap
//
//  Copyright 2010 Michel Weimerskirch.
//

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PhoneGapCommand.h>
#else
#import "PhoneGapCommand.h"
#endif

@interface ClipboardPlugin : PhoneGapCommand{ }

-(void)setText:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
