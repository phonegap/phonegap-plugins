//
//  ClipboardPlugin.h
//  Clipboard plugin for PhoneGap
//
//  Copyright 2010 Michel Weimerskirch.
//

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif

@interface ClipboardPlugin : PGPlugin{ }

-(void)setText:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

-(void)getText:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
