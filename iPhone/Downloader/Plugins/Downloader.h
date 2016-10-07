/*
 * Copyright (C) 2011 Davide Bertola
 *
 * Authors:
 * Davide Bertola <dade@dadeb.it>
 * Joe Noon <joenoon@gmail.com>
 *
 * This library is available under the terms of the MIT License (2008). 
 * See http://opensource.org/licenses/alphabetical for full text.
 */


#import <Foundation/Foundation.h>

#ifdef PHONEGAP_FRAMEWORK
    #import <PhoneGap/PGPlugin.h>
    #import <PhoneGap/PhoneGapDelegate.h>
#else
    #import "PGPlugin.h"
    #import "PhoneGapDelegate.h"
#endif

@interface Downloader : PGPlugin {
    
}

-(void) downloadFile:(NSMutableArray*)paramArray withDict:(NSMutableDictionary*)options;

@end

