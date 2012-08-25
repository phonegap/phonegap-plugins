//
//  Diagnostic.m
//  Plugin diagnostic
//
//  Copyright (c) 2012 AVANTIC ESTUDIO DE INGENIEROS
//

#import "Diagnostic.h"
#import <CoreLocation/CoreLocation.h>

#import <arpa/inet.h> // For AF_INET, etc.
#import <ifaddrs.h> // For getifaddrs()
#import <net/if.h> // For IFF_LOOPBACK

@implementation Diagnostic


- (void) isLocationEnabled: (NSMutableArray*)arguments withDict:(NSMutableDictionary*) options
{
    NSString * callbackId = [arguments objectAtIndex:0];
    NSLog(@"Loading Location status...");
    CDVPluginResult* pluginResult;
    if([self isLocationEnabled] && [self isLocationAuthorized])
    {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:1];
        
    }
    else {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:0];
                
    }
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];

}

- (void) isLocationEnabledSetting: (NSMutableArray*)arguments withDict:(NSMutableDictionary*) options
{
    NSString * callbackId = [arguments objectAtIndex:0];
    NSLog(@"Loading Location status...");
    CDVPluginResult* pluginResult;
    if([self isLocationEnabled])
    {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:1];
        
    }
    else {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:0];
        
    }
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
    
}

- (void) isLocationAuthorized: (NSMutableArray*)arguments withDict:(NSMutableDictionary*) options
{
    NSString * callbackId = [arguments objectAtIndex:0];
    NSLog(@"Loading Location authentication...");
    CDVPluginResult* pluginResult;
    if([self isLocationAuthorized])
    {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:1];
        
    }
    else {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:0];
        
    }
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
    
}

- (BOOL) isLocationEnabled
{

    if([CLLocationManager locationServicesEnabled])
    {
        NSLog(@"Location is enabled.");
        return true;
    }
    else {
        NSLog(@"Location is disabled.");
        return false;
    }
    

}

- (BOOL) isLocationAuthorized
{

    if([CLLocationManager  authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        NSLog(@"This app is authorized to use location.");
        return true;
    }
    else {
        NSLog(@"This app is not authorized to use location.");
        return false;
    }

}


- (void) isWifiEnabled: (NSMutableArray*)arguments withDict:(NSMutableDictionary*) options
{
    NSString * callbackId = [arguments objectAtIndex:0];
    NSLog(@"Loading WiFi status...");
    CDVPluginResult* pluginResult;
    if([self connectedToWifi])
    {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:1];
        
    }
    else {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:0];
    
    }
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];

}

- (BOOL) connectedToWifi  // Don't work on iOS Simulator, only in the device
{    
    struct ifaddrs *addresses;
    struct ifaddrs *cursor;
    BOOL wiFiAvailable = NO;
    
    if (getifaddrs(&addresses) != 0) 
    {
        return NO;
    }
    
    cursor = addresses;
    
    while (cursor != NULL) 
    {
        if (cursor -> ifa_addr -> sa_family == AF_INET && !(cursor -> ifa_flags & IFF_LOOPBACK)) // Ignore the loopback address
        {
            // Check for WiFi adapter
            
            if (strcmp(cursor -> ifa_name, "en0") == 0) {
                
                NSLog(@"Wifi ON");
                wiFiAvailable = YES;
                break;
                
            }
            
        }
        
        cursor = cursor -> ifa_next;
    }
    
    freeifaddrs(addresses);
    return wiFiAvailable;
}

- (void) isCameraEnabled: (NSMutableArray*)arguments withDict:(NSMutableDictionary*) options
{
    NSString * callbackId = [arguments objectAtIndex:0];
    NSLog(@"Loading camera status...");
    CDVPluginResult* pluginResult;
    if([self isCameraEnabled])
    {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:1];
        
    }
    else 
    {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:0];
        
    }
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
    
}


- (BOOL) isCameraEnabled
{

    BOOL cameraAvailable = 
    [UIImagePickerController 
     isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if(cameraAvailable)
    {
        NSLog(@"Camera enabled");
        return true;
    }
    else 
    {
        NSLog(@"Camera disabled");
        return false;
    }

}



@end
