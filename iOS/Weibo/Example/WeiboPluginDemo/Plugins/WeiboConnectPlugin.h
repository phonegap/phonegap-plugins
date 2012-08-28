//
//  WeiboConnectPlugin.h
//
//  Created by Ley Liu on 12-4-13.
//  Copyright (c) 2012年 SINA SAE. All rights reserved.
//  Under the Apache License 2.0.

#import <Cordova/CDV.h>
#import "WBEngine.h"
@interface WeiboConnectPlugin : CDVPlugin<WBEngineDelegate>
@property (nonatomic,retain) WBEngine *weibo;
@property (nonatomic,copy) NSString *loginCallbackId;
@property (nonatomic,copy) NSString *getCallbackId;
@property (nonatomic,copy) NSString *callBackId;
- (void) init:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) login:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
@end
