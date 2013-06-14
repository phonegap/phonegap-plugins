/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "CDVWebViewDelegate.h"
#import "CDVAvailability.h"

typedef enum {
    STATE_NORMAL,
    STATE_SHOULD_LOAD_MISSING,
    STATE_WAITING_FOR_START,
    STATE_WAITING_FOR_FINISH
} State;

@implementation CDVWebViewDelegate

- (id)initWithDelegate:(NSObject <UIWebViewDelegate>*)delegate
{
    self = [super init];
    if (self != nil) {
        _delegate = delegate;
        _loadCount = -1;
        _state = STATE_NORMAL;
    }
    return self;
}

- (BOOL)isPageLoaded:(UIWebView*)webView
{
    NSString* readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];

    return [readyState isEqualToString:@"loaded"] || [readyState isEqualToString:@"complete"];
}

- (BOOL)isJsLoadTokenSet:(UIWebView*)webView
{
    NSString* loadToken = [webView stringByEvaluatingJavaScriptFromString:@"window.__cordovaLoadToken"];

    return [[NSString stringWithFormat:@"%d", _curLoadToken] isEqualToString:loadToken];
}

- (void)setLoadToken:(UIWebView*)webView
{
    _curLoadToken += 1;
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.__cordovaLoadToken=%d", _curLoadToken]];
}

- (void)pollForPageLoadStart:(UIWebView*)webView
{
    if ((_state != STATE_WAITING_FOR_START) && (_state != STATE_SHOULD_LOAD_MISSING)) {
        return;
    }
    if (![self isJsLoadTokenSet:webView]) {
        _state = STATE_WAITING_FOR_FINISH;
        [self setLoadToken:webView];
        [_delegate webViewDidStartLoad:webView];
        [self pollForPageLoadFinish:webView];
    }
}

- (void)pollForPageLoadFinish:(UIWebView*)webView
{
    if (_state != STATE_WAITING_FOR_FINISH) {
        return;
    }
    if ([self isPageLoaded:webView]) {
        _state = STATE_SHOULD_LOAD_MISSING;
        [_delegate webViewDidFinishLoad:webView];
    } else {
        [self performSelector:@selector(pollForPageLoaded) withObject:webView afterDelay:50];
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL shouldLoad = [_delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];

    if (shouldLoad) {
        BOOL isTopLevelNavigation = [request.URL isEqual:[request mainDocumentURL]];
        if (isTopLevelNavigation) {
            _loadCount = 0;
            _state = STATE_NORMAL;
        }
    }
    return shouldLoad;
}

- (void)webViewDidStartLoad:(UIWebView*)webView
{
    if (_state == STATE_NORMAL) {
        if (_loadCount == 0) {
            [_delegate webViewDidStartLoad:webView];
            _loadCount += 1;
        } else if (_loadCount > 0) {
            _loadCount += 1;
        } else if (!IsAtLeastiOSVersion(@"6.0")) {
            // If history.go(-1) is used pre-iOS6, the shouldStartLoadWithRequest function is not called.
            // Without shouldLoad, we can't distinguish an iframe from a top-level navigation.
            // We could try to distinguish using [UIWebView canGoForward], but that's too much complexity,
            // and would work only on the first time it was used.

            // Our work-around is to set a JS variable and poll until it disappears (from a naviagtion).
            _state = STATE_WAITING_FOR_START;
            [self setLoadToken:webView];
        }
    } else {
        [self pollForPageLoadStart:webView];
        [self pollForPageLoadFinish:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    if (_state == STATE_NORMAL) {
        if (_loadCount == 1) {
            [_delegate webViewDidFinishLoad:webView];
            _loadCount -= 1;
        } else if (_loadCount > 1) {
            _loadCount -= 1;
        }
    } else {
        [self pollForPageLoadStart:webView];
        [self pollForPageLoadFinish:webView];
    }
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
    if (_state == STATE_NORMAL) {
        if (_loadCount == 1) {
            [_delegate webView:webView didFailLoadWithError:error];
            _loadCount -= 1;
        } else if (_loadCount > 1) {
            _loadCount -= 1;
        }
    } else {
        [self pollForPageLoadStart:webView];
        [self pollForPageLoadFinish:webView];
    }
}

@end
