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

#import "CDVSplashScreen.h"

#define kSplashScreenStateShow 0
#define kSplashScreenStateHide 1

#define kSplashScreenDurationDefault 0.25f

@implementation CDVSplashScreen

- (void)pluginInitialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageDidLoad) name:CDVPageDidLoadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOrientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];

    [self show:nil];
}

- (void)show:(CDVInvokedUrlCommand*)command
{
    [self updateSplashScreenWithState:kSplashScreenStateShow];
}

- (void)hide:(CDVInvokedUrlCommand*)command
{
    [self updateSplashScreenWithState:kSplashScreenStateHide];
}

- (void)pageDidLoad
{
    id autoHideSplashScreenValue = [self.commandDelegate.settings objectForKey:@"AutoHideSplashScreen"];

    // if value is missing, default to yes
    if ((autoHideSplashScreenValue == nil) || [autoHideSplashScreenValue boolValue]) {
        [self hide:nil];
    }
}

- (void)onOrientationWillChange:(NSNotification*)notification
{
    if (_imageView != nil) {
        UIInterfaceOrientation orientation = [notification.userInfo[UIApplicationStatusBarOrientationUserInfoKey] intValue];
        [self updateSplashImageForOrientation:orientation];
    }
}

- (void)createViews
{
    /*
     * The Activity View is the top spinning throbber in the status/battery bar. We init it with the default Grey Style.
     *
     *     whiteLarge = UIActivityIndicatorViewStyleWhiteLarge
     *     white      = UIActivityIndicatorViewStyleWhite
     *     gray       = UIActivityIndicatorViewStyleGray
     *
     */
    NSString* topActivityIndicator = [self.commandDelegate.settings objectForKey:@"TopActivityIndicator"];
    UIActivityIndicatorViewStyle topActivityIndicatorStyle = UIActivityIndicatorViewStyleGray;

    if ([topActivityIndicator isEqualToString:@"whiteLarge"]) {
        topActivityIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
    } else if ([topActivityIndicator isEqualToString:@"white"]) {
        topActivityIndicatorStyle = UIActivityIndicatorViewStyleWhite;
    } else if ([topActivityIndicator isEqualToString:@"gray"]) {
        topActivityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    }

    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:topActivityIndicatorStyle];
    _activityView.tag = 2;
    _activityView.center = self.viewController.view.center;
    [_activityView startAnimating];

    _imageView = [[UIImageView alloc] init];
    [self.viewController.view addSubview:_imageView];
    [self.viewController.view.superview addSubview:_activityView];
    [self.viewController.view.superview layoutSubviews];
}

- (void)updateSplashImageForOrientation:(UIInterfaceOrientation)orientation
{
    // IPHONE (default)
    NSString* imageName = @"Default";

    if (CDV_IsIPhone5()) {
        imageName = [imageName stringByAppendingString:@"-568h"];
    } else if (CDV_IsIPad()) {
        // set default to portrait upside down
        imageName = @"Default-Portrait"; // @"Default-PortraitUpsideDown.png";

        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            imageName = @"Default-Landscape.png"; // @"Default-LandscapeLeft.png";
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            imageName = @"Default-Landscape.png"; // @"Default-LandscapeRight.png";
        }
    }

    _imageView.image = [UIImage imageNamed:imageName];
    _imageView.frame = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
}

- (void)updateSplashScreenWithState:(int)state
{
    float toAlpha = state == kSplashScreenStateShow ? 1.0f : 0.0f;
    BOOL hidden = state == kSplashScreenStateShow ? NO : YES;

    id fadeSplashScreenValue = [self.commandDelegate.settings objectForKey:@"FadeSplashScreen"];
    id fadeSplashScreenDuration = [self.commandDelegate.settings objectForKey:@"FadeSplashScreenDuration"];

    float fadeDuration = fadeSplashScreenDuration == nil ? kSplashScreenDurationDefault : [fadeSplashScreenDuration floatValue];

    if ((fadeSplashScreenValue == nil) || ![fadeSplashScreenValue boolValue]) {
        fadeDuration = 0;
    }
    if (hidden && (_imageView == nil)) {
        return;
    } else if (_imageView == nil) {
        [self createViews];
        fadeDuration = 0;
    }

    if (!hidden) {
        [self updateSplashImageForOrientation:self.viewController.interfaceOrientation];
    }

    if (fadeDuration == 0) {
        [_imageView setHidden:hidden];
        [_activityView setHidden:hidden];
    } else {
        if (state == kSplashScreenStateShow) {
            // reset states
            [_imageView setHidden:NO];
            [_activityView setHidden:NO];
            [_imageView setAlpha:0.0f];
            [_activityView setAlpha:0.0f];
        }

        [UIView transitionWithView:self.viewController.view
                          duration:fadeDuration
                           options:UIViewAnimationOptionTransitionNone
                        animations:^(void) {
                [_imageView setAlpha:toAlpha];
                [_activityView setAlpha:toAlpha];
            }
                        completion:^(BOOL finished) {
                if (state == kSplashScreenStateHide) {
                    // Clean-up resources.
                    [_imageView removeFromSuperview];
                    [_activityView removeFromSuperview];
                    _imageView = nil;
                    _activityView = nil;
                }
            }];
    }
}

@end
