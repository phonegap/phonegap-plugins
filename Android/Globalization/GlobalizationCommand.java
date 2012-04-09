/**
 * 
 */
package com.phonegap.plugins.globalization;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.text.format.Time;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;

import java.text.DateFormat;
import java.text.DateFormatSymbols;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Currency;
import java.util.Date;
import java.util.TimeZone;
import java.util.Locale;

/**
 *
 */
public class GlobalizationCommand extends Plugin  {
	
	@Override
	public PluginResult execute(String action, JSONArray data, String callbackId) {		
		PluginResult.Status status = PluginResult.Status.OK;			
		JSONObject obj = new JSONObject();

		try{			
			if (action.equals(Resources.GETLOCALENAME)){					
				obj = getLocaleName();					
				return new PluginResult(status, obj);				
			}else if(action.equalsIgnoreCase(Resources.DATETOSTRING)){					
				obj = getDateToString(data);				
				return new PluginResult(PluginResult.Status.OK, obj);		
			}else if(action.equalsIgnoreCase(Resources.STRINGTODATE)){					
				obj = getStringtoDate(data);				
				return new PluginResult(PluginResult.Status.OK, obj);		
			}else if(action.equalsIgnoreCase(Resources.GETDATEPATTERN)){
				obj = getDatePattern(data);				
				return new PluginResult(PluginResult.Status.OK, obj);		
			}else if(action.equalsIgnoreCase(Resources.GETDATENAMES)){
				obj = getDateNames(data);				
				return new PluginResult(PluginResult.Status.OK, obj);		
			}else if(action.equalsIgnoreCase(Resources.ISDAYLIGHTSAVINGSTIME)){
				obj = getIsDayLightSavingsTime(data);				
				return new PluginResult(PluginResult.Status.OK, obj);		
			}else if(action.equalsIgnoreCase(Resources.GETFIRSTDAYOFWEEK)){
				obj = getFirstDayOfWeek(data);				
				return new PluginResult(PluginResult.Status.OK, obj);		
			}else if(action.equalsIgnoreCase(Resources.NUMBERTOSTRING)){
				obj = getNumberToString(data);				
				return new PluginResult(PluginResult.Status.OK, obj);		
			}else if(action.equalsIgnoreCase(Resources.STRINGTONUMBER)){
				obj = getStringToNumber(data);				
				return new PluginResult(PluginResult.Status.OK, obj);		
			}else if(action.equalsIgnoreCase(Resources.GETNUMBERPATTERN)){
				obj = getNumberPattern(data);			
				return new PluginResult(PluginResult.Status.OK, obj);		
			}else if(action.equalsIgnoreCase(Resources.GETCURRENCYPATTERN)){
				obj = getCurrencyPattern(data);				
				return new PluginResult(PluginResult.Status.OK, obj);	
			}			
		}catch (GlobalizationError ge){			
			return new PluginResult(PluginResult.Status.ERROR, ge.getErrorCode());			
		}catch (Exception e){			
			return new PluginResult(PluginResult.Status.JSON_EXCEPTION);			
		}	
		return new PluginResult(PluginResult.Status.INVALID_ACTION);		
	}	
	/* 
	 * @Description: Returns the string identifier for the client's current locale setting
	 * 
	 * @Return: JSONObject
	 * 			Object.value {String}: The locale identifier
	 * 
	 * @throws: GlobalizationError.UNKNOWN_ERROR
	 */	
	private JSONObject getLocaleName() throws GlobalizationError{
		JSONObject obj = new JSONObject();
		try{			
			obj.put("value",Locale.getDefault().toString());//get the locale from the Android Device		
			return obj;		
		}catch(Exception e){
			throw new GlobalizationError(GlobalizationError.UNKNOWN_ERROR);
		}		
	}
	/* 
	 * @Description: Returns a date formatted as a string according to the client's user preferences and 
	 * calendar using the time zone of the client. 
	 * 
	 * @Return: JSONObject 
	 * 			Object.value {String}: The localized date string
	 * 
     * @throws: GlobalizationError.FORMATTING_ERROR
	 */	
	private JSONObject getDateToString(JSONArray options) throws GlobalizationError{		
		JSONObject obj = new JSONObject();	
		try{			
			Date date = new Date((Long)options.getJSONObject(0).get(Resources.DATE));
			
			//get formatting pattern from android device (Will only have device specific formatting for short form of date) or options supplied
			JSONObject datePattern = getDatePattern(options);
			SimpleDateFormat fmt = new SimpleDateFormat(datePattern.getString("pattern")); 				
			
			//return formatted date					
			return obj.put("value",fmt.format(date));
		}catch(Exception ge){				
			throw new GlobalizationError(GlobalizationError.FORMATTING_ERROR);
		}	
	}	
	
