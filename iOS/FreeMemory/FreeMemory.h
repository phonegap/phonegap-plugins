#import <Cordova/CDV.h>

@interface FreeMemory : CDVPlugin

- (void) getFreeMemory:(CDVInvokedUrlCommand*)command;

@end