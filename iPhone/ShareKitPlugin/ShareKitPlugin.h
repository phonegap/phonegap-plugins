//
//  ShareKitPlugin.h
//  
//
//  Created by Erick Camacho on 28/07/11.
//  MIT Licensed
//

#import <Foundation/Foundation.h>

#import "SHK.h"
#import "SHKSharer+Phonegap.h"
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#import <PhoneGap/PluginResult.h>
#import <PhoneGap/SBJSON.h>

#else
#import "PGPlugin.h"
#import "PluginResult.h"
#import "SBJSON.h"
#endif



@interface ShareKitPlugin : PGPlugin {

    
}


- (void)share:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)isLoggedToTwitter:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)isLoggedToFacebook:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)logoutFromTwitter:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)logoutFromFacebook:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)facebookConnect:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)shareToFacebook:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)shareToTwitter:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)shareToMail:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
