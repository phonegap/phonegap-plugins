//
//  SinaWeixinPlugin.m
//  weixin
//
//  Created by Ley Liu on 12-5-22.
//  Copyright (c) 2012年 SINA SAE. All rights reserved.
//

#import "SinaWeixinPlugin.h"
#define THUMBNAILSIZE 100.0

#define ERROR_NO_VALID_ARG 501

@implementation SinaWeixinPlugin
@synthesize callBackId;
@synthesize responser;
@synthesize isRegisted;

-(id)init
{
    if(self=[super init])
    {
        isRegisted=NO;
        self.responser=@"receiveResponse";
    }
    return self;
}

-(void)registerApp:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callBackId=[arguments objectAtIndex:0];
    
    if(arguments.count<2)
    {
        [self errorResponse:@"没得到有效的appId"];
        return;
    }
    
    NSString *appId=[arguments objectAtIndex:1];

    BOOL isSuccess=[WXApi registerApp:appId];
    
    if(isSuccess)
    {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
    }else {
        [self errorResponse:@"注册失败"];
    }
}

-(void)setResponser:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if(arguments.count<2)
        return;
    NSString *callBKName=[arguments objectAtIndex:1];
    self.responser=callBKName;
    
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
}

/*
 * 参数:
 * type:send/get
 * text
 
 * Dict:
 * scene: int. WXSceneSession = 0, WXSceneTimeline = 1
 */
-(void)textContent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callBackId=[arguments objectAtIndex:0];
    
    if(arguments.count<3)
    {
        [self errorResponse:@"没有足够的文本信息"];
        return;
    }
    
    NSString *type=[arguments objectAtIndex:1];
    NSString *text=[arguments objectAtIndex:2];
    
    NSInteger scene=[[options objectForKey:@"scene"] integerValue];
    
    if([type isEqualToString:@"send"])
    {
        SendMessageToWXReq *req=[[[SendMessageToWXReq alloc] init] autorelease];
        req.bText=YES;
        req.text=text;
        req.scene=scene;
        
        [WXApi sendReq:req];
    }else if([type isEqualToString:@"get"])
    {
        GetMessageFromWXResp *req=[[[GetMessageFromWXResp alloc] init] autorelease];
        req.bText=YES;
        req.text=text;
        BOOL isSuccess=[WXApi sendResp:req];
        if(isSuccess)
        {
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
        }
        else {
            [self errorResponse:@"失败"];
        }
    }
}

/*
 * 参数:
 * type:send/get
 * imageUrl
 
 * Dict:
 * title
 * description
 * scene: int. WXSceneSession = 0, WXSceneTimeline = 1,
 */
-(void)imageContent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callBackId=[arguments objectAtIndex:0];
    
    if(arguments.count<3)
    {
        [self errorResponse:@"没有足够的图片信息"];
        return;
    }
    
    NSString *title=[options objectForKey:@"title"];
    NSString *description=[options objectForKey:@"description"];
    NSInteger scene=[[options objectForKey:@"scene"] integerValue];
    
    NSString *type=[arguments objectAtIndex:1];
    
    NSString *imageUrl=[arguments objectAtIndex:2];
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage *image=[UIImage imageWithData:data];
    UIImage *thumbImage=image;
    
    if(image==nil)
    {
        [self errorResponse:@"没有可用的图片数据"];
        return;
    }
    
    CGSize size=image.size;
    int width=size.width;
    int height=size.height;
    if(width>THUMBNAILSIZE || height>THUMBNAILSIZE)
    {
        if(width>height)
        {
            height = height*THUMBNAILSIZE/width;
            width = THUMBNAILSIZE;
        }
        else
        {
            width = width*THUMBNAILSIZE/height;
            height = THUMBNAILSIZE;
        }
        size.width=width;
        size.height=height;
        thumbImage=[SinaWeixinPlugin createRectImage:image size:size];
    }
    
    WXImageObject *imageObj=[WXImageObject object];
    imageObj.imageData=data;
    
    WXMediaMessage *message=[WXMediaMessage message];
    [message setThumbImage:thumbImage];
    if(title)
        [message setTitle:title];
    if(description)
        [message setDescription:description];
    if(imageObj)
        [message setMediaObject:imageObj];
    
    if([type isEqualToString:@"send"])
    {
        SendMessageToWXReq *req=[[[SendMessageToWXReq alloc] init] autorelease];
        req.bText=NO;
        req.message=message;
        req.scene=scene;
        
        [WXApi sendReq:req];
    }else if([type isEqualToString:@"get"])
    {
        GetMessageFromWXResp *req=[[[GetMessageFromWXResp alloc] init] autorelease];
        req.bText=NO;
        req.message=message;
        
        BOOL isSuccess=[WXApi sendResp:req];
        
        if(isSuccess)
        {
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
        }
        else {
            [self errorResponse:@"失败"];
        }
    }
}

