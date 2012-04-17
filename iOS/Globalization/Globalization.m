/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 * 
 * Copyright (c) 2011, IBM Corporation
 */

#import "Globalization.h"


@implementation Globalization

-(id)initWithWebView:(UIWebView *)theWebView
{
	self = (Globalization*)[super initWithWebView:theWebView];
	if(self)
	{
        currentLocale = CFLocaleCopyCurrent();
    }
    return self;
}
- (void) getLocaleName:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	CDVPluginResult* result = nil;
	NSString* jsString = nil;
	NSString* callbackId = [arguments objectAtIndex:0];
	NSDictionary* dictionary = nil;
	
	NSLocale* locale = [NSLocale currentLocale];
	
	if(locale) {
		dictionary = [NSDictionary dictionaryWithObject:[locale localeIdentifier] forKey:@"value"];
	
		result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
		jsString = [result toSuccessCallbackString:callbackId];
	}
	else {
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: UNKNOWN_ERROR];
		jsString = [result toErrorCallbackString:callbackId];
	}
	
	[self writeJavascript:jsString];
}

- (void) dateToString:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	CFDateFormatterStyle style = kCFDateFormatterShortStyle;
	CFDateFormatterStyle dateStyle = kCFDateFormatterShortStyle;
	CFDateFormatterStyle timeStyle = kCFDateFormatterShortStyle;
	NSDate* date = nil;
	NSString *dateString = nil;
	CDVPluginResult* result = nil;
	NSString* jsString = nil;
	NSString* callBackId = [arguments objectAtIndex:0];
	
	id milliseconds = [options valueForKey:@"date"];
	if (milliseconds && [milliseconds isKindOfClass:[NSNumber class]]){
		// get the number of seconds since 1970 and create the date object
		date = [NSDate dateWithTimeIntervalSince1970:[milliseconds doubleValue]/1000];
	}
	
	// see if any options have been specified
	id items = [options valueForKey:@"options"];
	if(items && [items isKindOfClass:[NSMutableDictionary class]]) {
		
		NSEnumerator* enumerator = [items keyEnumerator];
		id key;
		
		// iterate through all the options
		while((key = [enumerator nextObject])) {
			id item = [items valueForKey:key];
			
			// make sure that only string values are present
			if ([item isKindOfClass:[NSString class]]) {
				// get the desired format length
				if([key isEqualToString:@"formatLength"]) {
					if([item isEqualToString:@"short"]) {
						style = kCFDateFormatterShortStyle;
					}
					else if ([item isEqualToString:@"medium"]) {
						style = kCFDateFormatterMediumStyle;
					}
					else if ([item isEqualToString:@"long"]) {
						style = kCFDateFormatterLongStyle;
					}
					else if ([item isEqualToString:@"full"]) {
						style = kCFDateFormatterFullStyle;
					}
				}
				// get the type of date and time to generate
				else if ([key isEqualToString:@"selector"]) {
					if([item isEqualToString:@"date"]) {
						dateStyle = style;
						timeStyle = kCFDateFormatterNoStyle;
					}
					else if ([item isEqualToString:@"time"]) {
						dateStyle = kCFDateFormatterNoStyle;
						timeStyle = style;
					}
					else if ([item isEqualToString:@"date and time"]) {
						dateStyle = style;
						timeStyle = style;
					}
				}
			}
		}
	}
	
	// create the formatter using the user's current default locale and formats for dates and times
	CFDateFormatterRef formatter = CFDateFormatterCreate(kCFAllocatorDefault, 
                                                         currentLocale, 
                                                         dateStyle, 
                                                         timeStyle);
    // if we have a valid date object then call the formatter
	if(date) {
		dateString = (NSString *) CFDateFormatterCreateStringWithDate(kCFAllocatorDefault, 
																	  formatter, 
																	  (CFDateRef) date); 
	}
	
	// if the date was converted to a string successfully then return the result
	if(dateString) {
		NSDictionary* dictionary = [NSDictionary dictionaryWithObject:dateString forKey:@"value"];
		result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
		jsString = [result toSuccessCallbackString:callBackId];
		[dateString release];
	}
	// error
	else {
		NSLog(@"GlobalizationCommand dateToString unable to format %@", [date description]);
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: FORMATTING_ERROR];
		jsString = [result toErrorCallbackString:callBackId];
	}

	[self writeJavascript:jsString];
	
	CFRelease(formatter);
}

