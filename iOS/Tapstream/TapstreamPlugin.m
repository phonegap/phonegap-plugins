//
//  TapstreamPlugin.m
//  
//  Created by Stephan Bönnemann on 7/1/12.
//  Copyright (c) 2012 Stephan Bönnemann, All rights reserved.
//

#import "TapstreamPlugin.h"
#import "Tapstream/Tapstream.h"

@implementation TapstreamPlugin
	
- (void) fireEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
  
  NSString* eventName = [options valueForKey:@"eventName"];
  bool oneTimeOnly = [[options valueForKey:@"oneTimeOnly"] boolValue];
  
  if (oneTimeOnly) {
    [[Tapstream shared] fireEvent:eventName oneTimeOnly:YES];
  } else {
    [[Tapstream shared] fireEvent:eventName];
  }
  
  //NSLog(@"The fired Tapstream Event = %@", eventName);
    
}

@end
