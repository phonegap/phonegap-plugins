//
//  SAEIFlyRCPlugin.h
//  iFlytekTest
//
//  Created by Ley Liu on 12-5-7.
//  Copyright (c) 2012年 SINA SAE. All rights reserved.
//

#import <Cordova/CDV.h>
#import <IFlyISR/IFlyRecognizeControl.h>
typedef enum _IsrType
{
	IsrText = 0,		// 转写
	IsrKeyword,			// 关键字识别
	IsrUploadKeyword	// 关键字上传
}IsrType;

@interface SAEIFlyRCPlugin : CDVPlugin<IFlyRecognizeControlDelegate>
{
    IFlyRecognizeControl *iFlyRC;
    BOOL isLast;
    
    IsrType _type;
}
@property (nonatomic, copy) NSString *callBackId;
@property (nonatomic, copy) NSString *resultCallback;
-(void)init:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
-(void)setOption:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
@end