- (void) stringToDate:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	CFDateFormatterStyle style = kCFDateFormatterShortStyle;
	CFDateFormatterStyle dateStyle = kCFDateFormatterShortStyle;
	CFDateFormatterStyle timeStyle = kCFDateFormatterShortStyle;
	CDVPluginResult* result = nil;
	NSString* jsString = nil;
	NSString* callBackId = [arguments objectAtIndex:0];
	NSString* dateString = nil;
	NSDateComponents* comps = nil;
	
	
	// get the string that is to be parsed for a date
	id ms = [options valueForKey:@"dateString"];
	if (ms && [ms isKindOfClass:[NSString class]]){
		dateString = ms;
	}
	
	// see if any options have been specified
	id items = [options valueForKey:@"options"];
	if(items && [items isKindOfClass:[NSMutableDictionary class]]) {
		
		NSEnumerator* enumerator = [items keyEnumerator];
		id key;
		
		// iterate through all the options
		while((key = [enumerator nextObject])) {
			id item = [items valueForKey:key];
			
			// make sure that only string values are present
			if ([item isKindOfClass:[NSString class]]) {
				// get the desired format length
				if([key isEqualToString:@"formatLength"]) {
					if([item isEqualToString:@"short"]) {
						style = kCFDateFormatterShortStyle;
					}
					else if ([item isEqualToString:@"medium"]) {
						style = kCFDateFormatterMediumStyle;
					}
					else if ([item isEqualToString:@"long"]) {
						style = kCFDateFormatterLongStyle;
					}
					else if ([item isEqualToString:@"full"]) {
						style = kCFDateFormatterFullStyle;
					}
				}
				// get the type of date and time to generate
				else if ([key isEqualToString:@"selector"]) {
					if([item isEqualToString:@"date"]) {
						dateStyle = style;
						timeStyle = kCFDateFormatterNoStyle;
					}
					else if ([item isEqualToString:@"time"]) {
						dateStyle = kCFDateFormatterNoStyle;
						timeStyle = style;
					}
					else if ([item isEqualToString:@"date and time"]) {
						dateStyle = style;
						timeStyle = style;
					}
				}
			}
		}
		
	}
	
	// get the user's default settings for date and time formats
	CFDateFormatterRef formatter = CFDateFormatterCreate(kCFAllocatorDefault, 
														 currentLocale, 
														 dateStyle, 
														 timeStyle);
    
    // set the parsing to be more lenient 
    CFDateFormatterSetProperty(formatter, kCFDateFormatterIsLenient, kCFBooleanTrue);
    
    // parse tha date and time string
    CFDateRef date = CFDateFormatterCreateDateFromString(kCFAllocatorDefault, 
														 formatter, 
														 (CFStringRef)dateString,
														 NULL);
	 
    // if we were able to parse the date then get the date and time components
    if(date != NULL) {
        NSCalendar *calendar = [NSCalendar currentCalendar]; 
		
        unsigned unitFlags = NSYearCalendarUnit | 
		NSMonthCalendarUnit |  
		NSDayCalendarUnit | 
		NSHourCalendarUnit | 
		NSMinuteCalendarUnit | 
		NSSecondCalendarUnit;
		
        comps = [calendar components:unitFlags fromDate:(NSDate *)date];
        CFRelease(date);
    }
	
	// put the various elements of the date and time into a dictionary
	if(comps != nil) {
		NSArray* keys = [NSArray arrayWithObjects:@"year",@"month",@"day",@"hour",@"minute",@"second",@"millisecond", nil];
		NSArray* values = [NSArray arrayWithObjects:[NSNumber numberWithInt:[comps year]],
						   [NSNumber numberWithInt:[comps month]-1],
						   [NSNumber numberWithInt:[comps day]],
						   [NSNumber numberWithInt:[comps hour]],
						   [NSNumber numberWithInt:[comps minute]],
						   [NSNumber numberWithInt:[comps second]],
						   [NSNumber numberWithInt:0], /* iOS does not provide milliseconds */
						   nil];
		
		NSDictionary* dictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
		jsString = [result toSuccessCallbackString:callBackId];
    }
	// error
	else {
		NSLog(@"GlobalizationCommand stringToDate unable to parse %@", dateString);
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PARSING_ERROR];
		jsString = [result toErrorCallbackString:callBackId];
	}

	[self writeJavascript:jsString];
	
	CFRelease(formatter);
}

