//
//  IFlyRecognizeControl.h
//
//  Description: 语音识别控件
//
//  Created by 陈阳 on 11-2-23.
//  E_mail: yangchen@iflytek.com
//  Copyright 2011 iFLYTEK. All rights reserved.
//
//	Important History:
//	index	version		date		author		notes
//	0		1.0.0		2011/2/23	yangchen	创建文件


#import <UIKit/UIKit.h>

#define SpeechError int

@class IFlyRecognizeControlImp;

@class IFlyRecognizeControl;

@protocol IFlyRecognizeControlDelegate

/*
	 @function	onResult
	 @abstract	回调返回识别结果
	 @discussion	
	 @param	
*/
- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControl theResult:(NSArray *)resultArray;

/*
	@function	onRecognizeEnd
	@abstract	识别结束回调
	@discussion	
	@param	
*/
- (void)onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControl theError:(SpeechError) error;

@end


@interface IFlyRecognizeControl : UIView
{	
	// 实现部分
	IFlyRecognizeControlImp			 *_iFlyRecognizeControlImp;

	// 接口
	id<IFlyRecognizeControlDelegate> _delegate;
}
@property(assign)id<IFlyRecognizeControlDelegate> delegate;

/*
	@function	initWithOrigin
	@abstract	初始化
	@discussion	
	@param		initParam－初始化参数，用逗号隔开，中间不要有空格
*/
- (id)initWithOrigin:(CGPoint)origin theInitParam:(NSString *)initParam;

/*
	 @function		setEngine
	 @abstract		设置识别引擎
	 @discussion	默认使用sms
	 @param			engineType - sms,keyword,keywordupload,poi,vsearch,video
	 @param			engineParam - 如:当engineType为poi时,该参数可接受如下参数:@"area=合肥市"
	 @param			grammarID	- 如:当engineType为keyword时,该参数接受的参数为上传命令词时返回的结果
*/
- (void)setEngine:(NSString *)engineType 
   theEngineParam:(NSString *)engineParam 
	 theGrammarID:(NSString *)grammarID;

/*
	 @function	setSampleRate
	 @abstract	设置录音采样率
	 @discussion	
	 @param		仅支持8k、16k，设置错误或不设置会默认用16k
*/
- (void)setSampleRate:(int)rate;

/*
	 @function	start
	 @abstract	开始识别
	 @discussion	
*/
- (BOOL)start;

/*
	 @function	cancel
	 @abstract	取消识别
	 @discussion	
*/
- (void)cancel;

/*
	 @function	getUpflow
	 @abstract	查询流量
	 @discussion	
	 @param		返回字节数
*/
- (int)getUpflow;

/*
	 @function	getUpflow
	 @abstract	查询流量
	 @discussion	
	 @param		返回字节数
*/
- (int)getDownflow;

/*
	 @function	getErrorDescription
	 @abstract	根据错误码获取错误描述
	 @discussion	
	 @param		返回错误描述
*/
- (NSString *)getErrorDescription:(SpeechError)errorCode;

@end
