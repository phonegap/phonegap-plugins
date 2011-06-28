//
//  SMSComposer.h
//
//  Created by Grant Sanders on 12/25/2010.


#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PhoneGapCommand.h>
#else
#import "PhoneGapCommand.h"
#endif
@interface SMSComposer : PhoneGapCommand {
}

- (void)showSMSComposer:(NSArray*)arguments withDict:(NSDictionary*)options;
@end
