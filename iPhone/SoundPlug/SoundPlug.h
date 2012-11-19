#import <AudioToolbox/AudioServices.h>
#import <Cordova/CDVPlugin.h>

@interface SoundPlug : CDVPlugin {
}

- (void) play:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