- (void) getDatePattern:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	CFDateFormatterStyle style = kCFDateFormatterShortStyle;
	CFDateFormatterStyle dateStyle = kCFDateFormatterShortStyle;
	CFDateFormatterStyle timeStyle = kCFDateFormatterShortStyle;
	CDVPluginResult* result = nil;
	NSString* jsString = nil;
	NSString* callBackId = [arguments objectAtIndex:0];
	
	// see if any options have been specified
	id items = [options valueForKey:@"options"];
	if(items && [items isKindOfClass:[NSMutableDictionary class]]) {
		
		NSEnumerator* enumerator = [items keyEnumerator];
		id key;
		
		// iterate through all the options
		while((key = [enumerator nextObject])) {
			id item = [items valueForKey:key];
			
			// make sure that only string values are present
			if ([item isKindOfClass:[NSString class]]) {
				// get the desired format length
				if([key isEqualToString:@"formatLength"]) {
					if([item isEqualToString:@"short"]) {
						style = kCFDateFormatterShortStyle;
					}
					else if ([item isEqualToString:@"medium"]) {
						style = kCFDateFormatterMediumStyle;
					}
					else if ([item isEqualToString:@"long"]) {
						style = kCFDateFormatterLongStyle;
					}
					else if ([item isEqualToString:@"full"]) {
						style = kCFDateFormatterFullStyle;
					}
				}
				// get the type of date and time to generate
				else if ([key isEqualToString:@"selector"]) {
					if([item isEqualToString:@"date"]) {
						dateStyle = style;
						timeStyle = kCFDateFormatterNoStyle;
					}
					else if ([item isEqualToString:@"time"]) {
						dateStyle = kCFDateFormatterNoStyle;
						timeStyle = style;
					}
					else if ([item isEqualToString:@"date and time"]) {
						dateStyle = style;
						timeStyle = style;
					}
				}
			}
		}
	}
	
	// get the user's default settings for date and time formats
	CFDateFormatterRef formatter = CFDateFormatterCreate(kCFAllocatorDefault, 
                                                         currentLocale, 
                                                         dateStyle, 
                                                         timeStyle);
    
	// get the date pattern to apply when formatting and parsing 
    CFStringRef datePattern = CFDateFormatterGetFormat(formatter);
	// get the user's current time zone information
	CFTimeZoneRef timezone = (CFTimeZoneRef) CFDateFormatterCopyProperty(formatter, kCFDateFormatterTimeZone);
	
	// put the pattern and time zone information into the dictionary
	if(datePattern != nil && timezone != nil) {
		NSArray* keys = [NSArray arrayWithObjects:@"pattern",@"timezone",@"utc_offset",@"dst_offset",nil];
		NSArray* values = [NSArray arrayWithObjects:((NSString*)datePattern),
						   [((NSTimeZone*) timezone)abbreviation],
						   [NSNumber numberWithLong:[((NSTimeZone*) timezone)secondsFromGMT]],
						   [NSNumber numberWithDouble:[((NSTimeZone*) timezone)daylightSavingTimeOffset]],
						   nil];
		
		NSDictionary* dictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
		jsString = [result toSuccessCallbackString:callBackId];
        
    }
	// error
	else {
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PATTERN_ERROR];
		jsString = [result toErrorCallbackString:callBackId];
	}
	
	[self writeJavascript:jsString];
	
    if (timezone) {
        CFRelease(timezone);
    }
    CFRelease(formatter);
}

