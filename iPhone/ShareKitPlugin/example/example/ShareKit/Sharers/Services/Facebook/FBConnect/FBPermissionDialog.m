/*
 * Copyright 2009 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

#import "FBPermissionDialog.h"
#import "FBSession.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static NSString* kPermissionURL = @"http://www.facebook.com/connect/prompt_permission.php";

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation FBPermissionDialog

@synthesize permission = _permission;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (void)redirectToLogin {
  _redirectTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self
    selector:@selector(redirectToLoginDelayed) userInfo:nil repeats:NO];
}

- (void)redirectToLoginDelayed {
  _redirectTimer = nil;

  // This loads the login page, which will just redirect back to the callback url
  // since the login cookies are set
  [super load];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithSession:(FBSession*)session {
  if (self = [super initWithSession:session]) {
    _permission = nil;
    _redirectTimer = nil;
  }
  return self;
}

- (void)dealloc {
  [_redirectTimer invalidate];
  [_permission release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialog

- (void)load {
  NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
    @"touch", @"display", _session.apiKey, @"api_key", _session.sessionKey, @"session_key",
    _permission, @"ext_perm", @"fbconnect:success", @"next", @"fbconnect:cancel", @"cancel", nil];

  [self loadURL:kPermissionURL method:@"GET" get:params post:nil];
}

- (void)dialogDidSucceed:(NSURL*)url {
  if ([_permission isEqualToString:@"offline_access"]) {
    [super dialogDidSucceed:url];
  } else {
    [self dismissWithSuccess:YES animated:YES];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
    navigationType:(UIWebViewNavigationType)navigationType {
  if ([_permission isEqualToString:@"offline_access"]) {
    NSURL* url = request.URL;
    if ([url.scheme isEqualToString:@"fbconnect"]) {
      if ([url.resourceSpecifier isEqualToString:@"success"]) {
        [self redirectToLogin];
        return NO;
      }
    }
  }
  return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

@end
