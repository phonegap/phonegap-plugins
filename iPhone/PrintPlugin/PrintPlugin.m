//
//  PrintPlugin.m
//  Print Plugin
//
//  Created by Ian Tipton (github.com/itip) on 02/07/2011.
//  Copyright 2011 Ian Tipton. All rights reserved.
//  MIT licensed
//

#import "PrintPlugin.h"

@interface PrintPlugin (Private)
-(void) doPrint;
-(void) callbackWithFuntion:(NSString *)function withData:(NSString *)value;
- (BOOL) isPrintServiceAvailable;
@end

@implementation PrintPlugin

@synthesize callBackId, printHTML, dialogTopPos, dialogLeftPos;

/*
 Is printing available. Callback returns true/false if printing is available/unavailable.
 */
- (void) isPrintingAvailable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options{
    self.callBackId = [arguments pop];
    NSDictionary* dic = [NSDictionary dictionaryWithObject:([self isPrintServiceAvailable] ? @"true" : @"false") forKey:@"available"]; 
    
    PluginResult* result = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsDictionary:dic];
            //[NSString stringWithFormat:@"%@", ([self isPrintServiceAvailable] ? @"true" : @"false")]];
    NSString* jsString = [result toSuccessCallbackString:callBackId];
    [[self webView] stringByEvaluatingJavaScriptFromString:jsString];
}

- (void) print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options{
    self.callBackId = [arguments pop];
    
    self.printHTML = [options objectForKey:@"printHTML"];
    self.dialogLeftPos = [[options objectForKey:@"dialogLeftPos"] intValue];
    self.dialogTopPos = [[options objectForKey:@"dialogTopPos"] intValue];

    [self doPrint];

}

- (void) doPrint{

    if (![self isPrintServiceAvailable]){
        PluginResult* result;
        NSString * jsString;
        NSArray * keys = [NSArray arrayWithObjects:@"success",@"available", nil];
        NSArray * values = [NSArray arrayWithObjects:@"false",@"false", nil];
        NSDictionary* dic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        result = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsDictionary:dic];
        jsString = [result toErrorCallbackString:self.callBackId];
        [self writeJavascript:jsString];
        return;
    }
    
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    
    if (!controller){
        return;
    }
    
	if ([UIPrintInteractionController isPrintingAvailable]){        
		//Set the priner settings
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        controller.printInfo = printInfo;
        controller.showsPageRange = YES;
        
        
        //Set the base URL to be the www directory.
        NSString *dbFilePath = [[NSBundle mainBundle] pathForResource:@"www" ofType:nil ];
        NSURL *baseURL = [NSURL fileURLWithPath:dbFilePath];
                
        //Load page into a webview and use its formatter to print the page 
		UIWebView *webViewPrint = [[UIWebView alloc] init];
		[webViewPrint loadHTMLString:printHTML baseURL:baseURL];
        
        //Get formatter for web (note: margin not required - done in web page)
		UIViewPrintFormatter *viewFormatter = [webViewPrint viewPrintFormatter];
        controller.printFormatter = viewFormatter;
        controller.showsPageRange = YES;
        
        
		void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
		^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed || error) {
                PluginResult* result;
                NSString * jsString; 
                NSArray * keys = [NSArray arrayWithObjects:@"success",@"available",@"error", nil];
                NSArray * values = [NSArray arrayWithObjects:@"false",@"true",[NSString stringWithFormat:@"%@",error.localizedDescription], nil];
                NSDictionary* dic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                result = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsDictionary:dic];
                jsString = [result toErrorCallbackString:self.callBackId];
                [self writeJavascript:jsString];
                [webViewPrint release];
                
			}
            else{
                PluginResult* result;
                NSString * jsString;   
                NSArray * keys = [NSArray arrayWithObjects:@"success",@"available", nil];
                NSArray * values = [NSArray arrayWithObjects:@"true",@"true", nil];
                NSDictionary* dic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                result = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsDictionary:dic];
                jsString = [result toSuccessCallbackString:self.callBackId];
                [self writeJavascript:jsString];
                [webViewPrint release];
            }
        };
        
        /*
         If iPad, and if button offsets passed, then show dilalog originating from offset
         */
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
            dialogTopPos != 0 && dialogLeftPos != 0) {
            [controller presentFromRect:CGRectMake(self.dialogLeftPos, self.dialogTopPos, 0, 0) inView:self.webView animated:YES completionHandler:completionHandler];
        } else {
            [controller presentAnimated:YES completionHandler:completionHandler];
        }
    }
}

-(BOOL) isPrintServiceAvailable{
  
    Class myClass = NSClassFromString(@"UIPrintInteractionController");
    if (myClass) {
        UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
        return (controller != nil) && [UIPrintInteractionController isPrintingAvailable];
    }
  
    
    return NO;
}

#pragma mark -
#pragma mark Return messages


@end
