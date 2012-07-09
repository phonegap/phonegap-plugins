#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UINavigationBar.h>
#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif
#import "CDVNavigationBarController.h"

@interface NavigationBar : CDVPlugin <CDVNavigationBarDelegate> {
    UINavigationBar * navBar;

	CGRect	originalWebViewBounds;
    CGFloat navBarHeight;
    CGFloat tabBarHeight;

    CDVNavigationBarController * navBarController;
}

@property (nonatomic, retain) CDVNavigationBarController *navBarController;

- (void)create:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)setTitle:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;
- (void)setLogo:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;
- (void)show:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hide:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)init:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)setupLeftButton:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)setupRightButton:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)leftButtonTapped;
- (void)rightButtonTapped;

- (void)hideLeftButton:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)showRightButton:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hideLeftButton:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)showRightButton:(NSArray*)arguments withDict:(NSDictionary*)options;

@end

@interface UITabBar (NavBarCompat)
@property (nonatomic) bool tabBarAtBottom;
@end