	/* 
	 * @Description: Parses a date formatted as a string according to the client's user 
	 * preferences and calendar using the time zone of the client and returns
	 * the corresponding date object
	 * @Return: JSONObject
	 *       	Object.year {Number}: The four digit year
     *			Object.month {Number}: The month from (0 - 11)
     *			Object.day {Number}: The day from (1 - 31)
     *			Object.hour {Number}: The hour from (0 - 23)
     *			Object.minute {Number}: The minute from (0 - 59)
     *			Object.second {Number}: The second from (0 - 59)
     *			Object.millisecond {Number}: The milliseconds (from 0 - 999), not available on all platforms
     *
     * @throws: GlobalizationError.PARSING_ERROR
	*/ 	
	private JSONObject getStringtoDate(JSONArray options)throws GlobalizationError{
		JSONObject obj = new JSONObject();	
		Date date;		
		try{			
			//get format pattern from android device (Will only have device specific formatting for short form of date) or options supplied
			DateFormat fmt = new SimpleDateFormat(getDatePattern(options).getString("pattern")); 
			
			//attempt parsing string based on user preferences
			date = fmt.parse(options.getJSONObject(0).get(Resources.DATESTRING).toString());
			
			//set Android Time object
			Time time = new Time();
			time.set(date.getTime());			
			
			//return properties;			
			obj.put("year", time.year);
			obj.put("month", time.month);
			obj.put("day", time.monthDay);
			obj.put("hour", time.hour);
			obj.put("minute", time.minute);
			obj.put("second", time.second);
			obj.put("millisecond", new Long(0));
			return obj;
		}catch(Exception ge){
			throw new GlobalizationError(GlobalizationError.PARSING_ERROR);
		}		
	}	
	
	/* 
	 * @Description: Returns a pattern string for formatting and parsing dates according to the client's 
	 * user preferences.
	 * @Return: JSONObject
	 * 
	 *			Object.pattern {String}: The date and time pattern for formatting and parsing dates. 
	 *									The patterns follow Unicode Technical Standard #35
	 *									http://unicode.org/reports/tr35/tr35-4.html
	 *			Object.timezone {String}: The abbreviated name of the time zone on the client
	 *			Object.utc_offset {Number}: The current difference in seconds between the client's 
	 *										time zone and coordinated universal time. 
	 *			Object.dst_offset {Number}: The current daylight saving time offset in seconds 
	 *										between the client's non-daylight saving's time zone 
	 *										and the client's daylight saving's time zone.
	 *
	 * @throws: GlobalizationError.PATTERN_ERROR
	*/
	private JSONObject getDatePattern(JSONArray options) throws GlobalizationError{
		JSONObject obj = new JSONObject();
		
		try{
			SimpleDateFormat fmtDate = (SimpleDateFormat)android.text.format.DateFormat.getDateFormat(this.ctx.getContext()); //default user preference for date
			SimpleDateFormat fmtTime = (SimpleDateFormat)android.text.format.DateFormat.getTimeFormat(this.ctx.getContext());	//default user preference for time
						
			String fmt = fmtDate.toLocalizedPattern() + " " + fmtTime.toLocalizedPattern(); //default SHORT date/time format. ex. dd/MM/yyyy h:mm a
						
			//get Date value + options (if available)	
			if (options.getJSONObject(0).length() > 1){
				//options were included
				
				//get formatLength option				
				if (!((JSONObject)options.getJSONObject(0).get(Resources.OPTIONS)).isNull(Resources.FORMATLENGTH)){					
					String fmtOpt = (String)((JSONObject)options.getJSONObject(0).get(Resources.OPTIONS)).get(Resources.FORMATLENGTH);
					if (fmtOpt.equalsIgnoreCase(Resources.MEDIUM)){//medium
						fmtDate = (SimpleDateFormat)android.text.format.DateFormat.getMediumDateFormat(this.ctx.getContext());						
					}else if (fmtOpt.equalsIgnoreCase(Resources.LONG) || fmtOpt.equalsIgnoreCase(Resources.FULL)){ //long/full
						fmtDate = (SimpleDateFormat)android.text.format.DateFormat.getLongDateFormat(this.ctx.getContext());
					}
				}
				
				//return pattern type	
				fmt = fmtDate.toLocalizedPattern() + " " + fmtTime.toLocalizedPattern();
				if (!((JSONObject)options.getJSONObject(0).get(Resources.OPTIONS)).isNull(Resources.SELECTOR)){
					String selOpt = (String)((JSONObject)options.getJSONObject(0).get(Resources.OPTIONS)).get(Resources.SELECTOR);
					if (selOpt.equalsIgnoreCase(Resources.DATE)){
						fmt =  fmtDate.toLocalizedPattern();
					}else if (selOpt.equalsIgnoreCase(Resources.TIME)){
						fmt = fmtTime.toLocalizedPattern();
					}						
				}				
			}			
						
			//TimeZone from users device		
			//TimeZone tz = Calendar.getInstance(Locale.getDefault()).getTimeZone(); //substitute method		
			TimeZone tz = TimeZone.getTimeZone(Time.getCurrentTimezone());			
			
			obj.put("pattern", fmt);
			obj.put("timezone", tz.getDisplayName(tz.inDaylightTime(Calendar.getInstance().getTime()),TimeZone.SHORT));
			obj.put("utc_offset", tz.getRawOffset()/1000);
			obj.put("dst_offset", tz.getDSTSavings()/1000);			
			return obj;
			
		}catch(Exception ge){				
			throw new GlobalizationError(GlobalizationError.PATTERN_ERROR);
		}	
	}
	
