//	Phonegap DatePicker Plugin
//	Copyright (c) Greg Allen 2011
//	MIT Licensed

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif


@interface DatePicker : PGPlugin {
	UIActionSheet *datePickerSheet;
	UIDatePicker *datePicker;
	BOOL isVisible;

}

@property (nonatomic, retain) UIActionSheet* datePickerSheet;
@property (nonatomic, retain) UIDatePicker* datePicker;


//- (void) prepare:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) show:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