- (void) getDateNames:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	int style = FORMAT_LONG;
    int selector = SELECTOR_MONTHS;
	CFStringRef dataStyle = kCFDateFormatterMonthSymbols;
	CDVPluginResult* result = nil;
	NSString* jsString = nil;
	NSString* callBackId = [arguments objectAtIndex:0];
	
	// see if any options have been specified
	id items = [options valueForKey:@"options"];
	if(items && [items isKindOfClass:[NSMutableDictionary class]]) {
		
		NSEnumerator* enumerator = [items keyEnumerator];
		id key;
		
		// iterate through all the options
		while((key = [enumerator nextObject])) {
			id item = [items valueForKey:key];
			
			// make sure that only string values are present
			if ([item isKindOfClass:[NSString class]]) {
				// get the desired type of name
				if([key isEqualToString:@"type"]) {
					if([item isEqualToString:@"narrow"]) {
						style = FORMAT_SHORT;
					}
					else if ([item isEqualToString:@"wide"]) {
						style = FORMAT_LONG;
					}
				}
				// determine if months or days are needed
				else if ([key isEqualToString:@"item"]) {
					if([item isEqualToString:@"months"]) {
						selector = SELECTOR_MONTHS;
					}
					else if ([item isEqualToString:@"days"]) {
						selector = SELECTOR_DAYS;
					}
				}
			}
		}
	}
	
	CFDateFormatterRef formatter = CFDateFormatterCreate(kCFAllocatorDefault, 
                                                         currentLocale, 
                                                         kCFDateFormatterFullStyle, 
                                                         kCFDateFormatterFullStyle);
    
    if(selector == SELECTOR_MONTHS && style == FORMAT_LONG) {
        dataStyle = kCFDateFormatterMonthSymbols;
    }
    else if(selector == SELECTOR_MONTHS && style == FORMAT_SHORT) {
        dataStyle = kCFDateFormatterShortMonthSymbols;
    }
    else if(selector == SELECTOR_DAYS && style == FORMAT_LONG) {
        dataStyle = kCFDateFormatterWeekdaySymbols;
    }
    else if(selector == SELECTOR_DAYS && style == FORMAT_SHORT) {
        dataStyle = kCFDateFormatterShortWeekdaySymbols;
    }
    
	CFArrayRef names = (CFArrayRef) CFDateFormatterCopyProperty(formatter, dataStyle);
	
	if(names) {
		NSDictionary* dictionary = [NSDictionary dictionaryWithObject:((NSArray*)names) forKey:@"value"];
		result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
		jsString = [result toSuccessCallbackString:callBackId];
        CFRelease(names);
	}
	// error
	else {
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: UNKNOWN_ERROR];
		jsString = [result toErrorCallbackString:callBackId];
	}
	
	[self writeJavascript:jsString];
	
    CFRelease(formatter);
	
}

- (void) isDayLightSavingsTime:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	NSDate* date = nil;
	CDVPluginResult* result = nil;
	NSString* jsString = nil;
	NSString* callBackId = [arguments objectAtIndex:0];
	
	id milliseconds = [options valueForKey:@"date"];
	if (milliseconds && [milliseconds isKindOfClass:[NSNumber class]]){
		// get the number of seconds since 1970 and create the date object
		date = [NSDate dateWithTimeIntervalSince1970:[milliseconds doubleValue]/1000];
	}
	
	if(date) {
		// get the current calendar for the user and check if the date is using DST
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSTimeZone* timezone = [calendar timeZone];
		NSNumber* dst = [NSNumber numberWithBool:[timezone isDaylightSavingTimeForDate:date]];
	
		NSDictionary* dictionary = [NSDictionary dictionaryWithObject:dst forKey:@"dst"];
		result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
		jsString = [result toSuccessCallbackString:callBackId];
	}
	// error
	else {
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: UNKNOWN_ERROR];
		jsString = [result toErrorCallbackString:callBackId];
	}
	[self writeJavascript:jsString];
}

