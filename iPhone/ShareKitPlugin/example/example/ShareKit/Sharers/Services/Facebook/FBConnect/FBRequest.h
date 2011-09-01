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

@protocol FBRequestDelegate;
@class FBSession;

@interface FBRequest : NSObject {
  FBSession*            _session;
  id<FBRequestDelegate> _delegate;
  NSString*             _url;
  NSString*             _method;
  id                    _userInfo;
  NSMutableDictionary*  _params;
  NSObject*             _dataParam;
  NSDate*               _timestamp;
  NSURLConnection*      _connection;
  NSMutableData*        _responseText;
}

/**
 * Creates a new API request for the global session.
 */
+ (FBRequest*)request;

/**
 * Creates a new API request for the global session with a delegate.
 */
+ (FBRequest*)requestWithDelegate:(id<FBRequestDelegate>)delegate;

/**
 * Creates a new API request for a particular session.
 */
+ (FBRequest*)requestWithSession:(FBSession*)session;

/**
 * Creates a new API request for the global session with a delegate.
 */
+ (FBRequest*)requestWithSession:(FBSession*)session delegate:(id<FBRequestDelegate>)delegate;

@property(nonatomic,assign) id<FBRequestDelegate> delegate;

/**
 * The URL which will be contacted to execute the request.
 */
@property(nonatomic,readonly) NSString* url;

/**
 * The API method which will be called.
 */
@property(nonatomic,readonly) NSString* method;

/**
 * An object used by the user of the request to help identify the meaning of the request.
 */
@property(nonatomic,retain) id userInfo;

/**
 * The dictionary of parameters to pass to the method.
 *
 * These values in the dictionary will be converted to strings using the 
 * standard Objective-C object-to-string conversion facilities.
 */
@property(nonatomic,readonly) NSDictionary* params;

/**
 * A data parameter.
 *
 * Used for methods such as photos.upload, video.upload, events.create, and
 * events.edit.
 */
@property(nonatomic,readonly) NSObject* dataParam;

/**
 * The timestamp of when the request was sent to the server.
 */
@property(nonatomic,readonly) NSDate* timestamp;

/**
 * Indicates if the request has been sent and is awaiting a response.
 */
@property(nonatomic,readonly) BOOL loading;

/**
 * Creates a new request paired to a session.
 */
- (id)initWithSession:(FBSession*)session;

/**
 * Calls a method on the server asynchronously.
 *
 * The delegate will be called for each stage of the loading process.
 */ 
- (void)call:(NSString*)method params:(NSDictionary*)params;

/**
 * Calls a method on the server asynchronously, with a file upload component.
 *
 * The delegate will be called for each stage of the loading process.
 */ 
- (void)call:(NSString*)method params:(NSDictionary*)params dataParam:(NSData*)dataParam;

/**
 * Calls a URL on the server asynchronously.
 *
 * The delegate will be called for each stage of the loading process.
 */ 
- (void)post:(NSString*)url params:(NSDictionary*)params;

/**
 * Stops an active request before the response has returned.
 */
- (void)cancel;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol FBRequestDelegate <NSObject>

@optional

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest*)request;

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response;

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error;

/**
 * Called when a request returns and its response has been parsed into an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result;

/**
 * Called when the request was cancelled.
 */
- (void)requestWasCancelled:(FBRequest*)request;

@end
