#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif

@interface Screenshot : CDVPlugin {
}
 - (void)saveScreenshot:(CDVInvokedUrlCommand*)command;
//- (void)saveScreenshot:(NSArray*)arguments withDict:(NSDictionary*)options;

@end
