//
//  localizable.m
//  
//
//  Created by Tue Topholm on 13/02/11.
//  Copyright 2011 Sugee. All rights reserved.
//

#import "localizable.h"


@implementation localizable
- (void)get:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	NSUInteger argc = [arguments count];
	NSString* jsString;
	if(argc == 2)
	{
		NSString *key = [arguments objectAtIndex:0];
		NSString *successCallback = [arguments objectAtIndex:1];

		NSString *returnVar = NSLocalizedString(key, nil);

		jsString = [NSString stringWithFormat:@"%@(\"%@\");",successCallback,returnVar];

		[self writeJavascript:jsString]; //Write back to JS
	}	
	
}
@end