	/* 
	 * @Description: Returns an array of either the names of the months or days of the week 
	 * according to the client's user preferences and calendar
	 * @Return: JSONObject
	 * 			Object.value {Array{String}}: The array of names starting from either 
	 *										the first month in the year or the 
	 *										first day of the week.
	 * 
	 * @throws: GlobalizationError.UNKNOWN_ERROR
	*/
	private JSONObject getDateNames(JSONArray options) throws GlobalizationError{
		JSONObject obj = new JSONObject();		
		//String[] value;
		JSONArray value = new JSONArray();	
		String[] list;
		try{			
			SimpleDateFormat s = (SimpleDateFormat)android.text.format.DateFormat.getDateFormat(this.ctx.getContext());
			DateFormatSymbols ds = s.getDateFormatSymbols();
			int type = 0; //default wide
			int item = 0; //default months			
			
			//get options if available
			if (options.getJSONObject(0).length() > 0){
				//get type if available
				if (!((JSONObject)options.getJSONObject(0).get(Resources.OPTIONS)).isNull(Resources.TYPE)){	
					String t = (String)((JSONObject)options.getJSONObject(0).get(Resources.OPTIONS)).get(Resources.TYPE);
					if (t.equalsIgnoreCase(Resources.NARROW)){type++;} //DateUtils.LENGTH_MEDIUM
				}
				//get item if available
				if (!((JSONObject)options.getJSONObject(0).get(Resources.OPTIONS)).isNull(Resources.ITEM)){	
					String t = (String)((JSONObject)options.getJSONObject(0).get(Resources.OPTIONS)).get(Resources.ITEM);
					if (t.equalsIgnoreCase(Resources.DAYS)){item += 10;} //Days of week start at 1
				}				
			}
			//determine return value
			int method = item + type;
			if  (method == 1){list = ds.getShortMonths();}//months and narrow
			else if (method == 10){list = ds.getWeekdays();}//days and wide
			else if (method == 11){list = ds.getShortWeekdays();}//days and narrow
			else{list = ds.getMonths();}//default: months and wide				
			
			//convert String[] into JSONArray of String objects 
			for (int i = 0; i < list.length; i ++){
				value.put(list[i]);
			}			

			//return array of names			
			return obj.put("value", value);				
		}catch(Exception ge){				
			throw new GlobalizationError(GlobalizationError.UNKNOWN_ERROR);
		}			
	}
	
