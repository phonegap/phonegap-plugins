#import "SoundPlug.h"

@implementation SoundPlug

- (void) play:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSBundle * mainBundle = [NSBundle mainBundle];
    NSMutableArray *directoryParts = [NSMutableArray arrayWithArray:[(NSString*)[arguments objectAtIndex:0] componentsSeparatedByString:@"/"]];
    NSString       *filename       = [directoryParts lastObject];
    [directoryParts removeLastObject];

    NSMutableArray *filenameParts  = [NSMutableArray arrayWithArray:[filename componentsSeparatedByString:@"."]];
    NSString *directoryStr = [directoryParts componentsJoinedByString:@"/"];

    NSString *filePath = [mainBundle pathForResource:(NSString*)[filenameParts objectAtIndex:0]
                                              ofType:(NSString*)[filenameParts objectAtIndex:1]
                                         inDirectory:directoryStr];

    SystemSoundID soundID;
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];

    AudioServicesCreateSystemSoundID((CFURLRef)fileURL, &soundID);   
    AudioServicesPlaySystemSound(soundID);
}

@end
