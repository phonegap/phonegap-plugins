//	Phonegap DatePicker Plugin
//	Copyright (c) Greg Allen 2011
//	MIT Licensed

#import "DatePicker.h"



@implementation DatePicker

@synthesize datePickerSheet;
@synthesize datePicker;


#pragma mark -
#pragma mark Public Methods


- (void) show:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	if (isVisible)
		return;
	NSString *mode = [options objectForKey:@"mode"];
	NSString *dateString = [options objectForKey:@"date"];
	
	NSLog(@"Show Datepicker");

	datePickerSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
	[datePickerSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	
	CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
	
	self.datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
	bool allowOldDates = ([[options objectForKey:@"allowOldDates"] intValue] == 1)?YES:NO;
	if (!allowOldDates) {
		self.datePicker.minimumDate = [NSDate date];
	}
	if ([mode isEqualToString:@"date"]) {
		self.datePicker.datePickerMode = UIDatePickerModeDate;

		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
		[dateFormatter setDateFormat:@"MM/dd/yyyy"];
		NSDate *date = [dateFormatter dateFromString:dateString];
		[dateFormatter release];
		self.datePicker.date = date;
	}
	else if ([mode isEqualToString:@"time"])
		self.datePicker.datePickerMode = UIDatePickerModeTime;
	
	[datePickerSheet addSubview:self.datePicker];
	
	UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
	closeButton.momentary = YES; 
	closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
	closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
	closeButton.tintColor = [UIColor blackColor];
	[closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
	[datePickerSheet addSubview:closeButton];
	[closeButton release];
	
	[datePickerSheet showInView:[[super webView] superview]];
	
	[datePickerSheet setBounds:CGRectMake(0, 0, 320, 485)];
	isVisible = YES;

}

- (void) dismissActionSheet:(id)sender {
	[datePickerSheet dismissWithClickedButtonIndex:0 animated:YES];
	[datePickerSheet release];
	[datePicker release];
	NSString* jsCallback = [NSString stringWithFormat:@"window.plugins.datePicker._dateSelected(\"%i\");", (int)[self.datePicker.date timeIntervalSince1970]];
	[super writeJavascript:jsCallback];
	isVisible = NO;
}

@end
