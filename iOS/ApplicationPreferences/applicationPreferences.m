//
//  applicationPreferences.m
//  
//  Updated to Cordova 3.0 compatibility on 09/19/2013
//
//  Created by Tue Topholm on 31/01/11.
//  Copyright 2011 Sugee. All rights reserved.
//
// THIS HAVEN'T BEEN TESTED WITH CHILD PANELS YET.

#import "applicationPreferences.h"
#import <Cordova/CDV.h>


@implementation applicationPreferences

- (void) getSetting:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        NSString *settingsName = [command.arguments objectAtIndex:0];
        CDVPluginResult* pluginResult = nil;

        @try 
        {
            //At the moment we only return strings
            //bool: true = 1, false=0
            NSString *returnVar = [[NSUserDefaults standardUserDefaults] stringForKey:settingsName];
            if(returnVar == nil)
            {
                returnVar = [self getSettingFromBundle:settingsName]; //Parsing Root.plist
                
                if (returnVar == nil) 
                    @throw [NSException exceptionWithName:nil reason:@"Key not found" userInfo:nil];;
            }
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:returnVar];
        }
        @catch (NSException * e) 
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[e reason]];
        }
        @finally
        {
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

- (void)setSetting:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSString *settingsName = [command.arguments objectAtIndex:0];
        NSString *settingsValue = [command.arguments objectAtIndex:1];

            
        @try 
        {
            [[NSUserDefaults standardUserDefaults] setValue:settingsValue forKey:settingsName];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                
        }
        @catch (NSException * e) 
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[e reason]];
        }
        @finally
        {
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}
/*
  Parsing the Root.plist for the key, because there is a bug/feature in Settings.bundle
  So if the user haven't entered the Settings for the app, the default values aren't accessible through NSUserDefaults.
*/


- (NSString*)getSettingFromBundle:(NSString*)settingsName
{
	NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
	NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
	
	NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
	NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
	NSDictionary *prefItem;
	for (prefItem in prefSpecifierArray)
	{
		if ([[prefItem objectForKey:@"Key"] isEqualToString:settingsName])
			return [prefItem objectForKey:@"DefaultValue"];
	}
	return nil;
	
}
@end