- (void) getFirstDayOfWeek:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	CDVPluginResult* result = nil;
	NSString* jsString = nil;
	NSString* callBackId = [arguments objectAtIndex:0];
	
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSNumber* day = [NSNumber numberWithInt:[calendar firstWeekday]];
	
	
	if(day) {
		NSDictionary* dictionary = [NSDictionary dictionaryWithObject:day forKey:@"value"];
		result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
		jsString = [result toSuccessCallbackString:callBackId];
	}
	// error
	else {
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: UNKNOWN_ERROR];
		jsString = [result toErrorCallbackString:callBackId];
	}
	
	[self writeJavascript:jsString];
}

- (void) numberToString:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	CDVPluginResult* result = nil;
	NSString* jsString = nil;
	NSString* callBackId = [arguments objectAtIndex:0];
	CFNumberFormatterStyle style = kCFNumberFormatterDecimalStyle;
	NSNumber* number = nil;
	
	id value = [options valueForKey:@"number"];
	if (value && [value isKindOfClass:[NSNumber class]]){
		number = (NSNumber*)value;
	}
	
	// see if any options have been specified
	id items = [options valueForKey:@"options"];
	if(items && [items isKindOfClass:[NSMutableDictionary class]]) {
		NSEnumerator* enumerator = [items keyEnumerator];
		id key;
		
		// iterate through all the options
		while((key = [enumerator nextObject])) {
			id item = [items valueForKey:key];
			
			// make sure that only string values are present
			if ([item isKindOfClass:[NSString class]]) {
				// get the desired style of formatting
				if([key isEqualToString:@"type"]) {
					if([item isEqualToString:@"percent"]) {
						style = kCFNumberFormatterPercentStyle;
					}
					else if ([item isEqualToString:@"currency"]) {
						style = kCFNumberFormatterCurrencyStyle;
					}
					else if ([item isEqualToString:@"decimal"]) {
						style = kCFNumberFormatterDecimalStyle;
					}
				}
			}
		}
	}
	
	CFNumberFormatterRef formatter = CFNumberFormatterCreate(kCFAllocatorDefault, 
                                                             currentLocale, 
                                                             style);
	
	// get the localized string based upon the locale and user preferences
    NSString *numberString = (NSString *) CFNumberFormatterCreateStringWithNumber(kCFAllocatorDefault, 
                                                                                  formatter, 
                                                                                  (CFNumberRef)number);
	
	if(numberString) {
		NSDictionary* dictionary = [NSDictionary dictionaryWithObject:numberString forKey:@"value"];
		result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
		jsString = [result toSuccessCallbackString:callBackId];
	}
	// error
	else {
		NSLog(@"GlobalizationCommand numberToString unable to format %@", [number stringValue]);
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: FORMATTING_ERROR];
		jsString = [result toErrorCallbackString:callBackId];
	}
	
	[self writeJavascript:jsString];
	
    [numberString release];
    CFRelease(formatter);
}

