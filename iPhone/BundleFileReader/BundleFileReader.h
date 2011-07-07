/**
 * @author Tim Fischbach <tfischbach@codevise.de>
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
