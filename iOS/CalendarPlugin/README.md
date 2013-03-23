# Calendar #
**日历插件** 

获取日历项，创建新日历项
## Adding the Plugin to your project 添加到项目工程 ##
1. 将 **calendar.js** 添加到 www/ 目录下，并将calendar.js的声明放到html文件中phonegap.js引用声明之后
	<pre><code>&lt;script type="text/javascript" charset="utf-8" src="phonegap.js"></script>
&lt;script type="text/javascript" charset="utf-8" src="calendar.js"></script></code></pre>
2. 将 .h 和 .m 插件源文件导入项目工程内
3. 添加 EventKit.framework 和 EventKitUI.framework 到工程内
4. 在config.xml中添加<pre><code>&lt;plugin name="calendarPlugin" value="calendarPlugin"/></code></pre>

## Usage 用法 ##
### sina.Calendar.createEventDefault(onSuccess,onError) ###
采用系统默认控件创建日历项

* onSuccess 创建成功时的回调方法，返回值为String类型
* onError 创建失败时的回调方法，返回值为String类型

例如：
<pre><javascript>sina.Calendar.createEventDefault(function(successResult){ // 创建成功时的回调方法
                                     console.log("success: "+successResult);
                                     },
                                     function(errorResult){ // 创建失败时的回调方法
                                     console.log("error: "+errorResult);
                                     });
</javascript></pre>

###sina.Calendar.createEventQuiet(onSuccess,onError,options)###
自定义创建日历项

* onSuccess 创建成功时的回调方法，返回值为String类型
* onError 创建失败时的回调方法，返回值为String类型
* options 自定义日历项参数设置，为Array数组类型 **[title,startDate,endDate,location,message,url,alarmRule,repeatRule]** 
	* title 日历项的标题：字符串类型
	* startDate 日历项的开始时间：String字符串类型（格式：yyyy-MM-dd HH:mm）
	* endDate 日历项的结束时间：String字符串类型（格式：yyyy-MM-dd HH:mm）
	* location 日历项的位置描述：String字符串类型
	* message 日历项的备注信息：String字符串类型
	* url 日历项的链接URL：String字符串类型
	* alarmRule 日历项的提醒规则：整数类型，单位毫秒（null表示无提醒，负整数表示提前提醒，正整数表示后续提醒）
	* repeatRule 日历项的重复规则：[sina.Calendar.RecurType][005]类型
	
例如：
<pre><javascript>sina.Calendar.createEventQuiet(function(successResult){ // 创建成功时的回调方法
                                   console.log("success: "+successResult);
                                   },
                                   function(errorResult){ // 创建失败时的回调方法
                                   console.log("error: "+errorResult);
                                   },
                                   ['helloworld', // title
                                    '2013-04-10 12:23', // startDate
                                    '2013-04-10 22:23', // endDate
                                    null, // location
                                    'to remind', // message
                                    'sina.com.cn', // url
                                    null, // alarmRule
                                    0]); // repeatRule
</javascript></pre>

###sina.Calendar.getEventList(onSuccess,onError,options)###
获取符合规则的日历项列表

* onSuccess 获取成功时的回调方法，返回值为 **Array数组类型** ，其中数组每一项均为 **CalendarEvent** 字典对象
	* CalendarEvent 内包括如下项
		- title 日历项的标题：String字符串类型
		- location 日历项的位置描述：String字符串类型
		- url 日历项的链接URL：String字符串类型
		- startDate 日历项的开始时间：String字符串类型（格式：yyyy-MM-dd HH:mm）
		- endDate 日历项的结束时间：String字符串类型（格式：yyyy-MM-dd HH:mm）
		- isRepeat 是否重复事件：bool布尔值类型
		- isAllDay 是否全天事件：bool布尔值类型
* onError 操作失败时的回调方法，返回值为String类型
* options 所要获取的日历项列表条件：Array数组类型 **[startDate,endDate]** 
	* startDate 筛选的开始时间：String字符串类型（格式：yyyy-MM-dd HH:mm）
	* endDate 筛选的结束时间：String字符串类型（格式：yyyy-MM-dd HH:mm）
	
例如：
<pre><javascript>sina.Calendar.getEventList(function(response){ // 完成时的回调方法
                               console.log("success: "+response.length);
                               console.log("title:"+response[0].title);
                               console.log("location:"+response[0].location);
                               console.log("url:"+response[0].url);
                               console.log("start:"+response[0].startDate);
                               console.log("end:"+response[0].endDate);
                               },
                               function(errorResult){ // 操作失败时的回调方法
                               console.log("error: "+errorResult);
                               },
                               ['2012-04-10 12:23', // 筛选的开始时间
                                '2014-04-10 12:23']); // 筛选的结束时间
</javascript></pre>

[005]:#sinacalendarrecurtype "RecurType"
###sina.Calendar.RecurType###
用来定义日历项的 **重复规则** ，枚举类型

* none 不重复：0
* daily 每日重复：1
* weekly 每周重复：2
* monthly 每月重复：3
* yearly 每年重复：4

例如：
<pre><javascript>sina.Calendar.RecurType['daily'] // 每日重复
sina.Calendar.RecurType['none'] // 不重复
</javascript></pre>