/*
 * 参数:
 * type:send/get
 * musicUrl
 
 * Dict:
 * title
 * description
 * lowBandUrl
 * thumbUrl
 * thumbData
 * scene: int. WXSceneSession = 0, WXSceneTimeline = 1
 */
-(void)musicContent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callBackId=[arguments objectAtIndex:0];
    
    if(arguments.count<2)
    {
        [self errorResponse:@"没有足够的音乐信息"];
        return;
    }
    
    NSString *title=[options objectForKey:@"title"];
    NSString *description=[options objectForKey:@"description"];
    NSString *musicLowBandUrl=[options objectForKey:@"lowBandUrl"];
    NSString *thumbImageUrl=[options objectForKey:@"thumbUrl"];
    NSString *thumbData=[options objectForKey:@"thumbData"];
    NSInteger scene=[[options objectForKey:@"scene"] integerValue];
    
    if(arguments.count<3 && !musicLowBandUrl)
    {
        [self errorResponse:@"没有足够的音乐信息"];
        return;
    }
    
    NSString *type=[arguments objectAtIndex:1];
    NSString *musicUrl=nil;
    if(arguments.count>=3)
        musicUrl=[arguments objectAtIndex:2];
    
    UIImage *thumbImage=nil;
    
    if(thumbImageUrl)
    {
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbImageUrl]];
        thumbImage=[UIImage imageWithData:data];
    }
    if(thumbData)
    {
        NSData *data=[NSData dataFromBase64String:thumbData];
        thumbImage=[UIImage imageWithData:data];
    }
    
    WXMusicObject *musicObj=[WXMusicObject object];
    musicObj.musicUrl=musicUrl;
    musicObj.musicLowBandUrl=musicLowBandUrl;
    
    WXMediaMessage *message=[WXMediaMessage message];
    if(thumbImage)
        [message setThumbImage:thumbImage];
    if(title)
        [message setTitle:title];
    if(description)
        [message setDescription:description];
    if(musicObj)
        [message setMediaObject:musicObj];
    
    if([type isEqualToString:@"send"])
    {
        SendMessageToWXReq *req=[[[SendMessageToWXReq alloc] init] autorelease];
        req.bText=NO;
        req.message=message;
        req.scene=scene;
        
        [WXApi sendReq:req];
    }else if([type isEqualToString:@"get"])
    {
        GetMessageFromWXResp *req=[[[GetMessageFromWXResp alloc] init] autorelease];
        req.bText=NO;
        req.message=message;
        
        BOOL isSuccess=[WXApi sendResp:req];
        
        if(isSuccess)
        {
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
        }
        else {
            [self errorResponse:@"失败"];
        }
    }
}

/*
 * 参数:
 * type:send/get
 * videoUrl
 
 * Dict:
 * title
 * description
 * lowBandUrl
 * thumbUrl
 * thumbData
 * scene: int. WXSceneSession = 0, WXSceneTimeline = 1
 */
