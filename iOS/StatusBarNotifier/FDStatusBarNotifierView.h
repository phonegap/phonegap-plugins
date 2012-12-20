//
//  StatusBarNotifierView.h
//  StatusBarNotifier
//
//  Created by Francesco Di Lorenzo on 05/09/12.
//  Copyright (c) 2012 Francesco Di Lorenzo. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FDStatusBarNotifierView : UIView

@property (strong, nonatomic) NSString *message;
@property NSTimeInterval timeOnScreen; // seconds, default: 2s
@property id delegate;


- (id)initWithMessage:(NSString *)message;
- (id)initWithMessage:(NSString *)message delegate:(id /*<StatusBarNotifierViewDelegate>*/)delegate;

- (void)showInWindow:(UIWindow *)window;

@end


@protocol StatusBarNotifierViewDelegate <NSObject>
@optional

- (void)willPresentNotifierView:(FDStatusBarNotifierView *)notifierView;  // before animation and showing view
- (void)didPresentNotifierView:(FDStatusBarNotifierView *)notifierView;   // after animation
- (void)willHideNotifierView:(FDStatusBarNotifierView *)notifierView;     // before hiding animation
- (void)didHideNotifierView:(FDStatusBarNotifierView *)notifierView;      // after animation

- (void)notifierViewTapped:(FDStatusBarNotifierView *)notifierView; // user tap the status bar message

@end