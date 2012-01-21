//
//  calendar.js
//
//  Created by Felix Montanez on 01-17-2012
//  MIT Licensed
//
//  Copyright 2012 AMFMMultiMedia. All Rights Reserved.
//
 

function calendarPlugin()
{
};


calendarPlugin.prototype.createEvent = function(title,location,notes,startDate,endDate) {
    //PhoneGap.exec('calendarPlugin.createEvent');
    PhoneGap.exec(null, null, "calendarPlugin", "createEvent", [title,location,notes,startDate,endDate]);
};


calendarPlugin.install = function()
{
    if(!window.plugins)
    {
        window.plugins = {};
    }
    
    window.plugins.calendarPlugin = new calendarPlugin();
    return window.plugins.calendarPlugin;
};

PhoneGap.addConstructor(calendarPlugin.install);
