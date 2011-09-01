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

#import "FBSession.h"

typedef enum {
  FBLoginButtonStyleNormal,
  FBLoginButtonStyleWide,
} FBLoginButtonStyle;

/**
 * Standard button which lets the user log in or out of the session.
 *
 * The button will automatically change to reflect the state of the session, showing
 * "login" if the session is not connected, and "logout" if the session is connected.
 */
@interface FBLoginButton : UIControl <FBSessionDelegate> {
  FBLoginButtonStyle _style;
  FBSession* _session;
  UIImageView* _imageView;
}

/**
 * The visual style of the button.
 */
@property(nonatomic) FBLoginButtonStyle style;

/**
 * The session object that the button will log in and out of.
 *
 * The default value is the global session singleton, so there is usually no need to
 * set this property yourself.
 */
@property(nonatomic,retain) FBSession* session;

@end
