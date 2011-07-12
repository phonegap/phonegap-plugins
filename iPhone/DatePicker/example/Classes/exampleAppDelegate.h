//
//  exampleAppDelegate.h
//  example
//
//  Created by Gregamel on 4/3/11.
//  Copyright Boeing 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PhoneGapDelegate.h>
#else
#import "PhoneGapDelegate.h"
#endif


@interface exampleAppDelegate : PhoneGapDelegate {
}

@end

