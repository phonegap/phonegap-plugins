#import "Sleep.h"

@implementation Sleep

- (void)enable:(NSArray*)arguments withDict:(NSDictionary*)options
{
	[ [ UIApplication sharedApplication ] setIdleTimerDisabled:NO ];
}

- (void)disable:(NSArray*)arguments withDict:(NSDictionary*)options
{
	[ [ UIApplication sharedApplication ] setIdleTimerDisabled:YES ];
}

@end
