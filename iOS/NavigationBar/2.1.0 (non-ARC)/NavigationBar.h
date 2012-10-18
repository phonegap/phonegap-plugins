#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UINavigationBar.h>

// For older versions of Cordova, you may have to use: #import "CDVPlugin.h"
#import <Cordova/CDVPlugin.h>

#import "CDVNavigationBarController.h"

@interface NavigationBar : CDVPlugin <CDVNavigationBarDelegate> {
    UINavigationBar * navBar;

    // Represents frame of web view as if started in portrait mode. Coordinates are relative to the superview. With
    // Cordova 2.1.0, frame.origin.y=0 means directly under the status bar, while in older versions it would have been
    // frame.origin.y=20.
	CGRect	originalWebViewFrame;

    CGFloat navBarHeight;
    CGFloat tabBarHeight;

    CDVNavigationBarController * navBarController;
}

@property (nonatomic, retain) CDVNavigationBarController *navBarController;

- (void)create:(CDVInvokedUrlCommand*)command;
- (void)setTitle:(CDVInvokedUrlCommand*)command;
- (void)setLogo:(CDVInvokedUrlCommand*)command;
- (void)show:(CDVInvokedUrlCommand*)command;
- (void)hide:(CDVInvokedUrlCommand*)command;
- (void)init:(CDVInvokedUrlCommand*)command;
- (void)setupLeftButton:(CDVInvokedUrlCommand*)command;
- (void)setupRightButton:(CDVInvokedUrlCommand*)command;
- (void)leftButtonTapped;
- (void)rightButtonTapped;

- (void)hideLeftButton:(CDVInvokedUrlCommand*)command;
- (void)showRightButton:(CDVInvokedUrlCommand*)command;
- (void)hideLeftButton:(CDVInvokedUrlCommand*)command;
- (void)showRightButton:(CDVInvokedUrlCommand*)command;

@end

@interface UITabBar (NavBarCompat)
@property (nonatomic) bool tabBarAtBottom;
@end