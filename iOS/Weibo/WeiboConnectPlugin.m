//
//  WeiboConnectPlugin.m
//
//  Created by Ley Liu on 12-4-13.
//  Copyright (c) 2012年 SINA SAE. All rights reserved.
//  Under the Apache License 2.0.

#import "WeiboConnectPlugin.h"
#import "SBJSON.h"
@implementation WeiboConnectPlugin
@synthesize weibo;
@synthesize loginCallbackId;
@synthesize getCallbackId;
@synthesize callBackId;
- (void) init:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if ([arguments count] < 2) {
        return;
    }
    
	self.callBackId = [arguments objectAtIndex:0];
	NSString* appKey = [arguments objectAtIndex:1];
    NSString* appSecret = [arguments objectAtIndex:2];
    NSString* redirectUrl = [arguments objectAtIndex:3];
    
	self.weibo = [[WBEngine alloc] initWithAppKey:appKey appSecret:appSecret];
    [self.weibo setRedirectURI:redirectUrl];
    [self.weibo setDelegate:self];
    
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
}

- (void) login:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if ([arguments count] < 1 || !self.weibo) {
        return;
    }
    
    NSString* callbackId = [arguments objectAtIndex:0];// first item is the callbackId

    self.callBackId=callbackId;
    return [weibo logIn];
    
    [super writeJavascript:nil];
}

- (void) logout:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if (!self.weibo) {
        return;
    }
    
    self.callBackId = [arguments objectAtIndex:0]; // first item is the callbackId
	[weibo logOut];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [super writeJavascript:[pluginResult toSuccessCallbackString:self.callBackId]];
}

- (void) get:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if (!self.weibo) {
        return;
    }
    NSString* callbackId = [arguments objectAtIndex:0];
    self.callBackId=callbackId;
    NSString* url=[arguments objectAtIndex:1];
    NSDictionary* params=[NSDictionary dictionaryWithDictionary:options];
    
    [weibo loadRequestWithMethodName:url httpMethod:@"GET" params:params postDataType:kWBRequestPostDataTypeNone httpHeaderFields:nil];
    [super writeJavascript:nil];
}

- (void) post:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if (!self.weibo) {
        return;
    }
    NSString* callbackId = [arguments objectAtIndex:0];
    self.callBackId=callbackId;
    NSString* url=[arguments objectAtIndex:1];
    NSDictionary* params=[NSDictionary dictionaryWithDictionary:options];
    
    [weibo loadRequestWithMethodName:url httpMethod:@"POST" params:params postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
    [super writeJavascript:nil];
}

- (void) upload:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if (!self.weibo) {
        return;
    }
    NSString* callbackId = [arguments objectAtIndex:0];
    self.callBackId=callbackId;
    NSString* url=[arguments objectAtIndex:1];
    NSString* file=[arguments objectAtIndex:2];
    NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:options];
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:file]]];
    [params setObject:image forKey:@"pic"];
    
    [weibo loadRequestWithMethodName:url httpMethod:@"POST" params:params postDataType:kWBRequestPostDataTypeMultipart httpHeaderFields:nil];
    [super writeJavascript:nil];
}

#pragma mark - Engine delegate
- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    if ([engine isUserExclusive])
    {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"请先登出"];
        [super writeJavascript:[pluginResult toErrorCallbackString:self.callBackId]];
    }
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    NSMutableDictionary *result=[[NSMutableDictionary alloc] initWithCapacity:2];
    [result setObject:self.weibo.accessToken forKey:@"access_token"];
    NSUInteger timer=(NSUInteger)self.weibo.expireTime-(NSUInteger)[[NSDate date] timeIntervalSince1970];
    [result setObject:[NSNumber numberWithInt: (int)timer ]  forKey:@"expires_in"];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [super writeJavascript:[pluginResult toSuccessCallbackString:self.callBackId]];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
    [super writeJavascript:[pluginResult toErrorCallbackString:self.callBackId]];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"登出成功"];
    [super writeJavascript:[pluginResult toSuccessCallbackString:self.callBackId]];
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"尚未登录"];
    [super writeJavascript:[pluginResult toErrorCallbackString:self.callBackId]];
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"请重新登录"];
    [super writeJavascript:[pluginResult toErrorCallbackString:self.callBackId]];
}

#pragma mark - Request Delegate
- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
    [super writeJavascript:[pluginResult toErrorCallbackString:self.callBackId]];
    
}
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{  
    SBJSON *parser=[[SBJSON alloc] init];
    NSString *string=[parser stringWithObject:result error:nil];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:string];
    [super writeJavascript:[pluginResult toSuccessCallbackString:self.callBackId]];
    [parser release];
}
@end
