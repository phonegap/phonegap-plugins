	
function Globalization()
{

};
	
/**
* Returns the string identifier for the client's current locale setting.
* It returns the locale identifier string to the successCB callback with a 
* properties object as a parameter. If there is an error getting the locale, 
* then the errorCB callback is invoked.
*
* @param {Function} successCB
* @param {Function} errorCB
*
* @return Object.value {String}: The locale identifier
*
* @error GlobalizationError.UNKNOWN_ERROR 
*
* Example
*	globalization.getLocaleName(function (locale) {alert('locale:' + locale.value + '\n');}, 
*								function () {});
*/	
Globalization.prototype.getLocaleName = function(successCB, failureCB)
{
	// successCallback required
	if (typeof successCB != "function") {	
        console.log("Globalization.getLocaleName Error: successCB is not a function");
        return;
    }
	
    // errorCallback required
    if (typeof failureCB != "function") {        
    	console.log("Globalization.getLocaleName Error: failureCB is not a function");
        return;
    }
	cordova.exec(successCB, failureCB, "GlobalizationCommand","getLocaleName", []);
};

	
/**
* Returns a date formatted as a string according to the client's user preferences and 
* calendar using the time zone of the client. It returns the formatted date string to the 
* successCB callback with a properties object as a parameter. If there is an error 
* formatting the date, then the errorCB callback is invoked. 
*
* The defaults are: formatLenght="short" and selector="date and time"
*
* @param {Date} date 
* @param {Function} successCB
* @param {Function} errorCB
* @param {Object} options {optional}
*			formatLength {String}: 'short', 'medium', 'long', or 'full'
*			selector {String}: 'date', 'time', or 'date and time' 
* 
* @return Object.value {String}: The localized date string
*
* @error GlobalizationError.FORMATTING_ERROR 
*
* Example
*	globalization.dateToString(new Date(),
*				function (date) {alert('date:' + date.value + '\n');},
*				function (errorCode) {alert(errorCode);},
*				{formatLength:'short'}); 
*/	
Globalization.prototype.dateToString = function(date, successCB, failureCB, options)
{
	// successCallback required
	if (typeof successCB != "function") {
        console.log("Globalization.dateToString Error: successCB is not a function");
        return;
    }
	
    // errorCallback required
    if (typeof failureCB != "function") {
        console.log("Globalization.dateToString Error: failureCB is not a function");
        return;
    }
	
	
	if (date instanceof Date){
		var dateValue;
		dateValue = date.valueOf();		
		cordova.exec(successCB, failureCB, "GlobalizationCommand", "dateToString", [{"date": dateValue, "options": options}]);
	}
	else {
		console.log("Globalization.dateToString Error: date is not a Date object");
	}
};


