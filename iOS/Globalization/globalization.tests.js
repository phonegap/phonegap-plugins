Tests.prototype.GlobalizationTests = function() {	
	module('Globalization (window.plugins.globalization)');
	// use these varibales to hold the formatted string results that we will later use during parsing
	// this is necessary so that we can execute the tests in all locales.
	var formattedDefaultDate;
	var formattedShortDate;
	var formattedFullDate;
	var formattedDefaultNumber;
	var formattedPercentNumber;
	test("should exist", function() {
  		expect(1);
  		ok(window.plugins.globalization != null, "window.plugins.globalization should not be null.");
	});
	test("should contain a getLocaleName function", function() {
		expect(2);
		ok(typeof window.plugins.globalization.getLocaleName != 'undefined' && window.plugins.globalization.getLocaleName != null, "window.plugins.globalization.getLocaleName should not be null.");
		ok(typeof window.plugins.globalization.getLocaleName == 'function', "window.plugins.globalization.getLocaleName should be a function.");
	});
	test("getLocaleName success callback should be called with a Properties object", function() {
		 expect(4);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in getLocaleName success callback should be of type 'object'.");
			ok(a.value != null, "Properties object returned in getLocaleName success callback should have an 'value' property.");
			ok(typeof a.value == 'string', "Properties object's 'value' property returned in getLocaleName success callback should be of type 'string'.");
			ok(a.value.length > 0, "Properties object's 'value' property returned in getLocaleName success callback should have an length greater than 0.");	
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.getLocaleName(win, fail);
	});
	
	test("should contain a dateToString function", function() {
		 expect(2);
		 ok(typeof window.plugins.globalization.dateToString != 'undefined' && window.plugins.globalization.dateToString != null, "window.plugins.globalization.dateToString should not be null.");
		 ok(typeof window.plugins.globalization.dateToString == 'function', "window.plugins.globalization.dateToString should be a function.");
	});
	test("dateToString using default options, success callback should be called with a Properties object", function() {
		 expect(4);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in dateToString success callback should be of type 'object'.");
			ok(a.value != null, "Properties object returned in dateToString success callback should have an 'value' property.");
			ok(typeof a.value == 'string', "Properties object's 'value' property returned in dateToString success callback should be of type 'string'.");
			ok(a.value.length > 0, "Properties object's 'value' property returned in dateToString success callback should have an length greater than 0.");
			// save the formatted result to use during the parsing tests
			formattedDefaultDate = a.value;
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.dateToString(new Date(), win, fail);
	});
	test("dateToString using formatLength=short and selector=date options, success callback should be called with a Properties object", function() {
		 expect(4);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in dateToString success callback should be of type 'object'.");
			ok(a.value != null, "Properties object returned in dateToString success callback should have an 'value' property.");
			ok(typeof a.value == 'string', "Properties object's 'value' property returned in dateToString success callback should be of type 'string'.");
			ok(a.value.length > 0, "Properties object's 'value' property returned in dateToString success callback should have an length greater than 0.");	
			// save the formatted result to use during the parsing tests
			formattedShortDate = a.value;
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.dateToString(new Date(), win, fail, {formatLength: 'short', selector: 'date'});
	});
	test("dateToString using formatLength=full and selector=date options, success callback should be called with a Properties object", function() {
		 expect(4);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in dateToString success callback should be of type 'object'.");
			ok(a.value != null, "Properties object returned in dateToString success callback should have an 'value' property.");
			ok(typeof a.value == 'string', "Properties object's 'value' property returned in dateToString success callback should be of type 'string'.");
			ok(a.value.length > 0, "Properties object's 'value' property returned in dateToString success callback should have an length greater than 0.");	
			// save the formatted result to use during the parsing tests
			formattedFullDate = a.value;
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.dateToString(new Date(), win, fail, {formatLength: 'full', selector: 'date'});
	});
	test("should contain a stringToDate function", function() {
		 expect(2);
		 ok(typeof window.plugins.globalization.stringToDate != 'undefined' && window.plugins.globalization.stringToDate != null, "window.plugins.globalization.stringToDate should not be null.");
		 ok(typeof window.plugins.globalization.stringToDate == 'function', "window.plugins.globalization.stringToDate should be a function.");
	});
	test("stringToDate using default options, success callback should be called with a Properties object", function() {
		 expect(14);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in stringToDate success callback should be of type 'object'.");
			ok(typeof a.year == 'number', "Properties object's 'year' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.year >= 0 && a.year <=9999, "Properties object returned in stringToDate success callback should have a year less than 9999.");
			ok(typeof a.month == 'number', "Properties object's 'month' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.month >= 0 && a.month <=11, "Properties object returned in stringToDate success callback should have a month betweeen 0 and 11.");
			ok(typeof a.day == 'number', "Properties object's 'day' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.day >= 1 && a.day <=31, "Properties object returned in stringToDate success callback should have a day betweeen 1 and 31.");
			ok(typeof a.hour == 'number', "Properties object's 'hour' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.hour >= 0 && a.hour <=23, "Properties object returned in stringToDate success callback should have an hour betweeen 0 and 23.");
			ok(typeof a.minute == 'number', "Properties object's 'minute' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.minute >= 0 && a.minute <=59, "Properties object returned in stringToDate success callback should have a minute betweeen 0 and 59.");
			ok(typeof a.second == 'number', "Properties object's 'second' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.second >= 0 && a.second <=59, "Properties object returned in stringToDate success callback should have a second betweeen 0 and 59.");
			ok(typeof a.millisecond == 'number', "Properties object's 'millisecond' property returned in stringToDate success callback should be of type 'number'.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.stringToDate(formattedDefaultDate, win, fail);
	});
	test("stringToDate using formatLength=short and selector=date options, success callback should be called with a Properties object", function() {
		 expect(14);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in stringToDate success callback should be of type 'object'.");
			ok(typeof a.year == 'number', "Properties object's 'year' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.year >= 0 && a.year <=9999, "Properties object returned in stringToDate success callback should have a year less than 9999.");
			ok(typeof a.month == 'number', "Properties object's 'month' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.month >= 0 && a.month <=11, "Properties object returned in stringToDate success callback should have a month betweeen 0 and 11.");
			ok(typeof a.day == 'number', "Properties object's 'day' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.day >= 1 && a.day <=31, "Properties object returned in stringToDate success callback should have a day betweeen 1 and 31.");
			ok(typeof a.hour == 'number', "Properties object's 'hour' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.hour >= 0 && a.hour <=23, "Properties object returned in stringToDate success callback should have an hour betweeen 0 and 23.");
			ok(typeof a.minute == 'number', "Properties object's 'minute' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.minute >= 0 && a.minute <=59, "Properties object returned in stringToDate success callback should have a minute betweeen 0 and 59.");
			ok(typeof a.second == 'number', "Properties object's 'second' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.second >= 0 && a.second <=59, "Properties object returned in stringToDate success callback should have a second betweeen 0 and 59.");
			ok(typeof a.millisecond == 'number', "Properties object's 'millisecond' property returned in stringToDate success callback should be of type 'number'.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.stringToDate(formattedShortDate, win, fail, {formatLength: 'short', selector: 'date'});
	});
	test("stringToDate using formatLength=full and selector=date options, success callback should be called with a Properties object", function() {
		 expect(14);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in stringToDate success callback should be of type 'object'.");
			ok(typeof a.year == 'number', "Properties object's 'year' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.year >= 0 && a.year <=9999, "Properties object returned in stringToDate success callback should have a year less than 9999.");
			ok(typeof a.month == 'number', "Properties object's 'month' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.month >= 0 && a.month <=11, "Properties object returned in stringToDate success callback should have a month betweeen 0 and 11.");
			ok(typeof a.day == 'number', "Properties object's 'day' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.day >= 1 && a.day <=31, "Properties object returned in stringToDate success callback should have a day betweeen 1 and 31.");
			ok(typeof a.hour == 'number', "Properties object's 'hour' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.hour >= 0 && a.hour <=23, "Properties object returned in stringToDate success callback should have an hour betweeen 0 and 23.");
			ok(typeof a.minute == 'number', "Properties object's 'minute' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.minute >= 0 && a.minute <=59, "Properties object returned in stringToDate success callback should have a minute betweeen 0 and 59.");
			ok(typeof a.second == 'number', "Properties object's 'second' property returned in stringToDate success callback should be of type 'number'.");
			ok(a.second >= 0 && a.second <=59, "Properties object returned in stringToDate success callback should have a second betweeen 0 and 59.");
			ok(typeof a.millisecond == 'number', "Properties object's 'millisecond' property returned in stringToDate success callback should be of type 'number'.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.stringToDate(formattedFullDate, win, fail, {formatLength: 'full', selector: 'date'});
	});
	test("should contain a getDatePattern function", function() {
		 expect(2);
		 ok(typeof window.plugins.globalization.getDatePattern != 'undefined' && window.plugins.globalization.getDatePattern != null, "window.plugins.globalization.getDatePattern should not be null.");
		 ok(typeof window.plugins.globalization.getDatePattern == 'function', "window.plugins.globalization.getDatePattern should be a function.");
	});
	test("getDatePattern using default options, success callback should be called with a Properties object", function() {
		 expect(7);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in getDatePattern success callback should be of type 'object'.");
			ok(typeof a.pattern == 'string', "Properties object's 'pattern' property returned in getDatePattern success callback should be of type 'string'.");
			ok(a.pattern.length > 0, "Properties object's 'pattern' property returned in getDatePattern success callback should have an length greater than 0.");
			ok(typeof a.timezone == 'string', "Properties object's 'timezone' property returned in getDatePattern success callback should be of type 'string'.");
			ok(a.timezone.length > 0, "Properties object's 'timezone' property returned in getDatePattern success callback should have an length greater than 0.");
			ok(typeof a.utc_offset == 'number', "Properties object's 'utc_offset' property returned in getDatePattern success callback should be of type 'number'.");
			ok(typeof a.dst_offset == 'number', "Properties object's 'dst_offset' property returned in getDatePattern success callback should be of type 'number'.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.getDatePattern(win, fail);
	});
	test("getDatePattern using formatLength=medium and selector=date options, success callback should be called with a Properties object", function() {
		 expect(7);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in getDatePattern success callback should be of type 'object'.");
			ok(typeof a.pattern == 'string', "Properties object's 'pattern' property returned in getDatePattern success callback should be of type 'string'.");
			ok(a.pattern.length > 0, "Properties object's 'pattern' property returned in getDatePattern success callback should have an length greater than 0.");
			ok(typeof a.timezone == 'string', "Properties object's 'timezone' property returned in getDatePattern success callback should be of type 'string'.");
			ok(a.timezone.length > 0, "Properties object's 'timezone' property returned in getDatePattern success callback should have an length greater than 0.");
			ok(typeof a.utc_offset == 'number', "Properties object's 'utc_offset' property returned in getDatePattern success callback should be of type 'number'.");
			ok(typeof a.dst_offset == 'number', "Properties object's 'dst_offset' property returned in getDatePattern success callback should be of type 'number'.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.getDatePattern(win, fail, {formatLength: 'medium', selector: 'date'});
	});
	test("should contain a getDateNames function", function() {
		 expect(2);
		 ok(typeof window.plugins.globalization.getDateNames != 'undefined' && window.plugins.globalization.getDateNames != null, "window.plugins.globalization.getDateNames should not be null.");
		 ok(typeof window.plugins.globalization.getDateNames == 'function', "window.plugins.globalization.getDateNames should be a function.");
	});
	test("getDateNames using default options, success callback should be called with a Properties object", function() {
		 expect(5);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in getDateNames success callback should be of type 'object'.");
			ok(a.value != null, "Properties object returned in getDateNames success callback should have an 'value' property.");
			ok(a.value instanceof Array, "Properties object's 'value' property returned in getDateNames success callback should be an instance of an 'Array'.");
			ok(a.value.length > 0, "Properties object's 'value' property returned in getDateNames success callback should have an length greater than 0.");
			ok(typeof a.value[0] == 'string', "Properties object's 'Array' values returned in getDateNames success callback should be of type 'string'.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.getDateNames(win, fail);
	});
	test("getDateNames using type=narrow and item=days options, success callback should be called with a Properties object", function() {
		 expect(5);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in getDateNames success callback should be of type 'object'.");
			ok(a.value != null, "Properties object returned in getDateNames success callback should have an 'value' property.");
			ok(a.value instanceof Array, "Properties object's 'value' property returned in getDateNames success callback should be an instance of an 'Array'.");
			ok(a.value.length > 0, "Properties object's 'value' property returned in getDateNames success callback should have an length greater than 0.");
			ok(typeof a.value[0] == 'string', "Properties object's 'Array' values returned in getDateNames success callback should be of type 'string'.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.getDateNames(win, fail, {type: 'narrow', item: 'days'});
	});
	test("should contain a isDayLightSavingsTime function", function() {
		 expect(2);
		 ok(typeof window.plugins.globalization.isDayLightSavingsTime != 'undefined' && window.plugins.globalization.isDayLightSavingsTime != null, "window.plugins.globalization.isDaylightSavingsTime should not be null.");
		 ok(typeof window.plugins.globalization.isDayLightSavingsTime == 'function', "window.plugins.globalization.isDayLightSavingsTime should be a function.");
	});
	test("isDayLightSavingsTime	success callback should be called with a Properties object", function() {
		 expect(3);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in isDayLightSavingsTime success callback should be of type 'object'.");
			ok(a.dst != null, "Properties object returned in isDayLightSavingsTime success callback should have an 'dst' property.");
			ok(typeof a.dst == 'boolean', "Properties object's 'dst' property returned in isDayLightSavingsTime success callback should be of type 'boolean'.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.isDayLightSavingsTime(new Date(), win, fail);
	});
	test("should contain a getFirstDayOfWeek function", function() {
		 expect(2);
		 ok(typeof window.plugins.globalization.getFirstDayOfWeek != 'undefined' && window.plugins.globalization.getFirstDayOfWeek != null, "window.plugins.globalization.getFirstDayOfWeek should not be null.");
		 ok(typeof window.plugins.globalization.getFirstDayOfWeek == 'function', "window.plugins.globalization.getFirstDayOfWeek should be a function.");
	});
	test("getFirstDayOfWeek success callback should be called with a Properties object", function() {
		 expect(3);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in getFirstDayOfWeek success callback should be of type 'object'.");
			ok(a.value != null, "Properties object returned in getFirstDayOfWeek success callback should have an 'value' property.");
			ok(typeof a.value == 'number', "Properties object's 'value' property returned in getFirstDayOfWeek success callback should be of type 'number'.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.getFirstDayOfWeek(win, fail);
	});
	test("should contain a numberToString function", function() {
		 expect(2);
		 ok(typeof window.plugins.globalization.numberToString != 'undefined' && window.plugins.globalization.numberToString != null, "window.plugins.globalization.numberToString should not be null.");
		 ok(typeof window.plugins.globalization.numberToString == 'function', "window.plugins.globalization.numberToString should be a function.");
	});
	test("numberToString using default options, success callback should be called with a Properties object", function() {
		 expect(4);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in numberToString success callback should be of type 'object'.");
			ok(a.value != null, "Properties object returned in numberToString success callback should have an 'value' property.");
			ok(typeof a.value == 'string', "Properties object's 'value' property returned in numberToString success callback should be of type 'string'.");
			ok(a.value.length > 0, "Properties object's 'value' property returned in numberToString success callback should have an length greater than 0.");
			// save the formatted result to use during parsing
			formattedDefaultNumber = a.value;
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.numberToString(3.25, win, fail);
	});
	test("numberToString using type=percent options, success callback should be called with a Properties object", function() {
		 expect(4);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in numberToString success callback should be of type 'object'.");
			ok(a.value != null, "Properties object returned in numberToString success callback should have an 'value' property.");
			ok(typeof a.value == 'string', "Properties object's 'value' property returned in numberToString success callback should be of type 'string'.");
			ok(a.value.length > 0, "Properties object's 'value' property returned in numberToString success callback should have an length greater than 0.");
			// save the formatted result to use during parsing
			formattedPercentNumber = a.value;
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.numberToString(.25, win, fail, {type: 'percent'});
	});
	test("should contain a stringToNumber function", function() {
		 expect(2);
		 ok(typeof window.plugins.globalization.stringToNumber != 'undefined' && window.plugins.globalization.stringToNumber != null, "window.plugins.globalization.stringToNumber should not be null.");
		 ok(typeof window.plugins.globalization.stringToNumber == 'function', "window.plugins.globalization.stringToNumber should be a function.");
	});
	test("stringToNumber using default options, success callback should be called with a Properties object", function() {
		 expect(4);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in stringToNumber success callback should be of type 'object'.");
			ok(a.value != null, "Properties object returned in stringToNumber success callback should have an 'value' property.");
			ok(typeof a.value == 'number', "Properties object's 'value' property returned in stringToNumber success callback should be of type 'number'.");
			ok(a.value > 0, "Properties object's 'value' property returned in stringToNumber success callback should have a value greater than 0.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.stringToNumber(formattedDefaultNumber, win, fail);
	});
	test("stringToNumber using type=percent options, success callback should be called with a Properties object", function() {
		 expect(4);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in stringToNumber success callback should be of type 'object'.");
			ok(a.value != null, "Properties object returned in stringToNumber success callback should have an 'value' property.");
			ok(typeof a.value == 'number', "Properties object's 'value' property returned in stringToNumber success callback should be of type 'number'.");
			ok(a.value > 0, "Properties object's 'value' property returned in stringToNumber success callback should have a value greater than 0.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.stringToNumber(formattedPercentNumber, win, fail, {type: 'percent'});
	});
	test("should contain a getNumberPattern function", function() {
		 expect(2);
		 ok(typeof window.plugins.globalization.getNumberPattern != 'undefined' && window.plugins.globalization.getNumberPattern != null, "window.plugins.globalization.getNumberPattern should not be null.");
		 ok(typeof window.plugins.globalization.getNumberPattern == 'function', "window.plugins.globalization.getNumberPattern should be a function.");
	});
	test("getNumberPattern using default options, success callback should be called with a Properties object", function() {
		 expect(14);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in getNumberPattern success callback should be of type 'object'.");
			ok(typeof a.pattern == 'string', "Properties object's 'pattern' property returned in getNumberPattern success callback should be of type 'string'.");
			ok(a.pattern.length > 0, "Properties object's 'pattern' property returned in getNumberPattern success callback should have an length greater than 0.");
			ok(typeof a.symbol == 'string', "Properties object's 'symbol' property returned in getNumberPattern success callback should be of type 'string'.");
			ok(typeof a.fraction == 'number', "Properties object's 'fraction' property returned in getNumberPattern success callback should be of type 'number'.");
			ok(typeof a.rounding == 'number', "Properties object's 'rounding' property returned in getNumberPattern success callback should be of type 'number'.");
			ok(typeof a.positive == 'string', "Properties object's 'positive' property returned in getNumberPattern success callback should be of type 'string'.");
			ok(a.positive.length > 0, "Properties object's 'positive' property returned in getNumberPattern success callback should have an length greater than 0.");
			ok(typeof a.negative == 'string', "Properties object's 'negative' property returned in getNumberPattern success callback should be of type 'string'.");
			ok(a.negative.length > 0, "Properties object's 'negative' property returned in getNumberPattern success callback should have an length greater than 0.");
			ok(typeof a.decimal == 'string', "Properties object's 'decimal' property returned in getNumberPattern success callback should be of type 'string'.");
			ok(a.decimal.length > 0, "Properties object's 'decimal' property returned in getNumberPattern success callback should have an length greater than 0.");
			ok(typeof a.grouping == 'string', "Properties object's 'grouping' property returned in getNumberPattern success callback should be of type 'string'.");
			ok(a.grouping.length > 0, "Properties object's 'grouping' property returned in getNumberPattern success callback should have an length greater than 0.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.getNumberPattern(win, fail);
	});
	test("getNumberPattern using type=percent options, success callback should be called with a Properties object", function() {
		 expect(15);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in getNumberPattern success callback should be of type 'object'.");
			ok(typeof a.pattern == 'string', "Properties object's 'pattern' property returned in getNumberPattern success callback should be of type 'string'.");
			ok(a.pattern.length > 0, "Properties object's 'pattern' property returned in getNumberPattern success callback should have an length greater than 0.");
			ok(typeof a.symbol == 'string', "Properties object's 'symbol' property returned in getNumberPattern success callback should be of type 'string'.");
			ok(a.symbol.length > 0, "Properties object's 'symbol' property returned in getNumberPattern success callback should have an length greater than 0.");
			ok(typeof a.fraction == 'number', "Properties object's 'fraction' property returned in getNumberPattern success callback should be of type 'number'.");
			ok(typeof a.rounding == 'number', "Properties object's 'rounding' property returned in getNumberPattern success callback should be of type 'number'.");
			ok(typeof a.positive == 'string', "Properties object's 'positive' property returned in getNumberPattern success callback should be of type 'string'.");
			ok(a.positive.length > 0, "Properties object's 'positive' property returned in getNumberPattern success callback should have an length greater than 0.");
			ok(typeof a.negative == 'string', "Properties object's 'negative' property returned in getNumberPattern success callback should be of type 'string'.");
			ok(a.negative.length > 0, "Properties object's 'negative' property returned in getNumberPattern success callback should have an length greater than 0.");
			ok(typeof a.decimal == 'string', "Properties object's 'decimal' property returned in getNumberPattern success callback should be of type 'string'.");
			ok(a.decimal.length > 0, "Properties object's 'decimal' property returned in getNumberPattern success callback should have an length greater than 0.");
			ok(typeof a.grouping == 'string', "Properties object's 'grouping' property returned in getNumberPattern success callback should be of type 'string'.");
			ok(a.grouping.length > 0, "Properties object's 'grouping' property returned in getNumberPattern success callback should have an length greater than 0.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.getNumberPattern(win, fail, {type: 'percent'});
	});
	test("should contain a getCurrencyPattern function", function() {
		 expect(2);
		 ok(typeof window.plugins.globalization.getCurrencyPattern != 'undefined' && window.plugins.globalization.getCurrencyPattern != null, "window.plugins.globalization.getCurrencyPattern should not be null.");
		 ok(typeof window.plugins.globalization.getCurrencyPattern == 'function', "window.plugins.globalization.getCurrencyPattern should be a function.");
	});
	test("getCurrencyPattern using EUR for currency, success callback should be called with a Properties object", function() {
		 expect(11);
		 QUnit.stop(Tests.TEST_TIMEOUT);
		 var win = function(a) {
			ok(typeof a == 'object', "Properties object returned in getCurrencyPattern success callback should be of type 'object'.");
			ok(typeof a.pattern == 'string', "Properties object's 'pattern' property returned in getCurrencyPattern success callback should be of type 'string'.");
			ok(a.pattern.length > 0, "Properties object's 'pattern' property returned in getCurrencyPattern success callback should have an length greater than 0.");
			ok(typeof a.code == 'string', "Properties object's 'code' property returned in getCurrencyPattern success callback should be of type 'string'.");
			ok(a.code.length > 0, "Properties object's 'code' property returned in getCurrencyPattern success callback should have an length greater than 0.");
			ok(typeof a.fraction == 'number', "Properties object's 'fraction' property returned in getCurrencyPattern success callback should be of type 'number'.");
			ok(typeof a.rounding == 'number', "Properties object's 'rounding' property returned in getCurrencyPattern success callback should be of type 'number'.");
			ok(typeof a.decimal == 'string', "Properties object's 'decimal' property returned in getCurrencyPattern success callback should be of type 'string'.");
			ok(a.decimal.length > 0, "Properties object's 'decimal' property returned in getCurrencyPattern success callback should have an length greater than 0.");
			ok(typeof a.grouping == 'string', "Properties object's 'grouping' property returned in getCurrencyPattern success callback should be of type 'string'.");
			ok(a.grouping.length > 0, "Properties object's 'grouping' property returned in getCurrencyPattern success callback should have an length greater than 0.");
			start();
		 };
		 var fail = function() { start(); };
		 window.plugins.globalization.getCurrencyPattern("EUR", win, fail);
	});
};