//
//  Tapstream.h
//  TapstreamSDK
//
//  Created by Benjamin Fox on 12-03-08.
//  Copyright (c) 2012 Paperlabs Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

// The main class used to interact with TapStream.
@interface Tapstream : NSObject {
@private
	NSString *accountName;
	NSString *secret;
	NSMutableSet *blacklist;
	NSMutableSet *blacklistTemp;
	uint _nextUid;
	int _retryDelay;
	uint _failingJob;
}

+ (id)shared;

// The first method that should be called - sets up your account information.
// This method *must* be called before using any other TapStream methods.
- (void)setAccountName:(NSString *)name developerSecret:(NSString *)secret;

// Fires an event with the given name.  This is just shorthand for [Tapstream fireEvent:name oneTimeOnly:NO]
- (void)fireEvent:(NSString *)eventName;

// Fires an event with the given name.  If oneTimeOnly is YES, the sdk will ensure that the
// specified event name is sent to the server only once.  After a successful oneTimeOnly event
// is fired, subsequent attempts to send the same event as one time only will be No-ops.
- (void)fireEvent:(NSString *)eventName oneTimeOnly:(BOOL)once;

@end
