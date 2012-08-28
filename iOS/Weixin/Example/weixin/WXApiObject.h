//
//  MMApiObject.h
//  ApiClient
//
//  Created by Tencent on 12-2-28.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////

enum  WXErrCode {
    WXSuccess           = 0,
    WXErrCodeCommon     = -1,
    WXErrCodeUserCancel = -2,
    WXErrCodeSentFail   = -3,
    WXErrCodeAuthDeny   = -4,
};

@interface BaseReq : NSObject

@property (nonatomic, assign) int type;
@end

@interface BaseResp : NSObject

@property (nonatomic, assign) int errCode;
@property (nonatomic, retain) NSString *errStr;
@property (nonatomic, assign) int type;
@end

/*
 *
 */
@class WXMediaMessage;
@interface SendMessageToWXReq : BaseReq

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) WXMediaMessage* message;
@property (nonatomic, assign) BOOL bText;
@end

@interface SendMessageToWXResp : BaseResp
@end
/////////////////////////////////


@interface SendAuthReq : BaseReq

@property (nonatomic, retain) NSString* scope;
@property (nonatomic, retain) NSString* state;
@end

@interface SendAuthResp : BaseResp

@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* token;
@property (nonatomic, retain) NSDate* expireDate;
@property (nonatomic, retain) NSString* state; 
@end
/////////////////////////////////

/*
 *
 */
@interface GetMessageFromWXReq : BaseReq
@end

@interface GetMessageFromWXResp : BaseResp

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) WXMediaMessage* message;
@property (nonatomic, assign) BOOL bText;
@end
/////////////////////////////////

/*
 *
 */
@interface ShowMessageFromWXReq : BaseReq

@property (nonatomic, retain) WXMediaMessage* message;
@end

@interface ShowMessageFromWXResp : BaseResp
@end
/////////////////////////////////

#pragma mark - WXMediaMessage

/*
 * 消息
 */
@interface WXMediaMessage : NSObject

+(WXMediaMessage *) message;

/*
 * 标题
 */
@property (nonatomic, retain) NSString *title;
/*
 * 内容
 */
@property (nonatomic, retain) NSString *description;
/*
 * 缩略图数据
 */
@property (nonatomic, retain) NSData   *thumbData;

@property (nonatomic, retain) id        mediaObject;

- (void) setThumbImage:(UIImage *)image;

@end
/////////////////////////////////

#pragma mark -

@interface WXImageObject : NSObject

+(WXImageObject *) object;

/*
 * 图片数据
 */
@property (nonatomic, retain) NSData    *imageData;
@property (nonatomic, retain) NSString  *imageUrl;

@end

@interface WXMusicObject : NSObject

+(WXMusicObject *) object;
/*
 * 音乐数据
 */
//@property (nonatomic, retain) NSData   *musicData;
@property (nonatomic, retain) NSString *musicUrl;
@property (nonatomic, retain) NSString *musicLowBandUrl;

@end

@interface WXVideoObject : NSObject

+(WXVideoObject *) object;
/*
 * 视频数据
 */
//@property (nonatomic, retain) NSData   *videoData;
@property (nonatomic, retain) NSString *videoUrl;
@property (nonatomic, retain) NSString *videoLowBandUrl;

@end

@interface WXWebpageObject : NSObject

+(WXWebpageObject *) object;
/*
 * 网页数据
 */
@property (nonatomic, retain) NSString *webpageUrl;

@end

@interface WXAppExtendObject : NSObject

+(WXAppExtendObject *) object;
/*
 *
 */
@property (nonatomic, retain) NSString *url;
/*
 * App自定义简单数据
 */
@property (nonatomic, retain) NSString *extInfo;

/*
 * App文件数据
 * 注意：该数据发送给微信好友， 微信好友需要点击后下载数据。
 */
@property (nonatomic, retain) NSData   *fileData;


@end

#pragma mark -


/*
 * 微信启动App附带的启动数据
 */
//@interface WXAppLaunchData : NSObject

/*
 * 微信启动App的类型， 参照WXAppLaunchType
 */
//@property (nonatomic, assign) WXAppLaunchType launchType;

/*
 * 微信启动App附带的消息内容
 */
//@property (nonatomic, retain) WXMediaMessage *message;


//@end