-(void)videoContent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callBackId=[arguments objectAtIndex:0];
    
    if(arguments.count<2)
    {
        [self errorResponse:@"没有足够的视频信息"];
        return;
    }
    
    NSString *title=[options objectForKey:@"title"];
    NSString *description=[options objectForKey:@"description"];
    NSString *videoLowBandUrl=[options objectForKey:@"lowBandUrl"];
    NSString *thumbImageUrl=[options objectForKey:@"thumbUrl"];
    NSString *thumbData=[options objectForKey:@"thumbData"];
    NSInteger scene=[[options objectForKey:@"scene"] integerValue];
    
    if(arguments.count<3 && !videoLowBandUrl)
    {
        [self errorResponse:@"没有足够的视频信息"];
        return;
    }
    
    NSString *type=[arguments objectAtIndex:1];
    NSString *videoUrl=nil;
    
    if(arguments.count>=3)
        videoUrl=[arguments objectAtIndex:2];
    
    UIImage *thumbImage=nil;
    if(thumbImageUrl)
    {
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbImageUrl]];
        thumbImage=[UIImage imageWithData:data];
    }
    if(thumbData)
    {
        NSData *data=[NSData dataFromBase64String:thumbData];
        thumbImage=[UIImage imageWithData:data];
    }
    WXVideoObject *videoObj=[WXVideoObject object];
    videoObj.videoUrl=videoUrl;
    videoObj.videoLowBandUrl=videoLowBandUrl;
    
    WXMediaMessage *message=[WXMediaMessage message];
    if(thumbImage)
        [message setThumbImage:thumbImage];
    if(title)
        [message setTitle:title];
    if(description)
        [message setDescription:description];
    if(videoObj)
        [message setMediaObject:videoObj];
    
    if([type isEqualToString:@"send"])
    {
        SendMessageToWXReq *req=[[[SendMessageToWXReq alloc] init] autorelease];
        req.bText=NO;
        req.message=message;
        req.scene=scene;
        
        [WXApi sendReq:req];
    }else if([type isEqualToString:@"get"])
    {
        GetMessageFromWXResp *req=[[[GetMessageFromWXResp alloc] init] autorelease];
        req.bText=NO;
        req.message=message;
        
        BOOL isSuccess=[WXApi sendResp:req];
        
        if(isSuccess)
        {
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
        }
        else {
            [self errorResponse:@"失败"];
        }
    }
}

/*
 * 参数:
 * type:send/get
 * webpageUrl
 
 * Dict:
 * title
 * description
 * thumbUrl
 * thumbData
 * scene: int. WXSceneSession = 0, WXSceneTimeline = 1
 */
-(void)webpageContent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callBackId=[arguments objectAtIndex:0];
    
    if(arguments.count<3)
    {
        [self errorResponse:@"没有足够的网页信息"];
        return;
    }
    
    NSString *type=[arguments objectAtIndex:1];
    NSString *webpageUrl=[arguments objectAtIndex:2];
    
    NSString *title=[options objectForKey:@"title"];
    NSString *description=[options objectForKey:@"description"];
    NSString *thumbImageUrl=[options objectForKey:@"thumbUrl"];
    NSString *thumbData=[options objectForKey:@"thumbData"];
    NSInteger scene=[[options objectForKey:@"scene"] integerValue];
    
    UIImage *thumbImage=nil;
    if(thumbImageUrl)
    {
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbImageUrl]];
        thumbImage=[UIImage imageWithData:data];
    }
    if(thumbData)
    {
        NSData *data=[NSData dataFromBase64String:thumbData];
        thumbImage=[UIImage imageWithData:data];
    }
    
    WXWebpageObject *webObj=[WXWebpageObject object];
    webObj.webpageUrl=webpageUrl;
    
    WXMediaMessage *message=[WXMediaMessage message];
    if(thumbImage)
        [message setThumbImage:thumbImage];
    if(title)
        [message setTitle:title];
    if(description)
        [message setDescription:description];
    if(webObj)
        [message setMediaObject:webObj];
    
    if([type isEqualToString:@"send"])
    {
        SendMessageToWXReq *req=[[[SendMessageToWXReq alloc] init] autorelease];
        req.bText=NO;
        req.message=message;
        req.scene=scene;
        
        [WXApi sendReq:req];
    }
    else if([type isEqualToString:@"get"])
    {
        GetMessageFromWXResp *req=[[[GetMessageFromWXResp alloc] init] autorelease];
        req.bText=NO;
        req.message=message;
        
        BOOL isSuccess=[WXApi sendResp:req];
        
        if(isSuccess)
        {
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
        }
        else {
            [self errorResponse:@"失败"];
        }
    }
}

