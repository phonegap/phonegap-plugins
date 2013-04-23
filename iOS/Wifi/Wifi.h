#import <Cordova/CDV.h>

@interface Wifi : CDVPlugin

- (void) getSSID:(CDVInvokedUrlCommand*)command;

@end