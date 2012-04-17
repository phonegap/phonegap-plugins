/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 * 
 * Copyright (c) 2011, IBM Corporation
 */

#import <Foundation/Foundation.h>
#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif


#define FORMAT_SHORT    0
#define FORMAT_MEDIUM   1
#define FORMAT_LONG     2
#define FORMAT_FULL     3
#define SELECTOR_MONTHS 0
#define SELECTOR_DAYS   1

enum GlobalizationError {
	UNKNOWN_ERROR = 0,
	FORMATTING_ERROR = 1,
	PARSING_ERROR = 2,
	PATTERN_ERROR = 3,
};
typedef NSUInteger GlobalizationError;


@interface Globalization : CDVPlugin {
    CFLocaleRef currentLocale;
}
/**
 * Returns the string identifier for the client’s current locale setting.
 * It returns the locale identifier string to the successCB callback with a 
 * properties object as a parameter. If there is an error getting the locale, 
 * then the errorCB callback is invoked.
*/
- (void) getLocaleName:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

/**
 * Returns a date formatted as a string according to the client’s user preferences and 
 * calendar using the time zone of the client. It returns the formatted date string to the 
 * successCB callback with a properties object as a parameter. If there is an error 
 * formatting the date, then the errorCB callback is invoked. 
 *
 * options: "date" contains the number of milliseconds that represents the JavaScript date
*/
- (void) dateToString:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

/**
 * Parses a date formatted as a string according to the client’s user 
 * preferences and calendar using the time zone of the client and returns 
 * the corresponding date object. It returns the date to the successCB 
 * callback with a properties object as a parameter. If there is an error 
 * parsing the date string, then the errorCB callback is invoked.
 *
 * options: "dateString" contains the JavaScript string to parse for a date
*/
- (void) stringToDate:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

/**
 * Returns a pattern string for formatting and parsing dates according to the client’s 
 * user preferences. It returns the pattern to the successCB callback with a 
 * properties object as a parameter. If there is an error obtaining the pattern, 
 * then the errorCB callback is invoked.
 *
*/ 
- (void) getDatePattern:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

/**
 * Returns an array of either the names of the months or days of the week 
 * according to the client’s user preferences and calendar. It returns the array of names to the 
 * successCB callback with a properties object as a parameter. If there is an error obtaining the 
 * names, then the errorCB callback is invoked.
 *
*/ 
- (void) getDateNames:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

/**
 * Returns whether daylight savings time is in effect for a given date using the client’s 
 * time zone and calendar. It returns whether or not daylight savings time is in effect 
 * to the successCB callback with a properties object as a parameter. If there is an error 
 * reading the date, then the errorCB callback is invoked.
 *
 * options: "date" contains the number of milliseconds that represents the JavaScript date
 *
*/ 
- (void) isDayLightSavingsTime:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

/**
 * Returns the first day of the week according to the client’s user preferences and calendar. 
 * The days of the week are numbered starting from 1 where 1 is considered to be Sunday. 
 * It returns the day to the successCB callback with a properties object as a parameter. 
 * If there is an error obtaining the pattern, then the errorCB callback is invoked.
 *
*/ 
- (void) getFirstDayOfWeek:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

/**
 * Returns a number formatted as a string according to the client’s user preferences. 
 * It returns the formatted number string to the successCB callback with a properties object as a 
 * parameter. If there is an error formatting the number, then the errorCB callback is invoked.
 *
 * options: "number" contains the JavaScript number to format
 *
*/ 
- (void) numberToString:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

/**
 * Parses a number formatted as a string according to the client’s user preferences and 
 * returns the corresponding number. It returns the number to the successCB callback with a
 * properties object as a parameter. If there is an error parsing the number string, then 
 * the errorCB callback is invoked.
 *
 * options: "numberString" contains the JavaScript string to parse for a number
 *
*/ 
- (void) stringToNumber:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

/**
 * Returns a pattern string for formatting and parsing numbers according to the client’s user 
 * preferences. It returns the pattern to the successCB callback with a properties object as a 
 * parameter. If there is an error obtaining the pattern, then the errorCB callback is invoked.
 *
*/ 
- (void) getNumberPattern:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

/**
 * Returns a pattern string for formatting and parsing currency values according to the client’s 
 * user preferences and ISO 4217 currency code. It returns the pattern to the successCB callback with a 
 * properties object as a parameter. If there is an error obtaining the pattern, then the errorCB 
 * callback is invoked.
 *
 * options: "currencyCode" contains the ISO currency code from JavaScript
*/
- (void) getCurrencyPattern:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
