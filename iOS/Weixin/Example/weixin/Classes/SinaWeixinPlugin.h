//
//  SinaWeixinPlugin.h
//  weixin
//
//  Created by Ley Liu on 12-5-22.
//  Copyright (c) 2012年 SINA SAE. All rights reserved.
//

#import <Cordova/CDV.h>
#import "WXApi.h"
@interface SinaWeixinPlugin : CDVPlugin<WXApiDelegate>
@property(nonatomic, copy) NSString *callBackId;
@property(nonatomic, copy) NSString *responser;
@property(nonatomic) BOOL isRegisted;
@end
