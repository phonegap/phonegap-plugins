//
//  SAEIFlyRCPlugin.m
//  iFlytekTest
//
//  Created by Ley Liu on 12-5-7.
//  Copyright (c) 2012年 SINA SAE. All rights reserved.
//

#import "SAEIFlyRCPlugin.h"
#define IFlyServerURL @"http://dev.voicecloud.cn/index.htm"

@implementation SAEIFlyRCPlugin

@synthesize callBackId;
@synthesize resultCallback;

-(void)init:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callBackId=[arguments objectAtIndex:0];
    NSString *appId=[arguments objectAtIndex:1];
    
    NSString *initParam=[[NSString alloc] initWithFormat:@"server_url=%@,appid=%@",IFlyServerURL,appId];
    CGRect center=[[UIScreen mainScreen] bounds];
    iFlyRC=[[IFlyRecognizeControl alloc] initWithOrigin:CGPointMake(center.origin.x+center.size.width/2-140, 70) theInitParam:initParam];
    iFlyRC.delegate=self;
    self.resultCallback=@"onResults";
    [self.viewController.view addSubview:iFlyRC];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
}

-(void)setOption:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if(!iFlyRC || [arguments count]<1)
        return;
    
    self.callBackId=[arguments objectAtIndex:0];
    NSDictionary *params=[NSDictionary dictionaryWithDictionary:options];
    NSString *engine=[params objectForKey:@"engine"];
    NSString *engineParam=[params objectForKey:@"engineParams"];
    NSString *sampleRate=[params objectForKey:@"sampleRate"];
    NSString *grammar=[params objectForKey:@"grammar"];
    
    _type=IsrText;
    if(!engine)
        engine=@"keyword";
    // 采用android命名
    if([engine isEqualToString:@"asr"])
    {
        engine=@"keyword";
        _type=IsrKeyword;
    }
    
    [iFlyRC setEngine:engine theEngineParam:engineParam theGrammarID:grammar];
    
    if([sampleRate isEqualToString:@"rate8k"])
        [iFlyRC setSampleRate:8000];
    
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
}

-(void)dealloc
{
    [iFlyRC release];
    self.callBackId=nil;
    self.resultCallback=nil;
    [super dealloc];
}

-(void)setListener:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if(!iFlyRC || [arguments count]<2)
        return;
    
    NSString *callBKName=[arguments objectAtIndex:1];
    self.resultCallback=callBKName;
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
}

-(void)start:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if(!iFlyRC || [arguments count]<1)
        return;
    
    self.callBackId=[arguments objectAtIndex:0];
    isLast=NO;
    [iFlyRC start];
//    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//    [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
}

-(void)cancel:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if(!iFlyRC)
        return;
    
    [iFlyRC cancel];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
}

-(NSString *)array2String:(NSArray *)array
{
    NSMutableString *totalString=[[[NSMutableString alloc] init] autorelease];
    for(int i=0;i<[array count];i++)
    {
        if(i==[array count]-1)
            [totalString appendString:[[array objectAtIndex:i] stringValue]];
        else {
            [totalString appendFormat:@"%@,",[[array objectAtIndex:i] stringValue]];
        }
    }
    NSLog(@"array String=%@",totalString);
    return totalString;
}

-(void)uploadKeyword:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if(!iFlyRC)
    {
        return;
    }
    
    NSLog(@"arguments count=%d,%@",[arguments count],arguments);
    
    _type=IsrUploadKeyword;
    
    self.callBackId=[arguments objectAtIndex:0];
    NSString *keys=[arguments objectAtIndex:1];
    
    NSString *engine=@"keywordupload";
    
    [iFlyRC setEngine:engine theEngineParam:keys theGrammarID:nil];
    isLast=NO;
    [iFlyRC start];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
}

-(void)return2Main:(NSMutableDictionary *)result
{
    NSString *string=[NSString stringWithFormat:@"%@(%@)",self.resultCallback,[result JSONString]];
    [super writeJavascript:string];
}

-(void)returnUpload:(NSMutableDictionary *)result
{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [super writeJavascript:[pluginResult toSuccessCallbackString:self.callBackId]];
}

-(void)updateInfo:(NSArray *)resultArray
{
    NSLog(@"resultArray=%@",resultArray);
    NSMutableDictionary *result=[[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
    
    
    if(_type==IsrUploadKeyword)
    {
        [result setObject:[resultArray objectAtIndex:0] forKey:@"extendID"];
        [self performSelectorOnMainThread:@selector(returnUpload:) withObject:result waitUntilDone:NO];
    }
    else if(_type==IsrText)
    {
        [result setValue:[NSNumber numberWithBool:isLast] forKey:@"isLast"];
        NSMutableArray *resultMA=[[[NSMutableArray alloc] initWithCapacity:[resultArray count]] autorelease];
        NSMutableDictionary *dicResult;
        for (NSDictionary *dic in resultArray) {
            NSString *text=[dic objectForKey:@"NAME"];
            NSInteger confidence=[[dic objectForKey:@"SCORE"] integerValue];
            dicResult=[[NSMutableDictionary alloc] init];
            [dicResult setObject:text forKey:@"text"];
            [dicResult setObject:[NSNumber numberWithInteger:confidence] forKey:@"confidence"];
            [resultMA addObject:dicResult];
            [dicResult release];
        }
        [result setObject:resultMA forKey:@"results"];
        [self performSelectorOnMainThread:@selector(return2Main:) withObject:result waitUntilDone:NO];
    }
    else if(_type==IsrKeyword)
    {
        [result setValue:[NSNumber numberWithBool:isLast] forKey:@"isLast"];
        [result setObject:[resultArray objectAtIndex:0] forKey:@"results"];
        [self performSelectorOnMainThread:@selector(return2Main:) withObject:result waitUntilDone:NO];
    }
    
    
}
#pragma mark - Delegate
- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControl theResult:(NSArray *)resultArray
{
    [self performSelectorInBackground:@selector(updateInfo:) withObject:resultArray];
}

- (void)onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControl theError:(SpeechError) error
{
    isLast=YES;
    if(_type==IsrUploadKeyword)
    {
        return;
    }
    if(error==0)
    {
        NSMutableDictionary *result=[[NSMutableDictionary alloc] initWithCapacity:2];
        
        [result setObject:[NSNumber numberWithInt:error] forKey:@"errorCode"];
        [result setObject:@"Success" forKey:@"message"];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
        [super writeJavascript:[pluginResult toSuccessCallbackString:self.callBackId]];
        [result release];
    }
    else {
        NSMutableDictionary *result=[[NSMutableDictionary alloc] initWithCapacity:2];
        
        [result setObject:[NSNumber numberWithInt:error] forKey:@"errorCode"];
        [result setObject:[iFlyRecognizeControl getErrorDescription:error] forKey:@"message"];
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:result];
        [super writeJavascript:[pluginResult toErrorCallbackString:self.callBackId]];
        [result release];
    }
}
@end
