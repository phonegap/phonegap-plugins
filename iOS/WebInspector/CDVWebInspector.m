// Licensed under the Apache License, Version 2.0. See footer for details

#include "TargetConditionals.h"

#define PLUGIN_ID @"CDVWebInspector"

#ifdef CORDOVA_FRAMEWORK
    #import <CORDOVA/CDVPlugin.h>
#else
    #import "CDVPlugin.h"
#endif

//------------------------------------------------------------------------------
// plugin interface
//------------------------------------------------------------------------------
@interface CDVWebInspector : CDVPlugin {}
- (void)enable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)returnSuccess:(NSString*)message callback:(NSString*)callback;
- (void)returnFailure:(NSString*)message callback:(NSString*)callback;
@end

//------------------------------------------------------------------------------
// plugin implementation
//------------------------------------------------------------------------------
@implementation CDVWebInspector

//--------------------------------------------------------------------------
- (void)enable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSString* callback;
    Class     dynWebView;

    callback = [arguments objectAtIndex:0];

    dynWebView = NSClassFromString(@"WebView");
    
#if !TARGET_IPHONE_SIMULATOR
    if (1) {
        NSLog(@"%@: can only be used in the simulator", PLUGIN_ID);
        return;
    }
#endif
    
    if (dynWebView == nil) {
        NSLog(@"%@: class WebView not found", PLUGIN_ID);
        // [self returnSuccess:@"" callback:callback];
        return;
    }

    @try {
        [dynWebView performSelector:@selector(_enableRemoteInspector)];
    }
    @catch (NSException *exception) {
        NSLog(
              @"%@: error calling [WebView _enableRemoteInspector]: %@: %@",
              PLUGIN_ID,
              [exception name], 
              [exception reason]
        );
        // [self returnSuccess:@"" callback:callback];
        return;
    }

    NSLog(@"%@: Web Inspector enabled, hopefully, at http://localhost:9999/", PLUGIN_ID);
    // [self returnSuccess:@"" callback:callback];
}

//--------------------------------------------------------------------------
- (void)returnSuccess:(NSString*)message callback:(NSString*)callback {
    CDVPluginResult* result = [
        CDVPluginResult 
            resultWithStatus: CDVCommandStatus_OK
            messageAsString:  message
    ];
    
    NSString* js = [result toSuccessCallbackString:callback];

    [self performSelector:@selector(writeJavascript:) withObject:js afterDelay:1];
}

//--------------------------------------------------------------------------
- (void)returnFailure:(NSString*)message callback:(NSString*)callback {
    CDVPluginResult* result = [
        CDVPluginResult 
            resultWithStatus: CDVCommandStatus_OK
            messageAsString:  message
    ];
    
    NSString* js = [result toErrorCallbackString:callback];
    
    [self performSelector:@selector(writeJavascript:) withObject:js afterDelay:1];
}

@end

//------------------------------------------------------------------------------
// Copyright 2012 IBM
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//    http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//------------------------------------------------------------------------------
