//
//  networkActivityIndicator.m
//  
//
//  Created by Tue Topholm on 16/03/11.
//  Copyright 2011 Sugee. All rights reserved.
//

#import "networkActivityIndicator.h"


@implementation networkActivityIndicator
- (void)setIndicator:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
	NSUInteger argc = [arguments count];
	
	
	if(argc == 3)
	{
		NSString *jsString = nil;
		UIApplication* app = [UIApplication sharedApplication];
		
		NSString *boolValue = [arguments objectAtIndex:0];
		NSString *successCallback = [arguments objectAtIndex:1];
		NSString *failCallback = [arguments objectAtIndex:2];		
		
		@try 
		{
			
			if ([boolValue isEqualToString:@"false"]) 
					app.networkActivityIndicatorVisible = NO;
			else
				 app.networkActivityIndicatorVisible = YES;
			jsString = [NSString stringWithFormat:@"%@();",successCallback];
		}
		@catch (NSException * e) 
		{
			jsString = [NSString stringWithFormat:@"%@(\"%@\");",failCallback,[e reason]];
		}
		@finally 
		{
			[self writeJavascript: jsString];
		}

	}
}

@end
