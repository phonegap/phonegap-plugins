/**
 * Bundle File Reader Plugin
 * Copyright (c) 2011 Tim Fischbach (github.com/tf)
 * MIT licensed
 */

#ifdef PHONEGAP_FRAMEWORK
    #import <PhoneGap/PGPlugin.h>
#else
    #import "PGPlugin.h"
#endif

@interface BundleFileReader : PGPlugin {
}

- (void)readResource:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