/**
* Parses a date formatted as a string according to the client's user 
* preferences and calendar using the time zone of the client and returns 
* the corresponding date object. It returns the date to the successCB 
* callback with a properties object as a parameter. If there is an error 
* parsing the date string, then the errorCB callback is invoked.
*
* The defaults are: formatLength="short" and selector="date and time"
*
* @param {String} dateString 
* @param {Function} successCB
* @param {Function} errorCB
* @param {Object} options {optional}
*			formatLength {String}: 'short', 'medium', 'long', or 'full'
*			selector {String}: 'date', 'time', or 'date and time' 
* 
* @return	Object.year {Number}: The four digit year
*			Object.month {Number}: The month from (0 - 11)
*			Object.day {Number}: The day from (1 - 31)
*			Object.hour {Number}: The hour from (0 - 23)
*			Object.minute {Number}: The minute from (0 - 59)
*			Object.second {Number}: The second from (0 - 59)
*			Object.millisecond {Number}: The milliseconds (from 0 - 999), 
*										not available on all platforms
* 
* @error GlobalizationError.PARSING_ERROR
*
* Example
*	globalization.stringToDate('4/11/2011',
*				function (date) { alert('Month:' + date.month + '\n' +
*					'Day:' + date.day + '\n' +
*					'Year:' + date.year + '\n');},
*				function (errorCode) {alert(errorCode);},
*				{selector:'date'});
*/	
Globalization.prototype.stringToDate = function(dateString, successCB, failureCB, options)
{
	// successCallback required
	if (typeof successCB != "function") {
        console.log("Globalization.stringToDate Error: successCB is not a function");
        return;
    }
	
    // errorCallback required
    if (typeof failureCB != "function") {
        console.log("Globalization.stringToDate Error: failureCB is not a function");
        return;
    }	
	if (typeof dateString == "string"){
		cordova.exec(successCB, failureCB, "GlobalizationCommand", "stringToDate", [{"dateString": dateString, "options": options}]);
	}
	else {
		console.log("Globalization.stringToDate Error: dateString is not a string");
	}
};

	
/**
* Returns a pattern string for formatting and parsing dates according to the client's 
* user preferences. It returns the pattern to the successCB callback with a 
* properties object as a parameter. If there is an error obtaining the pattern, 
* then the errorCB callback is invoked.
*
* The defaults are: formatLength="short" and selector="date and time"
*
* @param {Function} successCB
* @param {Function} errorCB
* @param {Object} options {optional}
*			formatLength {String}: 'short', 'medium', 'long', or 'full'
*			selector {String}: 'date', 'time', or 'date and time' 
* 
* @return	Object.pattern {String}: The date and time pattern for formatting and parsing dates. 
*									The patterns follow Unicode Technical Standard #35
*									http://unicode.org/reports/tr35/tr35-4.html
*			Object.timezone {String}: The abbreviated name of the time zone on the client
*			Object.utc_offset {Number}: The current difference in seconds between the client's 
*										time zone and coordinated universal time. 
*			Object.dst_offset {Number}: The current daylight saving time offset in seconds 
*										between the client's non-daylight saving's time zone 
*										and the client's daylight saving's time zone.
*
* @error GlobalizationError.PATTERN_ERROR
*
* Example
*	globalization.getDatePattern(new Date(),
*				function (date) {alert('pattern:' + date.pattern + '\n');},
*				function () {},
*				{formatLength:'short'});
*/	
Globalization.prototype.getDatePattern = function(successCB, failureCB, options)
{
	// successCallback required
	if (typeof successCB != "function") {
        console.log("Globalization.getDatePattern Error: successCB is not a function");
        return;
    }
	
    // errorCallback required
    if (typeof failureCB != "function") {
        console.log("Globalization.getDatePattern Error: failureCB is not a function");
        return;
    }
	
	cordova.exec(successCB, failureCB, "GlobalizationCommand", "getDatePattern", [{"options": options}]);
};

	
/**
* Returns an array of either the names of the months or days of the week 
* according to the client's user preferences and calendar. It returns the array of names to the 
* successCB callback with a properties object as a parameter. If there is an error obtaining the 
* names, then the errorCB callback is invoked.
*
* The defaults are: type="wide" and item="months"
*
* @param {Function} successCB
* @param {Function} errorCB
* @param {Object} options {optional}
*			type {String}: 'narrow' or 'wide'
*			item {String}: 'months', or 'days' 
* 
* @return Object.value {Array{String}}: The array of names starting from either 
*										the first month in the year or the 
*										first day of the week.
* @error GlobalizationError.UNKNOWN_ERROR
*
* Example
*	globalization.getDateNames(function (names) { 
*		for(var i = 0; i < names.value.length; i++) {
*			alert('Month:' + names.value[i] + '\n');}},
*		function () {});
*/	
Globalization.prototype.getDateNames = function(successCB, failureCB, options)
{
	// successCallback required
	if (typeof successCB != "function") {
        console.log("Globalization.getDateNames Error: successCB is not a function");
        return;
    }
	
    // errorCallback required
    if (typeof failureCB != "function") {
        console.log("Globalization.getDateNames Error: failureCB is not a function");
        return;
    }
    cordova.exec(successCB, failureCB, "GlobalizationCommand", "getDateNames", [{"options": options}]);
};

/**
* Returns whether daylight savings time is in effect for a given date using the client's 
* time zone and calendar. It returns whether or not daylight savings time is in effect 
* to the successCB callback with a properties object as a parameter. If there is an error 
* reading the date, then the errorCB callback is invoked.
*
* @param {Date} date
* @param {Function} successCB
* @param {Function} errorCB 
* 
* @return Object.dst {Boolean}: The value "true" indicates that daylight savings time is 
*								in effect for the given date and "false" indicate that it is not.
*
* @error GlobalizationError.UNKNOWN_ERROR
*
* Example
*	globalization.isDayLightSavingsTime(new Date(),
*				function (date) {alert('dst:' + date.dst + '\n');}
*				function () {});
*/	
Globalization.prototype.isDayLightSavingsTime = function(date, successCB, failureCB)
{
	// successCallback required
	if (typeof successCB != "function") {
        console.log("Globalization.isDayLightSavingsTime Error: successCB is not a function");
        return;
    }
	
    // errorCallback required
    if (typeof failureCB != "function") {
        console.log("Globalization.isDayLightSavingsTime Error: failureCB is not a function");
        return;
    }
	
	
	if (date instanceof Date){
		var dateValue;
		dateValue = date.valueOf();
		cordova.exec(successCB, failureCB, "GlobalizationCommand", "isDayLightSavingsTime", [{"date": dateValue}]);
	}
	else {
		console.log("Globalization.isDayLightSavingsTime Error: date is not a Date object");
	}
	
};

