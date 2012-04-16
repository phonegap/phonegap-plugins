//
//  LoadingView.h
//  LoadingView
//
//  Created by Matt Gallagher on 12/04/09.
//  Copyright Matt Gallagher 2009. All rights reserved.
// 
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//
//  Additions and tweaks by Shazron Abdullah, Nitobi Software.
//

#import <UIKit/UIKit.h>

@interface NExLoadingView : UIView
{
	NSTimeInterval minDuration;
	NSDate* timestamp;
	CGFloat boxLength;
	CGFloat backgroundOpacity;
	CGFloat strokeOpacity;
	UIColor* strokeColor;
	BOOL fullScreen;
	UILabel* textLabel;
	BOOL bounceAnimation;
}

@property (nonatomic, assign) CGFloat boxLength;
@property (nonatomic, assign) CGFloat backgroundOpacity;
@property (nonatomic, assign) CGFloat strokeOpacity;
@property (nonatomic, retain) UIColor* strokeColor;
@property (nonatomic, assign) NSTimeInterval minDuration;
@property (nonatomic, retain) NSDate* timestamp;
@property (nonatomic, assign) BOOL fullScreen;
@property (nonatomic, retain) UILabel* textLabel;
@property (nonatomic, assign) BOOL bounceAnimation;

+ (id)loadingViewInView:(UIView *)aSuperview;
+ (id)loadingViewInView:(UIView *)aSuperview strokeOpacity:(CGFloat)strokeOpacity backgroundOpacity:(CGFloat)backgroundOpacity 
			strokeColor:(UIColor*)strokeColor fullScreen:(BOOL)fullScreen labelText:(NSString*)labelText 
		bounceAnimation:(BOOL)bounceAnimation 
	   boxLength:(CGFloat)length;

+ (CGFloat) defaultStrokeOpacity;
+ (CGFloat) defaultBackgroundOpacity;
+ (UIColor*) defaultStrokeColor;
+ (NSString*) defaultLabelText;
+ (CGFloat) defaultBoxLength;

- (void)removeView;

@end