	/* 
	 * @Description: Returns whether daylight savings time is in effect for a given date using the client's 
	 * time zone and calendar.
	 * @Return: JSONObject
	 * 			Object.dst {Boolean}: The value "true" indicates that daylight savings time is 
	 *								in effect for the given date and "false" indicate that it is not.	 * 
	 * 
	 * @throws: GlobalizationError.UNKNOWN_ERROR
	*/
	private JSONObject getIsDayLightSavingsTime(JSONArray options) throws GlobalizationError{
		JSONObject obj = new JSONObject();
		boolean dst = false;
		try{
			Date date = new Date((Long)options.getJSONObject(0).get(Resources.DATE));
			//TimeZone tz = Calendar.getInstance(Locale.getDefault()).getTimeZone();
			TimeZone tz = TimeZone.getTimeZone(Time.getCurrentTimezone());
			dst = tz.inDaylightTime(date); //get daylight savings data from date object and user timezone settings	
			
			return obj.put("dst",dst);		
		}catch(Exception ge){				
			throw new GlobalizationError(GlobalizationError.UNKNOWN_ERROR);
		}				
	}	
	
	/* 
	 * @Description: Returns the first day of the week according to the client's user preferences and calendar. 
	 * The days of the week are numbered starting from 1 where 1 is considered to be Sunday.
	 * @Return: JSONObject
	 * 			Object.value {Number}: The number of the first day of the week.
	 * 
	 * @throws: GlobalizationError.UNKNOWN_ERROR
	*/
	private JSONObject getFirstDayOfWeek(JSONArray options) throws GlobalizationError{
		JSONObject obj = new JSONObject();		
		try{			
			int value = Calendar.getInstance(Locale.getDefault()).getFirstDayOfWeek(); //get first day of week based on user locale settings
			return obj.put("value", value);
		}catch(Exception ge){				
			throw new GlobalizationError(GlobalizationError.UNKNOWN_ERROR);
		}			
	}	
	
	/* 
	 * @Description: Returns a number formatted as a string according to the client's user preferences. 
	 * @Return: JSONObject
	 * 			Object.value {String}: The formatted number string. 
	 * 
	 * @throws: GlobalizationError.FORMATTING_ERROR
	*/
	private JSONObject getNumberToString(JSONArray options) throws GlobalizationError{
		JSONObject obj = new JSONObject();	
		String value = "";
		try{
			DecimalFormat fmt = getNumberFormatInstance(options);//returns Decimal/Currency/Percent instance
			value = fmt.format(options.getJSONObject(0).get(Resources.NUMBER));
			return obj.put("value", value);					
		}catch(Exception ge){	
			throw new GlobalizationError(GlobalizationError.FORMATTING_ERROR);
		}			
	}	
	
	/* 
	 * @Description: Parses a number formatted as a string according to the client's user preferences and 
	 * returns the corresponding number.
	 * @Return: JSONObject 
	 * 			Object.value {Number}: The parsed number.
	 * 
	 * @throws: GlobalizationError.PARSING_ERROR
	*/
	private JSONObject getStringToNumber(JSONArray options) throws GlobalizationError{
		JSONObject obj = new JSONObject();	
		Number value;
		try{
			DecimalFormat fmt = getNumberFormatInstance(options); //returns Decimal/Currency/Percent instance
			value = fmt.parse((String)options.getJSONObject(0).get(Resources.NUMBERSTRING));	
			return obj.put("value", value);						
		}catch(Exception ge){				
			throw new GlobalizationError(GlobalizationError.PARSING_ERROR);
		}			
	}
	
	/* 
	 * @Description: Returns a pattern string for formatting and parsing numbers according to the client's user 
	 * preferences.
	 * @Return: JSONObject
	 * 			Object.pattern {String}: The number pattern for formatting and parsing numbers. 
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
	 * @throws: GlobalizationError.PATTERN_ERROR
	*/
	private JSONObject getNumberPattern(JSONArray options) throws GlobalizationError{
		JSONObject obj = new JSONObject();		
		try{				
			//uses java.text.DecimalFormat to format value			
			DecimalFormat fmt = (DecimalFormat) DecimalFormat.getInstance(Locale.getDefault());	//default format	
			String symbol = String.valueOf(fmt.getDecimalFormatSymbols().getDecimalSeparator());
			//get Date value + options (if available)	
			if (options.getJSONObject(0).length() > 0){
				//options were included
				if (!((JSONObject)options.getJSONObject(0).get(Resources.OPTIONS)).isNull(Resources.TYPE)){					
					String fmtOpt = (String)((JSONObject)options.getJSONObject(0).get(Resources.OPTIONS)).get(Resources.TYPE);
					if (fmtOpt.equalsIgnoreCase(Resources.CURRENCY)){
						fmt = (DecimalFormat) DecimalFormat.getCurrencyInstance(Locale.getDefault());
						symbol = fmt.getDecimalFormatSymbols().getCurrencySymbol();
					}else if(fmtOpt.equalsIgnoreCase(Resources.PERCENT)){
						fmt = (DecimalFormat) DecimalFormat.getPercentInstance(Locale.getDefault());
						symbol = String.valueOf(fmt.getDecimalFormatSymbols().getPercent());						
					}
				}
			}							
					
			//return properties			
			obj.put("pattern", fmt.toPattern());
			obj.put("symbol", symbol);
			obj.put("fraction", fmt.getMinimumFractionDigits());
			obj.put("rounding", new Integer(0));
			obj.put("positive", fmt.getPositivePrefix());
			obj.put("negative", fmt.getNegativePrefix());
			obj.put("decimal", String.valueOf(fmt.getDecimalFormatSymbols().getDecimalSeparator()));
			obj.put("grouping", String.valueOf(fmt.getDecimalFormatSymbols().getGroupingSeparator()));						
						
			return obj;			
		}catch(Exception ge){				
			throw new GlobalizationError(GlobalizationError.PATTERN_ERROR);
		}		
	}	
	
