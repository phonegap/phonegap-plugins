//
//  iCloudKV.m
//  Cordova iCloud key-value storage cloud
//  Copyright (c) by Alex Drel 2012

#import "iCloudKV.h"
#ifdef CORDOVA_FRAMEWORK
	#import <Cordova/JSONKit.h>
#else
	#import "JSONKit.h"
#endif

@interface iCloudKV (private)
- (void) cloudNotification:(NSNotification *)receivedNotification;
@end

@implementation iCloudKV

-(void)dealloc
{
    [super dealloc];
}

-(void)sync:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
    NSString* callbackID = [arguments pop];
    
    BOOL success = [[NSUbiquitousKeyValueStore defaultStore] synchronize];

    if (success)
    {
        NSDictionary    *dict = [[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
        NSLog(@"iCloudKV synchronized.");
    }
    else
    {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"synchronize failed"];
        [self writeJavascript: [pluginResult toErrorCallbackString:callbackID]];
        NSLog(@"iCloudKV synchronize failed.");
    }
}

-(void)save:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
    NSString* callbackID = [arguments pop];
    
    NSString *key = [arguments objectAtIndex:0]; 
    NSString *value = [arguments objectAtIndex:1]; 
    
    [[NSUbiquitousKeyValueStore defaultStore] setString:value forKey:key];
    
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];    
}


-(void)load:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
    NSString* callbackID = [arguments pop];

    NSString *key = [arguments objectAtIndex:0]; 
    NSString *value = [[NSUbiquitousKeyValueStore defaultStore] stringForKey:key];
       
    if (value) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
            NSLog(@"iCloudKV loaded string: %@", key);
    }
    else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"key is missing"];
        [self writeJavascript: [pluginResult toErrorCallbackString:callbackID]];
        NSLog(@"iCloudKV load string failed: %@", key);
    }    
}

-(void)remove:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
    NSString* callbackID = [arguments pop];
    
    NSString *key = [arguments objectAtIndex:0]; 
    
    [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:key];
    
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];    
}

-(void)monitor:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
    //The first argument in the arguments parameter is the callbackID.
    //We use this to send data back to the successCallback or failureCallback
    //through CDVPluginResult.   
    NSString* callbackID = [arguments pop];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(cloudNotification:)
                                             name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification 
                                             object:[NSUbiquitousKeyValueStore defaultStore]];
            
    NSLog(@"iCloudKV registered for notification");
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
}


- (void)cloudNotification:(NSNotification *)receivedNotification
{
    NSLog(@"iCloudKV: cloudData notification");

    int cause=[[[receivedNotification userInfo] valueForKey:NSUbiquitousKeyValueStoreChangeReasonKey] intValue];
    
    switch(cause) {
        case NSUbiquitousKeyValueStoreQuotaViolationChange:
            NSLog(@"iCloudKV storage quota exceeded.");
            break;
        case NSUbiquitousKeyValueStoreInitialSyncChange:
            NSLog(@"iCloudKV initial sync notification.");
            break;
        case NSUbiquitousKeyValueStoreServerChange:
            NSLog(@"iCloudKV server change notification.");
            NSDictionary    *changedKeys   = [[receivedNotification userInfo] valueForKey:NSUbiquitousKeyValueStoreChangedKeysKey];

	        NSString *jsStatement = [NSString stringWithFormat:@"iCloudKV.onChange(%@);",  [changedKeys JSONString]];
	        [self writeJavascript:jsStatement];
            break;
    }
}


@end