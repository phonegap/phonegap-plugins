//
//  QRCodeEncoderPlugin.m
//  basePackage
//
//  Created by Liu Ley on 12-7-31.
//  Copyright (c) 2012年 SINA SAE. All rights reserved.
//

#import "QRCodeEncoderPlugin.h"
#import "QRImageViewController.h"
#import "CDV.h"

//默认图片大小250x250
const int qrcodeImageDimension=250;
const int qrcodeImageSize=260;

@implementation QRCodeEncoderPlugin

@synthesize callbackId;

-(void) encode:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if ([arguments count] < 1) {
        return;
    }
    
    self.callbackId = [arguments objectAtIndex:0];
    
    /*
     TEXT_TYPE:     "TEXT_TYPE",
     EMAIL_TYPE:    "EMAIL_TYPE",
     PHONE_TYPE:    "PHONE_TYPE",
     SMS_TYPE:      "SMS_TYPE",
     */
    NSString *type=nil;
    NSString *data=nil;
    NSString *encodeString=nil;
    
    if(![options valueForKey:@"type"] || [options valueForKey:@"type"] == [NSNull null])
        type=@"TEXT_TYPE";
    else
        type=[options valueForKey:@"type"];
    
    // 如果数据不存在，返回error
    if([arguments count]<2 || [arguments objectAtIndex:1]==nil)
    {
        return [self returnError:@"there is no data to encode"];
    }else{
        data=[[arguments objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    // 编码类型
    if([type isEqualToString:@"EMAIL_TYPE"]){
        encodeString=[NSString stringWithFormat:@"mailto:%@",data];
    }else if([type isEqualToString:@"PHONE_TYPE"]){
        encodeString=[NSString stringWithFormat:@"tel:%@",data];
    }else if([type isEqualToString:@"SMS_TYPE"]){
        encodeString=[NSString stringWithFormat:@"sms:%@",data];
    }else{
        encodeString=data;
    }
    
    // 生成UIImage
    DataMatrix* qrMatrix=[QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:encodeString];
    UIImage *qrcodeImage=[QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeImageDimension];
    
    UIImage *addedEdge=[self resizeImage:qrcodeImage];
    
    [self returnImageResource:addedEdge];
    
    QRImageViewController *controller=[[QRImageViewController alloc]init];
    CDVViewController* cont = (CDVViewController*)[ super viewController ];
//    controller.supportedOrientations = cont.supportedOrientations;
	[ cont presentModalViewController:controller animated:YES ];
    [controller showQRImage:addedEdge];
}

-(UIImage *)resizeImage:(UIImage *)image
{
    NSInteger margin=qrcodeImageSize<=qrcodeImageDimension ? 0 : (qrcodeImageSize-qrcodeImageDimension)/2;
    UIGraphicsBeginImageContext(CGSizeMake(qrcodeImageSize,qrcodeImageSize));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, CGRectMake(0, 0, qrcodeImageSize, qrcodeImageSize));
    [image drawInRect:CGRectMake(margin, margin, qrcodeImageDimension,qrcodeImageDimension)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

-(void)returnError:(NSString *)error
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
    [super writeJavascript:[pluginResult toErrorCallbackString:self.callbackId]];
}

-(void)returnImageResource:(UIImage *)image
{
    NSData *data=UIImagePNGRepresentation(image);
    if(!data || data.length<5)
    {
        [self returnError:@"can't return valid image data"];
    }else{
        NSString *base64Data=[data base64EncodedString];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:base64Data];
        [super writeJavascript:[pluginResult toSuccessCallbackString:self.callbackId]];
    }
}
@end
