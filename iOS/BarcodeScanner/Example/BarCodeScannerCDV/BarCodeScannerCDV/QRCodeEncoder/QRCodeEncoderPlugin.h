//
//  QRCodeEncoderPlugin.h
//  basePackage
//
//  Created by Liu Ley on 12-7-31.
//  Copyright (c) 2012年 SINA SAE. All rights reserved.
//

#ifdef CORDOVA_FRAMEWORK
#import <CORDOVA/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif
#import <UIKit/UIKit.h>
#import "QREncoder.h"
#import "DataMatrix.h"

@interface QRCodeEncoderPlugin : CDVPlugin
@property(nonatomic,retain) NSString *callbackId;
@end