- (void) stringToNumber:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	CDVPluginResult* result = nil;
	NSString* jsString = nil;
	NSString* callBackId = [arguments objectAtIndex:0];
	CFNumberFormatterStyle style = kCFNumberFormatterDecimalStyle;
	NSString* numberString = nil;
	double doubleValue;
	
	id value = [options valueForKey:@"numberString"];
	if (value && [value isKindOfClass:[NSString class]]){
		numberString = (NSString*)value;
	}
	
	// see if any options have been specified
	id items = [options valueForKey:@"options"];
	if(items && [items isKindOfClass:[NSMutableDictionary class]]) {
		NSEnumerator* enumerator = [items keyEnumerator];
		id key;
		
		// iterate through all the options
		while((key = [enumerator nextObject])) {
			id item = [items valueForKey:key];
			
			// make sure that only string values are present
			if ([item isKindOfClass:[NSString class]]) {
				// get the desired style of formatting
				if([key isEqualToString:@"type"]) {
					if([item isEqualToString:@"percent"]) {
						style = kCFNumberFormatterPercentStyle;
					}
					else if ([item isEqualToString:@"currency"]) {
						style = kCFNumberFormatterCurrencyStyle;
					}
					else if ([item isEqualToString:@"decimal"]) {
						style = kCFNumberFormatterDecimalStyle;
					}
				}
			}
		}
	}

	CFNumberFormatterRef formatter = CFNumberFormatterCreate(kCFAllocatorDefault, 
                                                             currentLocale, 
                                                             style);
    
    // we need to make this lenient so as to avoid problems with parsing currencies that have non-breaking space characters
    if(style == kCFNumberFormatterCurrencyStyle) {
        CFNumberFormatterSetProperty(formatter, kCFNumberFormatterIsLenient, kCFBooleanTrue);
    }
	
	// parse againist the largest type to avoid data loss
	Boolean rc = CFNumberFormatterGetValueFromString(formatter, 
													(CFStringRef)numberString,
													NULL,
													kCFNumberDoubleType, 
													&doubleValue);
	
    if(rc) {
        NSDictionary* dictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:doubleValue] forKey:@"value"];
		result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
		jsString = [result toSuccessCallbackString:callBackId];
    }
	// error
	else {
		NSLog(@"GlobalizationCommand stringToNumber unable to parse %@", numberString);
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PARSING_ERROR];
		jsString = [result toErrorCallbackString:callBackId];
	}
									
	[self writeJavascript:jsString];
	
	CFRelease(formatter);
}

- (void) getNumberPattern:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	CDVPluginResult* result = nil;
	NSString* jsString = nil;
	NSString* callBackId = [arguments objectAtIndex:0];
	CFNumberFormatterStyle style = kCFNumberFormatterDecimalStyle;
	CFStringRef symbolType = NULL;
	NSString* symbol = @"";

	// see if any options have been specified
	id items = [options valueForKey:@"options"];
	if(items && [items isKindOfClass:[NSMutableDictionary class]]) {
		NSEnumerator* enumerator = [items keyEnumerator];
		id key;
		
		// iterate through all the options
		while((key = [enumerator nextObject])) {
			id item = [items valueForKey:key];
			
			// make sure that only string values are present
			if ([item isKindOfClass:[NSString class]]) {
				// get the desired style of formatting
				if([key isEqualToString:@"type"]) {
					if([item isEqualToString:@"percent"]) {
						style = kCFNumberFormatterPercentStyle;
					}
					else if ([item isEqualToString:@"currency"]) {
						style = kCFNumberFormatterCurrencyStyle;
					}
					else if ([item isEqualToString:@"decimal"]) {
						style = kCFNumberFormatterDecimalStyle;
					}
				}
			}
		}
	}

	CFNumberFormatterRef formatter = CFNumberFormatterCreate(kCFAllocatorDefault, 
                                                             currentLocale, 
                                                             style);
    
    NSString* numberPattern = (NSString*)CFNumberFormatterGetFormat(formatter);
	
	if(style == kCFNumberFormatterCurrencyStyle) {
        symbolType = kCFNumberFormatterCurrencySymbol;
    }
    else if (style == kCFNumberFormatterPercentStyle) {
        symbolType = kCFNumberFormatterPercentSymbol;
    }
	
	if(symbolType) {
        symbol = (NSString*) CFNumberFormatterCopyProperty(formatter, symbolType);
    }
	
	NSString* decimal = (NSString*) CFNumberFormatterCopyProperty(formatter, kCFNumberFormatterDecimalSeparator);
	NSString* grouping = (NSString*) CFNumberFormatterCopyProperty(formatter, kCFNumberFormatterGroupingSeparator);
    NSString* posSign = (NSString*) CFNumberFormatterCopyProperty(formatter, kCFNumberFormatterPlusSign);
    NSString* negSign = (NSString*) CFNumberFormatterCopyProperty(formatter, kCFNumberFormatterMinusSign);
    NSNumber* fracDigits = (NSNumber*) CFNumberFormatterCopyProperty(formatter, kCFNumberFormatterMinFractionDigits);
    NSNumber* roundingDigits = (NSNumber*) CFNumberFormatterCopyProperty(formatter, kCFNumberFormatterRoundingIncrement);

	// put the pattern information into the dictionary
	if(numberPattern != nil) {
		NSArray* keys = [NSArray arrayWithObjects:@"pattern",@"symbol",@"fraction",@"rounding",
													@"positive",@"negative", @"decimal",@"grouping",nil];
		NSArray* values = [NSArray arrayWithObjects:numberPattern,symbol,fracDigits,roundingDigits,
													posSign,negSign,decimal,grouping,nil];
		NSDictionary* dictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
		jsString = [result toSuccessCallbackString:callBackId];
    }
	// error
	else {
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PATTERN_ERROR];
		jsString = [result toErrorCallbackString:callBackId];
	}
	
	[self writeJavascript:jsString];
	
	[decimal release];
	[grouping release];
	[posSign release];
	[negSign release];
	[fracDigits release];
	[roundingDigits release];
	[symbol release];
	CFRelease(formatter);
}

