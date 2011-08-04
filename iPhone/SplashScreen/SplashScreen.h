//
//  SplashScreen.h
//
//  Created by André Fiedler on 07.01.11.
//  Copyright 2011 André Fiedler, <fiedler.andre at gmail dot com>
//  MIT licensed
//

#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif


@interface SplashScreen : PGPlugin {
	IBOutlet UIImageView *imageView;
}
- (void)createSplashScreen:(NSString*)imageName : (NSString*)imageType;
- (void)show:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hide:(NSArray*)arguments withDict:(NSDictionary*)options;
@end