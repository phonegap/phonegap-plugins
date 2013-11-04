#import "Wifi.h"
#import <Cordova/CDV.h>
#import <SystemConfiguration/CaptiveNetwork.h>


@implementation Wifi
- (NSString *)currentWifiSSID {
    // Does not work on the simulator.
    NSString *ssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
        }
    }
    return ssid;
}



- (void) getSSID:(CDVInvokedUrlCommand*)command{
    CDVPluginResult* pluginResult = nil;
    NSString* ssid = [self currentWifiSSID];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:ssid];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
