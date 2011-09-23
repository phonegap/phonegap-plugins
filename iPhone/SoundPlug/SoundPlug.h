#import <AudioToolbox/AudioServices.h>
#import "PGPlugin.h"

@interface SoundPlug : PGPlugin {
}

- (void) play:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
