//	Phonegap DatePicker Plugin
//	Copyright (c) Greg Allen 2011
//	MIT Licensed

#import <Foundation/Foundation.h>
#import "PhoneGapCommand.h"


@interface DatePicker : PhoneGapCommand {
	UIActionSheet *datePickerSheet;
	UIDatePicker *datePicker;
	BOOL isVisible;
	
}

@property (nonatomic, retain) UIActionSheet* datePickerSheet;
@property (nonatomic, retain) UIDatePicker* datePicker;


//- (void) prepare:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) show:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