/**
* Returns the first day of the week according to the client's user preferences and calendar. 
* The days of the week are numbered starting from 1 where 1 is considered to be Sunday. 
* It returns the day to the successCB callback with a properties object as a parameter. 
* If there is an error obtaining the pattern, then the errorCB callback is invoked.
*
* @param {Function} successCB
* @param {Function} errorCB 
* 
* @return Object.value {Number}: The number of the first day of the week.
*
* @error GlobalizationError.UNKNOWN_ERROR
*
* Example
*	globalization.getFirstDayOfWeek(function (day) 
*				{ alert('Day:' + day.value + '\n');},
*				function () {});
*/	
Globalization.prototype.getFirstDayOfWeek = function(successCB, failureCB)
{
	// successCallback required
	if (typeof successCB != "function") {
        console.log("Globalization.getFirstDayOfWeek Error: successCB is not a function");
        return;
    }
	
    // errorCallback required
    if (typeof failureCB != "function") {
        console.log("Globalization.getFirstDayOfWeek Error: failureCB is not a function");
        return;
    }
	
	cordova.exec(successCB, failureCB, "GlobalizationCommand", "getFirstDayOfWeek", []);
};

	
/**
* Returns a number formatted as a string according to the client's user preferences. 
* It returns the formatted number string to the successCB callback with a properties object as a 
* parameter. If there is an error formatting the number, then the errorCB callback is invoked.
*
* The defaults are: type="decimal"
*
* @param {Number} number
* @param {Function} successCB
* @param {Function} errorCB
* @param {Object} options {optional}
*			type {String}: 'decimal', "percent", or 'currency'
* 
* @return Object.value {String}: The formatted number string.
*
* @error GlobalizationError.FORMATTING_ERROR
*
* Example
*	globalization.numberToString(3.25,
*				function (number) {alert('number:' + number.value + '\n');},
*				function () {},
*				{type:'decimal'});
*/	
Globalization.prototype.numberToString = function(number, successCB, failureCB, options)
{
	// successCallback required
	if (typeof successCB != "function") {
        console.log("Globalization.numberToString Error: successCB is not a function");
        return;
    }
	
    // errorCallback required
    if (typeof failureCB != "function") {
        console.log("Globalization.numberToString Error: failureCB is not a function");
        return;
    }
	
	if(typeof number == "number") {
		cordova.exec(successCB, failureCB, "GlobalizationCommand", "numberToString", [{"number": number, "options": options}]);
	}
	else {
		console.log("Globalization.numberToString Error: number is not a number");
	}
};

/**
* Parses a number formatted as a string according to the client's user preferences and 
* returns the corresponding number. It returns the number to the successCB callback with a
* properties object as a parameter. If there is an error parsing the number string, then 
* the errorCB callback is invoked.
*
* The defaults are: type="decimal"
*
* @param {String} numberString
* @param {Function} successCB
* @param {Function} errorCB
* @param {Object} options {optional}
*			type {String}: 'decimal', "percent", or 'currency'
* 
* @return Object.value {Number}: The parsed number.
*
* @error GlobalizationError.PARSING_ERROR
*
* Example
*	globalization.stringToNumber('1234.56',
*				function (number) {alert('Number:' + number.value + '\n');},
*				function () { alert('Error parsing number');});
*/	
Globalization.prototype.stringToNumber = function(numberString, successCB, failureCB, options)
{
	// successCallback required
	if (typeof successCB != "function") {
        console.log("Globalization.stringToNumber Error: successCB is not a function");
        return;
    }
	
    // errorCallback required
    if (typeof failureCB != "function") {
        console.log("Globalization.stringToNumber Error: failureCB is not a function");
        return;
    }
	
	if(typeof numberString == "string") {
		cordova.exec(successCB, failureCB, "GlobalizationCommand", "stringToNumber", [{"numberString": numberString, "options": options}]);
	}
	else {
		console.log("Globalization.stringToNumber Error: numberString is not a string");
	}
};

