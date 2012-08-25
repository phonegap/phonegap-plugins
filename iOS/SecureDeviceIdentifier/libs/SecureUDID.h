//
//  SecureUDID.h
//  SecureUDID
//
//  Created by Crashlytics Team on 3/22/12.
//  Copyright (c) 2012 Crashlytics, Inc. All rights reserved.
//  http://www.crashlytics.com
//  info@crashlytics.com
//

/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import <Foundation/Foundation.h>

@interface SecureUDID : NSObject

/*
 Returns a unique id for the device, sandboxed to the domain and salt provided.  This is a potentially
 expensive call.  You should not do this on the main thread, especially during launch.

 retrieveUDIDForDomain:usingKey:completion: is provided as an alternative for your 4.0+ coding convenience.

 Example usage:
 #import "SecureUDID.h"

 NSString *udid = [SecureUDID UDIDForDomain:@"com.example.myapp" key:@"difficult-to-guess-key"];

 */
+ (NSString *)UDIDForDomain:(NSString *)domain usingKey:(NSString *)key;

/*
 Getting a SecureUDID can be very expensive.  Use this call to derive an identifier in the background,
 and invoke a block when ready.  Use of this method implies a device running >= iOS 4.0.

 Example usage:
 #import "SecureUDID.h"

 [SecureUDID retrieveUDIDForDomain:@"com.example.myapp" usingKey:@"difficult-to-guess-key" completion:^(NSString *identifier) {
 // make use of identifier here
 }];

 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
+ (void)retrieveUDIDForDomain:(NSString *)domain usingKey:(NSString *)key completion:(void (^)(NSString* identifier))completion;
#endif

/*
 Indicates that the system has been disabled via the Opt-Out mechansim.
 */
+ (BOOL)isOptedOut;

@end

/*
 This identifier is returned when Opt-Out is enabled.
 */
extern NSString *const SUUIDDefaultIdentifier;
