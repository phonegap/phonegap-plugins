var cordova = window.cordova;
sina={};

var Calendar = function(){};

//title fromdate todate location notes url alarmRule repeateRule
//yyyy-MM-dd HH:mm
Calendar.prototype.createEventQuiet=function(success,error,options){
    cordova.exec(success,error,'CalendarPlugin','createEventQuiet',options);
}

Calendar.prototype.createEventDefault=function(success,error){
    cordova.exec(success,error,'CalendarPlugin','createEventDefault',[]);
}

// startdate enddate
// title location url startDate endDate isRepeat isAllDay
// yyyy-MM-dd HH:mm
Calendar.prototype.getEventList=function(success,error,options){
    cordova.exec(success,error,'CalendarPlugin','getEventList',options);
}

if(!sina.Calendar){
    sina.Calendar=new Calendar();
}

// 重复提醒类型
sina.Calendar.RecurType={
    none    :0,
    daily   :1,
    weekly  :2,
    monthly :3,
    yearly  :4,
};