	/* 
	 * @Description: Returns a pattern string for formatting and parsing currency values according to the client's
	 * user preferences and ISO 4217 currency code.
	 * @Return: JSONObject
	 * 			Object.pattern {String}: The currency pattern for formatting and parsing currency values. 
	 *									The patterns follow Unicode Technical Standard #35 
	 *									http://unicode.org/reports/tr35/tr35-4.html
	 *			Object.code {String}: The ISO 4217 currency code for the pattern.
	 *			Object.fraction {Number}: The number of fractional digits to use when parsing and 
	 *									formatting currency.
	 *			Object.rounding {Number}: The rounding increment to use when parsing and formatting.
	 *			Object.decimal: {String}: The decimal symbol to use for parsing and formatting.
	 *			Object.grouping: {String}: The grouping symbol to use for parsing and formatting.
	 * 
	 * @throws: GlobalizationError.FORMATTING_ERROR
	*/
	private JSONObject getCurrencyPattern(JSONArray options) throws GlobalizationError{
		JSONObject obj = new JSONObject();	
		try{	
			//get ISO 4217 currency code
			String code = options.getJSONObject(0).getString(Resources.CURRENCYCODE);			
			
			//uses java.text.DecimalFormat to format value			
			DecimalFormat fmt = (DecimalFormat) DecimalFormat.getCurrencyInstance(Locale.getDefault());
			
			//set currency format
			Currency currency = Currency.getInstance(code);
			fmt.setCurrency(currency);
			
			//return properties			
			obj.put("pattern", fmt.toPattern());
			obj.put("code", currency.getCurrencyCode());
			obj.put("fraction", fmt.getMinimumFractionDigits());
			obj.put("rounding", new Integer(0));
			obj.put("decimal", String.valueOf(fmt.getDecimalFormatSymbols().getDecimalSeparator()));
			obj.put("grouping", String.valueOf(fmt.getDecimalFormatSymbols().getGroupingSeparator()));			
			
			return obj;			
		}catch(Exception ge){				
			throw new GlobalizationError(GlobalizationError.FORMATTING_ERROR);
		}		
	}
	
	/* 
	 * @Description: Parses a JSONArray from user options and returns the correct Instance of Decimal/Percent/Currency.
	 * @Return: DecimalFormat : The Instance to use.
	 *  
	 * @throws: JSONException
	*/
	private DecimalFormat getNumberFormatInstance(JSONArray options) throws JSONException{		
		DecimalFormat fmt =  (DecimalFormat)DecimalFormat.getInstance(Locale.getDefault()); //default format
		try{			 
			if (options.getJSONObject(0).length() > 1){
				//options were included				
				if (!((JSONObject)options.getJSONObject(0).get(Resources.OPTIONS)).isNull(Resources.TYPE)){					
					String fmtOpt = (String)((JSONObject)options.getJSONObject(0).get(Resources.OPTIONS)).get(Resources.TYPE);
					if (fmtOpt.equalsIgnoreCase(Resources.CURRENCY)){
						fmt = (DecimalFormat)DecimalFormat.getCurrencyInstance(Locale.getDefault());
					}else if(fmtOpt.equalsIgnoreCase(Resources.PERCENT)){
						fmt = (DecimalFormat)DecimalFormat.getPercentInstance(Locale.getDefault());	
					}
				}
			}
			
		}catch (JSONException je){}		
		return fmt;
	}
}
