//
//  applicationPreferences.m
//  
//
//  Created by Tue Topholm on 31/01/11.
//  Copyright 2011 Sugee. All rights reserved.
//
// THIS HAVEN'T BEEN TESTED WITH CHILD PANELS YET.

#import "applicationPreferences.h"


@implementation applicationPreferences
- (void)getSetting:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	NSUInteger argc = [arguments count];
	NSString* jsString;
	if(argc == 3)
	{
	
		NSString *settingsName = [arguments objectAtIndex:0];
		NSString *successCallback = [arguments objectAtIndex:1];
		NSString *failCallback = [arguments objectAtIndex:2];
	
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
			
			jsString = [NSString stringWithFormat:@"%@(\"%@\");",successCallback,returnVar];
					
		}
		@catch (NSException * e) 
		{
			jsString = [NSString stringWithFormat:@"%@(\"%@\");",failCallback,[e reason]];
		}
		@finally 
		{
			[self writeJavascript:jsString]; //Write back to JS
		}
	}
}

- (void)setSetting:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{

	NSUInteger argc = [arguments count];
	NSString* jsString;
	if(argc == 4)
	{
		
		NSString *settingsName = [arguments objectAtIndex:0];
		NSString *settingsValue = [arguments objectAtIndex:1];
		NSString *successCallback = [arguments objectAtIndex:2];
		NSString *failCallback = [arguments objectAtIndex:3];
		
		@try 
		{
			[[NSUserDefaults standardUserDefaults] setValue:settingsValue forKey:settingsName];
			jsString = [NSString stringWithFormat:@"%@();",successCallback];
			
		}
		@catch (NSException * e) 
		{
			jsString = [NSString stringWithFormat:@"%@(\"%@\");",failCallback,[e reason]];
		}
		@finally 
		{
			[self writeJavascript:jsString];
		}
	}
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
