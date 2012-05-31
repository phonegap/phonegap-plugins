//  iCloudKV.h
//  Copyright (c) by Alex Drel 2012

#import <Foundation/Foundation.h>
#import <CORDOVA/CDVPlugin.h>

@interface iCloudKV : CDVPlugin 
{    
}

- (void)sync:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)save:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)load:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)remove:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)monitor:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
@end