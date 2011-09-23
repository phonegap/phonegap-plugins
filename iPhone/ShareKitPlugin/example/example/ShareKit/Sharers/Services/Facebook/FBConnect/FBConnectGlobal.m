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

const NSString* kFB_SDK_VersionNumber = @"iphone/1.3.0";

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

const void* RetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
void ReleaseNoOp(CFAllocatorRef allocator, const void *value) { }

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

NSMutableArray* FBCreateNonRetainingArray() {
  CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
  callbacks.retain = RetainNoOp;
  callbacks.release = ReleaseNoOp;
  return (NSMutableArray*)CFArrayCreateMutable(nil, 0, &callbacks);
}


BOOL FBIsDeviceIPad() {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return YES; 
  }
#endif
  return NO;
}
