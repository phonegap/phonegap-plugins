//
//  Sleep.h
//  Sleep plugin for PhoneGap
//
//  Created by Volcano on 10-07-12.
//

#import <Foundation/Foundation.h>
#import "PhoneGapCommand.h"

@interface Sleep : PhoneGapCommand {
}

- (void) enable:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void) disable:(NSArray*)arguments withDict:(NSDictionary*)options;

@end
