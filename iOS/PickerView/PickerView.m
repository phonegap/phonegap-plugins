//
//  PickerView.m
//  
// Created by Olivier Louvignes on 11/28/2011.
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

#import "PickerView.h" 

// Private interface
@interface PickerView()
@property (nonatomic, retain) UIPickerView *pickerView;
@end


@implementation PickerView 

@synthesize pickerView = _pickerView;

@synthesize callbackID;
@synthesize systemMajorVersion;
@synthesize actionSheet;
@synthesize popoverController;
@synthesize items;

-(void)create:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
	
    //NSLog(@"PickerView::create():arguments: %@", arguments);
	//NSLog(@"PickerView::create():options: %@", options);
	
	// The first argument in the arguments parameter is the callbackID.
	// We use this to send data back to the successCallback or failureCallback
	// through PluginResult.
	self.callbackID = [arguments pop];
	self.systemMajorVersion = [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue];
	
	// Compiling options with defaults
	NSString *title = [options objectForKey:@"title"] ?: @" ";
	NSString *style = [options objectForKey:@"style"] ?: @"default";
	NSString *doneButtonLabel = [options objectForKey:@"doneButtonLabel"] ?: @"Done";
	NSString *cancelButtonLabel = [options objectForKey:@"cancelButtonLabel"] ?: @"Cancel";
	
    // Hold slots items in an instance variable
	self.items = [options objectForKey:@"items"];
    
    // Initialize PickerView
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40.0f, 320.0f, 162.0f)];
	self.pickerView.showsSelectionIndicator = YES;
	self.pickerView.delegate = self;
    
    // Loop through slots to define default value
    for(int i = 0; i < [self.items count]; i++) {
        NSDictionary *slot = [self.items objectAtIndex:i];
        // Check for a default value
        NSString *defaultValue = [NSString stringWithFormat:@"%@", [slot objectForKey:@"value"]];
        if([slot objectForKey:@"data"] && defaultValue) {
            // Loop through slot data
            for(int j = 0; j < [[slot objectForKey:@"data"] count]; j++) {
                NSDictionary *slotData = [[slot objectForKey:@"data"] objectAtIndex:j];
                NSString *slotDataValue = [NSString stringWithFormat:@"%@", [slotData objectForKey:@"value"]];
                // Check for a default value match
                if([slotDataValue isEqualToString:defaultValue]) {
                    [self.pickerView selectRow:j inComponent:i animated:NO];
                }
            }
        }
    }

	// Check if device is iPad as we won't be able to use an ActionSheet there
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		return [self createForIpad:arguments withDict:options];
	}
	
	// Create actionSheet
	self.actionSheet = [[UIActionSheet alloc] initWithTitle:title
												   delegate:self
										  cancelButtonTitle:nil
									 destructiveButtonTitle:nil
										  otherButtonTitles:nil];
	
	// Style actionSheet, defaults to UIActionSheetStyleDefault
	if([style isEqualToString:@"black-opaque"]) actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	else if([style isEqualToString:@"black-translucent"]) actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	else actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	
	// Append pickerView
	[actionSheet addSubview:self.pickerView];
	[self.pickerView release];
	
	// Create segemented cancel button
	UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:cancelButtonLabel]];
	cancelButton.momentary = YES; 
	cancelButton.frame = CGRectMake(5.0f, 7.0f, 50.0f, 30.0f);
	cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
	cancelButton.tintColor = [UIColor blackColor];
	[cancelButton addTarget:self action:@selector(segmentedControl:didDismissWithCancelButton:) forControlEvents:UIControlEventValueChanged];
	// Append close button
	[actionSheet addSubview:cancelButton];
	[cancelButton release];
	
	// Create segemented done button
	UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:doneButtonLabel]];
	doneButton.momentary = YES; 
	doneButton.frame = CGRectMake(265.0f, 7.0f, 50.0f, 30.0f);
	doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
	doneButton.tintColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
	[doneButton addTarget:self action:@selector(segmentedControl:didDismissWithDoneButton:) forControlEvents:UIControlEventValueChanged];
	// Append done button
	[actionSheet addSubview:doneButton];
	[doneButton release];
	
	//[actionSheet sendSubviewToBack:pickerView];
	
	// Toggle ActionSheet
    [actionSheet showInView:self.webView.superview];
	
	// Resize actionSheet was 360
	float actionSheetHeight;
	if(systemMajorVersion == 5) {
		actionSheetHeight = 360.0f;
	} else {
		actionSheetHeight = 472.0f;
	}
	[actionSheet setBounds:CGRectMake(0, 0, 320.0f, actionSheetHeight)];	
	
}

