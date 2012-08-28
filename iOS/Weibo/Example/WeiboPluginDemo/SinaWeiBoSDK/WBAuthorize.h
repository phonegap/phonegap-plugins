//
//  WBAuthorize.h
//  SinaWeiBoSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBRequest.h"
#import "WBAuthorizeWebView.h"

@class WBAuthorize;

@protocol WBAuthorizeDelegate <NSObject>

@required

- (void)authorize:(WBAuthorize *)authorize didSucceedWithAccessToken:(NSString *)accessToken userID:(NSString *)userID expiresIn:(NSInteger)seconds;

- (void)authorize:(WBAuthorize *)authorize didFailWithError:(NSError *)error;

@end

@interface WBAuthorize : NSObject <WBAuthorizeWebViewDelegate, WBRequestDelegate> 
{
    
    NSString    *appKey;
    NSString    *appSecret;
    
    NSString    *redirectURI;
    
    WBRequest   *request;
    
    UIViewController *rootViewController;
    
    id<WBAuthorizeDelegate> delegate;
}

@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, retain) NSString *appSecret;
@property (nonatomic, retain) NSString *redirectURI;
@property (nonatomic, retain) WBRequest *request;
@property (nonatomic, assign) UIViewController *rootViewController;
@property (nonatomic, assign) id<WBAuthorizeDelegate> delegate;

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;

- (void)startAuthorize;
- (void)startAuthorizeUsingUserID:(NSString *)userID password:(NSString *)password;

@end