/**
* Returns a pattern string for formatting and parsing numbers according to the client's user 
* preferences. It returns the pattern to the successCB callback with a properties object as a 
* parameter. If there is an error obtaining the pattern, then the errorCB callback is invoked.
*
* The defaults are: type="decimal"
*
* @param {Function} successCB
* @param {Function} errorCB
* @param {Object} options {optional}
*			type {String}: 'decimal', "percent", or 'currency'
* 
* @return	Object.pattern {String}: The number pattern for formatting and parsing numbers. 
*									The patterns follow Unicode Technical Standard #35. 
*									http://unicode.org/reports/tr35/tr35-4.html
*			Object.symbol {String}: The symbol to be used when formatting and parsing 
*									e.g., percent or currency symbol.
*			Object.fraction {Number}: The number of fractional digits to use when parsing and 
*									formatting numbers.
*			Object.rounding {Number}: The rounding increment to use when parsing and formatting.
*			Object.positive {String}: The symbol to use for positive numbers when parsing and formatting.
*			Object.negative: {String}: The symbol to use for negative numbers when parsing and formatting.
*			Object.decimal: {String}: The decimal symbol to use for parsing and formatting.
*			Object.grouping: {String}: The grouping symbol to use for parsing and formatting.
*
* @error GlobalizationError.PATTERN_ERROR
*
* Example
*	globalization.getNumberPattern(
*				function (pattern) {alert('Pattern:' + pattern.pattern + '\n');},
*				function () {});
*/	
Globalization.prototype.getNumberPattern = function(successCB, failureCB, options)
{
	// successCallback required
	if (typeof successCB != "function") {
        console.log("Globalization.getNumberPattern Error: successCB is not a function");
        return;
    }
	
    // errorCallback required
    if (typeof failureCB != "function") {
        console.log("Globalization.getNumberPattern Error: failureCB is not a function");
        return;
    }
	
	cordova.exec(successCB, failureCB, "GlobalizationCommand", "getNumberPattern", [{"options": options}]);	
};

/**
* Returns a pattern string for formatting and parsing currency values according to the client's 
* user preferences and ISO 4217 currency code. It returns the pattern to the successCB callback with a 
* properties object as a parameter. If there is an error obtaining the pattern, then the errorCB 
* callback is invoked.
*
* @param {String} currencyCode	
* @param {Function} successCB
* @param {Function} errorCB
* 
* @return	Object.pattern {String}: The currency pattern for formatting and parsing currency values. 
*									The patterns follow Unicode Technical Standard #35 
*									http://unicode.org/reports/tr35/tr35-4.html
*			Object.code {String}: The ISO 4217 currency code for the pattern.
*			Object.fraction {Number}: The number of fractional digits to use when parsing and 
*									formatting currency.
*			Object.rounding {Number}: The rounding increment to use when parsing and formatting.
*			Object.decimal: {String}: The decimal symbol to use for parsing and formatting.
*			Object.grouping: {String}: The grouping symbol to use for parsing and formatting.
*
* @error GlobalizationError.FORMATTING_ERROR
*
* Example
*	globalization.getCurrencyPattern('EUR',
*				function (currency) {alert('Pattern:' + currency.pattern + '\n');}
*				function () {});
*/	
Globalization.prototype.getCurrencyPattern = function(currencyCode, successCB, failureCB)
{
	// successCallback required
	if (typeof successCB != "function") {
        console.log("Globalization.getCurrencyPattern Error: successCB is not a function");
        return;
    }
	
    // errorCallback required
    if (typeof failureCB != "function") {
        console.log("Globalization.getCurrencyPattern Error: failureCB is not a function");
        return;
    }
	
	if(typeof currencyCode == "string") {
		cordova.exec(successCB, failureCB, "GlobalizationCommand", "getCurrencyPattern", [{"currencyCode": currencyCode}]);
	}
	else {
		console.log("Globalization.getCurrencyPattern Error: currencyCode is not a currency code");
	}
};
cordova.addConstructor(function()
{
	cordova.addPlugin('globalization', new Globalization());
});

GlobalizationError = function() {
	this.code = null;
}

// Globalization error codes
GlobalizationError.UNKNOWN_ERROR = 0;
GlobalizationError.FORMATTING_ERROR = 1;
GlobalizationError.PARSING_ERROR = 2;
GlobalizationError.PATTERN_ERROR = 3;