-(void)createForIpad:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	
	NSString *doneButtonLabel = [options objectForKey:@"doneButtonLabel"] ?: @"Done";
	NSString *cancelButtonLabel = [options objectForKey:@"cancelButtonLabel"] ?: @"Cancel";
	
	// Create a generic content view controller
	UINavigationController* popoverContent = [[UINavigationController alloc] init];
	// Create a generic container view
	UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 162.0f)];
	popoverContent.view = popoverView;
	
	// Append pickerView
	[popoverView addSubview:self.pickerView];
	[self.pickerView release];
	
	/*
	 UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Ok" style:UIBarButtonItemStyleBordered target:self action:@selector(okayButtonPressed)];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
	
	[popoverContent.navigationItem setLeftBarButtonItem:cancelButton animated:NO];
	[popoverContent.navigationItem setRightBarButtonItem:okButton animated:NO];
	 popoverContent.topViewController.navigationItem.title = @"MY TITLE!";
	 popoverContent.navigationItem.title = @"MY TITLE!";
	 */
	
	// Create segemented cancel button
	UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:cancelButtonLabel]];
	cancelButton.momentary = YES; 
	cancelButton.frame = CGRectMake(5.0f, 7.0f, 50.0f, 30.0f);
	cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
	cancelButton.tintColor = [UIColor blackColor];
	[cancelButton addTarget:self action:@selector(segmentedControl:didDismissWithCancelButton:) forControlEvents:UIControlEventValueChanged];
	// Append close button
	[popoverView addSubview:cancelButton];
	[cancelButton release];
	
	// Create segemented done button
	UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:doneButtonLabel]];
	doneButton.momentary = YES; 
	doneButton.frame = CGRectMake(265.0f, 7.0f, 50.0f, 30.0f);
	doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
	doneButton.tintColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
	[doneButton addTarget:self action:@selector(segmentedControl:didDismissWithDoneButton:) forControlEvents:UIControlEventValueChanged];
	// Append done button
	[popoverView addSubview:doneButton];
	[doneButton release];

	// Resize the popover view shown
	// in the current view to the view's size
	popoverContent.contentSizeForViewInPopover = CGSizeMake(320.0f, 162.0f);
	
	// Create a popover controller
	self.popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
	popoverController.delegate = self;
	
	//present the popover view non-modal with a
	//refrence to the button pressed within the current view
	[popoverController presentPopoverFromRect:CGRectMake(374.0f, 1014.0f, 20.0f, 20.0f)
									   inView:self.webView.superview
					 permittedArrowDirections:UIPopoverArrowDirectionAny
									 animated:YES];
	
	//release the popover content
	[popoverView release];
	[popoverContent release];

}

//
// Dismiss methods
//

// Picker with segmentedControls dismissed with done
- (void)segmentedControl:(UISegmentedControl *)segmentedControl didDismissWithDoneButton:(NSInteger)buttonIndex
{
	//NSLog(@"didDismissWithDoneButton:%d", buttonIndex);
	
	// Check if device is iPad
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		// Emulate a new delegate method
		[self popoverController:popoverController dismissWithClickedButtonIndex:1 animated:YES];
	} else {
		[actionSheet dismissWithClickedButtonIndex:1 animated:YES];
	}
}

// Picker with segmentedControls dismissed with cancel
- (void)segmentedControl:(UISegmentedControl *)segmentedControl didDismissWithCancelButton:(NSInteger)buttonIndex
{
	//NSLog(@"didDismissWithCancelButton:%d", buttonIndex);
	
	// Check if device is iPad
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		// Emulate a new delegate method
		[self popoverController:popoverController dismissWithClickedButtonIndex:0 animated:YES];
	} else {
		[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	}
}

// Popover generic dismiss - iPad
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	//NSLog(@"popoverControllerDidDismissPopover");
	
	// Retreive pickerView
	NSArray *subviews = [self.popoverController.contentViewController.view subviews];
	UIPickerView *pickerView = [subviews objectAtIndex:0];
	// Simulate a cancel click
	[self sendResultsFromPickerView:pickerView withButtonIndex:0];
}

// Popover emulated button-powered dismiss - iPad
- (void)popoverController:(UIPopoverController *)popoverController dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(Boolean)animated
{
	//NSLog(@"didDismissPopoverWithButtonIndex:%d", buttonIndex);
	
	// Manually dismiss the popover
	[self.popoverController dismissPopoverAnimated:animated];
	// Retreive pickerView
	NSArray *subviews = [self.popoverController.contentViewController.view subviews];
	UIPickerView *pickerView = [subviews objectAtIndex:0];
	[self sendResultsFromPickerView:pickerView withButtonIndex:buttonIndex];
	
	// Release objects
	[self.popoverController release];
}

// ActionSheet generic dismiss - iPhone
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	//NSLog(@"didDismissWithButtonIndex:%d", buttonIndex);
	
	// Retreive pickerView
    NSArray *subviews = [self.actionSheet subviews];
	UIPickerView *pickerView = [subviews objectAtIndex:1];
	[self sendResultsFromPickerView:pickerView withButtonIndex:buttonIndex];
	
	// Release objects
	[self.actionSheet release];
}

//
// Results
//

- (void)sendResultsFromPickerView:(UIPickerView *)pickerView withButtonIndex:(NSInteger)buttonIndex {
	
	// Build returned result
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
	
	// Loop throught slots
	for(int i = 0; i < [items count]; i++) {
		NSInteger selectedRow = [pickerView selectedRowInComponent:i];
		NSString *selectedValue = [[[[items objectAtIndex:i] objectForKey:@"data"] objectAtIndex:selectedRow] objectForKey:@"value"];	
		NSString *slotName = [[items objectAtIndex:i] objectForKey:@"name"] ?: [NSString stringWithFormat:@"%d", i];
		[values setObject:selectedValue forKey:slotName];
	}
	
	[result setObject:[NSNumber numberWithInteger:buttonIndex] forKey:@"buttonIndex"];
	[result setObject:values forKey:@"values"];
	
	// Create Plugin Result
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
	
	// Checking if cancel was clicked
	if (buttonIndex == 0) {
		//Call  the Failure Javascript function
		[self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
	}else {    
		//Call  the Success Javascript function
		[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
	}
	
}

//
// Picker delegate
//


// Listen picker selected row
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	//NSLog(@"didSelectRow %d", row);
}

// Tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[[items objectAtIndex:component] objectForKey:@"data"] count];
}

// Tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return [items count];
}

// Tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	//NSLog(@"%d:%d", component, row);
	return [[[[items objectAtIndex:component] objectForKey:@"data"] objectAtIndex:row] objectForKey:@"text"];
}

// Tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 300.0f/[items count];
}

@end