//
//  ClipboardPlugin.h
//  Clipboard plugin for PhoneGap
//
//  Copyright 2010 Michel Weimerskirch.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface ClipboardPlugin : CDVPlugin{ }

-(void)setText:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

-(void)getText:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