/*
 * 参数:
 * type:send/get
 
 * Dict:
 * title
 * description
 * thumbUrl
 * thumbData:base64
 * extInfo
 * fileData: jsonString
 * url
 * scene: int. WXSceneSession = 0, WXSceneTimeline = 1
 */
-(void)APPContent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callBackId=[arguments objectAtIndex:0];
    
    if(arguments.count<2)
    {
        [self errorResponse:@"没有足够的App扩展信息"];
        return;
    }
    NSString *type=[arguments objectAtIndex:1];
    
    
    NSString *title=[options objectForKey:@"title"];
    NSString *description=[options objectForKey:@"description"];
    NSString *thumbImageUrl=[options objectForKey:@"thumbUrl"];
    NSString *thumbData=[options objectForKey:@"thumbData"];
    NSString *extInfo=[options objectForKey:@"extInfo"];
    NSString *fileString=[options objectForKey:@"fileData"];
    NSData *fileData=[fileString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *url=[options objectForKey:@"url"];
    NSInteger scene=[[options objectForKey:@"scene"] integerValue];
    
    if(!extInfo && !fileData)
    {
        [self errorResponse:@"没有足够的App扩展信息"];
        return;
    }
    
    UIImage *thumbImage=nil;
    if(thumbImageUrl)
    {
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbImageUrl]];
        thumbImage=[UIImage imageWithData:data];
    }
    if(thumbData)
    {
        NSData *data=[NSData dataFromBase64String:thumbData];
        thumbImage=[UIImage imageWithData:data];
    }
    
    WXAppExtendObject *appObj=[WXAppExtendObject object];
    appObj.extInfo=extInfo;
    appObj.fileData=fileData;
    appObj.url=url;
    
    WXMediaMessage *message=[WXMediaMessage message];
    if(thumbImage)
        [message setThumbImage:thumbImage];
    if(title)
        [message setTitle:title];
    if(description)
        [message setDescription:description];
    if(appObj)
        [message setMediaObject:appObj];
    
    if([type isEqualToString:@"send"])
    {
        SendMessageToWXReq *req=[[[SendMessageToWXReq alloc] init] autorelease];
        req.bText=NO;
        req.message=message;
        req.scene=scene;
        
        [WXApi sendReq:req];
    }
    else if([type isEqualToString:@"get"])
    {
        GetMessageFromWXResp *req=[[[GetMessageFromWXResp alloc] init] autorelease];
        req.bText=NO;
        req.message=message;
        
        BOOL isSuccess=[WXApi sendResp:req];
        
        if(isSuccess)
        {
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
        }
        else {
            [self errorResponse:@"失败"];
        }
    }
}

-(void)cancleGet:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if(arguments.count<1)
        return;
    
    ShowMessageFromWXResp *resp=[[[ShowMessageFromWXResp alloc] init] autorelease];
    resp.errCode=-2;
    resp.errStr=@"cancle to get content";
    [WXApi sendResp:resp];
}

-(void)getWXAppInstallUrl:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if(arguments.count<1)
        return;
    self.callBackId=[arguments objectAtIndex:0];
    NSString *wxAppUrl=[WXApi getWXAppInstallUrl];
    if(!wxAppUrl)
    {
        [self errorResponse:@"获取微信的itunes安装地址失败"];
    }else {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:wxAppUrl];
        [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
    }
}

-(void)openWXApp:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if(arguments.count<1)
        return;
    self.callBackId=[arguments objectAtIndex:0];
    BOOL isOpened=[WXApi openWXApp];

    if(isOpened)
    {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
    }else {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [super writeJavascript:[result toErrorCallbackString:self.callBackId]];
    }
}

-(void)isWeixinInstalled:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if(arguments.count<1)
        return;
    self.callBackId=[arguments objectAtIndex:0];
    BOOL isInstalled=[WXApi isWXAppInstalled];
    
    if(isInstalled)
    {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
    }else {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [super writeJavascript:[result toErrorCallbackString:self.callBackId]];
    }
}

