//
//  networkActivityIndicator.h
//  
//
//  Created by Tue Topholm on 16/03/11.
//  Copyright 2011 Sugee. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif

@interface networkActivityIndicator : PGPlugin {}
-	(void) setIndicator:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
