//
//  AppiraterPlugin.m
//  What To Brew
//
//  Created by James Stuckey Weber on 3/27/12.
//  Copyright (c) 2012 ChinStr.apps, All rights reserved.
//

#import "AppiraterPlugin.h"
#import "Appirater.h"

@implementation AppiraterPlugin
@synthesize callbackID;

- (void) sigEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	[Appirater userDidSignificantEvent:YES];
}

@end
