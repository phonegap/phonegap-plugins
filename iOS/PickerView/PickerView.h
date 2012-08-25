//
//  PickerView.h
//
// Created by Olivier Louvignes on 11/28/2011.
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

#import <Foundation/Foundation.h>
#ifdef CORDOVA_FRAMEWORK
#import <CORDOVA/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif

@interface PickerView : CDVPlugin <UIActionSheetDelegate, UIPopoverControllerDelegate, UIPickerViewDelegate> {

	NSString* callbackID;
	NSInteger systemMajorVersion;
	UIActionSheet* actionSheet;
	UIPopoverController* popoverController;
	NSArray* items;

}

@property (nonatomic, copy) NSString* callbackID;
@property (nonatomic, readwrite) NSInteger systemMajorVersion;
@property (nonatomic, retain) UIActionSheet* actionSheet;
@property (nonatomic, retain) UIPopoverController* popoverController;
@property (nonatomic, retain) NSArray* items;

// Instance Method
- (void) create:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) createForIpad:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
// Specific methods
- (void)popoverController:(UIPopoverController *)popoverController dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(Boolean)animated;
- (void)sendResultsFromPickerView:(UIPickerView *)pickerView withButtonIndex:(NSInteger)buttonIndex;

@end
