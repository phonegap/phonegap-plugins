//
//  localizable.h
//  
//
//  Created by Tue Topholm on 13/02/11.
//  Copyright 2011 Sugee. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif

@interface localizable : PGPlugin {}
-	(void) get:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
@end
