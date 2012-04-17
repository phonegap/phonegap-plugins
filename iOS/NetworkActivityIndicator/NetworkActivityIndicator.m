//
//  NetworkActivityIndicator.m
//  
//
//  Created by Tue Topholm on 16/03/11.
//  Copyright 2011 Sugee. All rights reserved.
//

#import "NetworkActivityIndicator.h"

@implementation NetworkActivityIndicator

- (void)setIndicator:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
	
	UIApplication* app = [UIApplication sharedApplication];
	
	NSString *boolValue = [arguments objectAtIndex:0];		

	if ([boolValue isEqualToString:@"false"]) {
		app.networkActivityIndicatorVisible = NO;
	} else {
		app.networkActivityIndicatorVisible = YES;
	}
}

@end