- (void) getCurrencyPattern:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	CDVPluginResult* result = nil;
	NSString* jsString = nil;
	NSString* callBackId = [arguments objectAtIndex:0];
	NSString* currencyCode = nil;
	NSString* numberPattern = nil;
	NSString* decimal = nil;
	NSString* grouping = nil;
	int32_t defaultFractionDigits;
	double roundingIncrement;
	Boolean rc;
	
	id value = [options valueForKey:@"currencyCode"];
	if (value && [value isKindOfClass:[NSString class]]){
		currencyCode = (NSString*)value;
	}
	
	// first see if there is base currency info available and fill in the currency_info structure
    rc = CFNumberFormatterGetDecimalInfoForCurrencyCode((CFStringRef)currencyCode, &defaultFractionDigits, &roundingIncrement);
	
	// now set the currency code in the formatter
    if(rc) {
        CFNumberFormatterRef formatter = CFNumberFormatterCreate(kCFAllocatorDefault, 
                                                                 currentLocale, 
                                                                 kCFNumberFormatterCurrencyStyle);
        
        CFNumberFormatterSetProperty(formatter, kCFNumberFormatterCurrencyCode, (CFStringRef)currencyCode);
        CFNumberFormatterSetProperty(formatter, kCFNumberFormatterInternationalCurrencySymbol, (CFStringRef)currencyCode);
        
        numberPattern = (NSString*)CFNumberFormatterGetFormat(formatter);
        decimal = (NSString*) CFNumberFormatterCopyProperty(formatter, kCFNumberFormatterCurrencyDecimalSeparator);
        grouping = (NSString*) CFNumberFormatterCopyProperty(formatter, kCFNumberFormatterCurrencyGroupingSeparator);
		
		NSArray* keys = [NSArray arrayWithObjects:@"pattern",@"code",@"fraction",@"rounding",
													@"decimal",@"grouping",nil];
		NSArray* values = [NSArray arrayWithObjects:numberPattern,currencyCode,[NSNumber numberWithInt:defaultFractionDigits],
													[NSNumber numberWithDouble:roundingIncrement],decimal,grouping,nil];
		NSDictionary* dictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
		jsString = [result toSuccessCallbackString:callBackId];
		CFRelease(formatter);
    }
	// error
	else {
		NSLog(@"GlobalizationCommand getCurrencyPattern unable to get pattern for %@", currencyCode);
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PATTERN_ERROR];
		jsString = [result toErrorCallbackString:callBackId];
	}
	
	[self writeJavascript:jsString];
	
	[decimal release];
	[grouping release];
}
- (void) dealloc {
    if (currentLocale) {
        CFRelease(currentLocale);
        currentLocale = nil;
    }
    [super dealloc];
    
}

@end
