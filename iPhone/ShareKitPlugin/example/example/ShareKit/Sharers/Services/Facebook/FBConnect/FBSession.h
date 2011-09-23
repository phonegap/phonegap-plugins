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

#import "FBConnectGlobal.h"

@protocol FBSessionDelegate;
@class FBRequest;

/**
 * An FBSession represents a single user's authenticated session for a Facebook application.  
 *
 * To create a session, you must use the session key of your application (which can
 * be found on the Facebook developer website).  You may then use the login dialog to ask
 * the user to enter their email address and password.  If successful, you will get back a
 * session key which can be used to make requests to the Facebook API.
 *
 * Session keys are cached and stored on the disk of the device so that you do not need to ask
 * the user to login every time they launch the app.  To restore the last active session, call the
 * resume method after instantiating your session.
 */
@interface FBSession : NSObject {
  NSMutableArray* _delegates;
  NSString* _apiKey;
  NSString* _apiSecret;
  NSString* _getSessionProxy;
  FBUID _uid;
  NSString* _sessionKey;
  NSString* _sessionSecret;
  NSDate* _expirationDate;
  NSMutableArray* _requestQueue;
  NSDate* _lastRequestTime;
  int _requestBurstCount;
  NSTimer* _requestTimer;
}

/**
 * Delegates which implement FBSessionDelegate.
 */
@property(nonatomic,readonly) NSMutableArray* delegates;

/**
 * The URL used for API HTTP requests.
 */
@property(nonatomic,readonly) NSString* apiURL;

/**
 * The URL used for secure API HTTP requests.
 */
@property(nonatomic,readonly) NSString* apiSecureURL;

/**
 * Your application's API key, as passed to the constructor.
 */
@property(nonatomic,readonly) NSString* apiKey;

/**
 * Your application's API secret, as passed to the constructor.
 */
@property(nonatomic,readonly) NSString* apiSecret;

/**
 * The URL to call to create a session key after login.
 *
 * This is an alternative to calling auth.getSession directly using the secret key.
 */
@property(nonatomic,readonly) NSString* getSessionProxy;

/**
 * The current user's Facebook id.
 */
@property(nonatomic,readonly) FBUID uid;

/**
 * The current user's session key.
 */
@property(nonatomic,readonly) NSString* sessionKey;

/**
 * The current user's session secret.
 */
@property(nonatomic,readonly) NSString* sessionSecret;

/**
 * The expiration date of the session key.
 */
@property(nonatomic,readonly) NSDate* expirationDate;

/**
 * Determines if the session is active and connected to a user.
 */
@property(nonatomic,readonly) BOOL isConnected;

/**
 * The globally shared session instance.
 */
+ (FBSession*)session;

/**
 * Sets the globally shared session instance.
 *
 * This session is not retained, so you are still responsible for retaining it yourself.  The
 * first session that is created is automatically stored here.
 */
+ (void)setSession:(FBSession*)session;

/**
 * Constructs a session and stores it as the globally shared session instance.
 *
 * @param secret the application secret (optional)
 */
+ (FBSession*)sessionForApplication:(NSString*)key secret:(NSString*)secret
  delegate:(id<FBSessionDelegate>)delegate;

/**
 * Constructs a session and stores it as the global singleton.
 *
 * @param getSessionProxy a url to that proxies auth.getSession (optional)
 */
+ (FBSession*)sessionForApplication:(NSString*)key getSessionProxy:(NSString*)getSessionProxy
  delegate:(id<FBSessionDelegate>)delegate;

/**
 * Constructs a session for an application.
 *
 * @param secret the application secret (optional)
 * @param getSessionProxy a url to that proxies auth.getSession (optional)
 */
- (FBSession*)initWithKey:(NSString*)key secret:(NSString*)secret
  getSessionProxy:(NSString*)getSessionProxy;

/**
 * Begins a session for a user with a given key and secret.
 */
- (void)begin:(FBUID)uid sessionKey:(NSString*)sessionKey sessionSecret:(NSString*)sessionSecret
  expires:(NSDate*)expires;

/**
 * Resumes a previous session whose uid, session key, and secret are cached on disk.
 */
- (BOOL)resume;

/**
 * Cancels a login (no-op if the login is already complete).
 */
- (void)cancelLogin;

/**
 * Ends the current session and deletes the uid, session key, and secret from disk.
 */
- (void)logout;

/**
 * Sends a fully configured request to the server for execution.
 */
- (void)send:(FBRequest*)request;

/**
 * Deletes all cookies belonging to facebook
 */
- (void)deleteFacebookCookies;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol FBSessionDelegate <NSObject>

/**
 * Called when a user has successfully logged in and begun a session.
 */
- (void)session:(FBSession*)session didLogin:(FBUID)uid;

@optional

/**
 * Called when a user closes the login dialog without logging in.
 */
- (void)sessionDidNotLogin:(FBSession*)session;

/**
 * Called when a session is about to log out.
 */
- (void)session:(FBSession*)session willLogout:(FBUID)uid;

/**
 * Called when a session has logged out.
 */
- (void)sessionDidLogout:(FBSession*)session;

@end
