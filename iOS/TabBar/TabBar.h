/*
 TabBar.h

 Created by Jesse MacFadyen on 10-02-03.
 MIT Licensed

 Originally this code was developed my Michael Nachbaur
 Formerly -> PhoneGap :: UIControls.h
 Created by Michael Nachbaur on 13/04/09.
 Copyright 2009 Decaf Ninja Software. All rights reserved.

 API cleaned up and improved by Andreas Sommer (https://github.com/AndiDog/phonegap-plugins).
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITabBar.h>
#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif

@interface TabBar : CDVPlugin <UITabBarDelegate> {
	UITabBar* tabBar;

	NSMutableDictionary* tabBarItems;

	CGRect	originalWebViewBounds;
    CGFloat navBarHeight;
    CGFloat tabBarHeight;
    bool tabBarAtBottom;
}

- (void)create:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)show:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)resize:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hide:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)init:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)showItems:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)createItem:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)updateItem:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)selectItem:(NSArray*)arguments withDict:(NSDictionary*)options;

@end

@interface UITabBar (NavBarCompat)
@property (nonatomic) bool tabBarAtBottom;
@end