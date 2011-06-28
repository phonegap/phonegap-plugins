//
//  SplashScreen.h
//
//  Created by André Fiedler on 07.01.11.
//  Copyright 2011 André Fiedler, <fiedler.andre at gmail dot com>
//  MIT licensed
//

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PhoneGapCommand.h>
#else
#import "PhoneGapCommand.h"
#endif

@interface SplashScreen : PhoneGapCommand {
	IBOutlet UIImageView *imageView;
}
- (void)createSplashScreen;
- (void)show:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hide:(NSArray*)arguments withDict:(NSDictionary*)options;
@end