//
//  ExtractZipFilePlugin.h
//
//  Created by Shaun Rowe on 10/05/2012.
//  Copyright (c) 2012 Pobl Creative Cyf. All rights reserved.
//

#import <Cordova/CDVPlugin.h>
#import "SSZipArchive.h"

@interface ExtractZipFilePlugin : CDVPlugin
{
    NSString *callbackID;
}

@property (nonatomic, copy) NSString* callbackID;

- (void)extract:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
