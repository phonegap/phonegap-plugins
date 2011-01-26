//
//  SMSComposer.h
//
//  Created by Grant Sanders on 12/25/2010.


#import <Foundation/Foundation.h>
#import "PhoneGapCommand.h"
@interface SMSComposer : PhoneGapCommand {
}

- (void)showSMSComposer:(NSArray*)arguments withDict:(NSDictionary*)options;
@end