-(void)isSupportApi:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if(arguments.count<1)
        return;
    self.callBackId=[arguments objectAtIndex:0];
    BOOL isSupport=[WXApi isWXAppSupportApi];
    
    if(isSupport)
    {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
    }else {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [super writeJavascript:[result toErrorCallbackString:self.callBackId]];
    }
}
#pragma mark - local functions
-(void) errorResponse:(NSString*)errString
{
    NSMutableDictionary *errorDes=[[NSMutableDictionary alloc] init];
    [errorDes setObject:[NSNumber numberWithInt:ERROR_NO_VALID_ARG] forKey:@"errCode"];
    [errorDes setObject:errString forKey:@"errStr"];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorDes];
    [super writeJavascript:[result toErrorCallbackString:self.callBackId]];
    [errorDes release];
}

- (void) handleOpenURL:(NSNotification*)notification
{
    NSURL* url = [notification object];
	if ([url isKindOfClass:[NSURL class]]) {
        
		[WXApi handleOpenURL:url delegate:self];
	}
}

+ (id) createRectImage:(UIImage*)image size:(CGSize)size
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(size);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (NSString*)base64forData:(NSData*)theData {
	
	const uint8_t* input = (const uint8_t*)[theData bytes];
	NSInteger length = [theData length];
	
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
	NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
		for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}
#pragma mark - For Request Response
- (void) viewContent:(WXMediaMessage *) msg
{
    //显示微信传过来的内容    
    WXAppExtendObject *obj = msg.mediaObject;
    
    NSMutableDictionary *dictionary=[[[NSMutableDictionary alloc] init] autorelease];
    NSString *fileDataString=[[[NSString alloc] initWithData:obj.fileData encoding:NSUTF8StringEncoding] autorelease];
    NSString *thumbDataString=[SinaWeixinPlugin base64forData:msg.thumbData];
    
    [dictionary setValue:[NSNumber numberWithInt:0] forKey:@"type"];
    if(obj.extInfo)
        [dictionary setObject:obj.extInfo forKey:@"extInfo"];
    if(obj.url)
        [dictionary setObject:obj.url forKey:@"url"];
    if(fileDataString)
        [dictionary setObject:fileDataString forKey:@"fileData"];
    if(thumbDataString)
        [dictionary setObject:thumbDataString forKey:@"thumbData"];
    
    NSString *jsonString=[dictionary JSONString];
    NSString *string=[NSString stringWithFormat:@"%@(%@)",self.responser,jsonString];
    [super writeJavascript:string];
}

-(void) onShowMediaMessage:(WXMediaMessage *) message
{
    // 微信启动， 有消息内容。
    [self viewContent:message];
}

-(void) onRequestAppMessage
{
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
    NSMutableDictionary *dictionary=[[[NSMutableDictionary alloc] init] autorelease];
    [dictionary setValue:[NSNumber numberWithInt:4] forKey:@"type"];
    //ShowMessageFromWXReq
    
    NSString *string=[NSString stringWithFormat:@"%@(%@)",self.responser,[dictionary JSONString]];
    [super writeJavascript:string];
}

#pragma mark - Weixin Delegate
-(void) onReq:(BaseReq*)req
{// 收到来自微信的请求
    NSLog(@"req type=%d",req.type);
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        [self onRequestAppMessage];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        [self onShowMediaMessage:temp.message]; 
    }
}

-(void) onResp:(BaseResp*)resp
{// 发送一个sendReq后，收到微信的回应
    NSLog(@"resp type=%d",resp.type);
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if(resp.errCode==0)
        {
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
        }else {
            NSLog(@"code=%d,str=%@",resp.errCode,resp.errStr);
            NSMutableDictionary *errorDes=[[NSMutableDictionary alloc] init];
            [errorDes setObject:[NSNumber numberWithInt:resp.errCode] forKey:@"errCode"];
            if(resp.errStr)
                [errorDes setObject:resp.errStr forKey:@"errStr"];
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorDes];
            [super writeJavascript:[result toErrorCallbackString:self.callBackId]];
            [errorDes release];
        }
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {}
}

@end
