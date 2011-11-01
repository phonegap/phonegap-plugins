/**
	Phonegap DatePicker Plugin
	Copyright (c) Greg Allen 2011
	MIT Licensed
**/
if (typeof PhoneGap !== "undefined") {
    /**
     * Constructor
     */
    function DatePicker() {
        this._callback;
    }

    /**
     * show - true to show the ad, false to hide the ad
     */
    DatePicker.prototype.show = function(options, cb) {
        if (options.date) {
            options.date = (options.date.getMonth()+1)+"/"+(options.date.getDate())+"/"+(options.date.getFullYear());
        }
        var defaults = {
            mode: '',
            date: '',
            allowOldDates: true
        }
        for (var key in defaults) {
            if (typeof options[key] !== "undefined")
                defaults[key] = options[key];
        }
        this._callback = cb;
        PhoneGap.exec("DatePicker.show", defaults);
    }

    DatePicker.prototype._dateSelected = function(date) {
        var d = new Date(parseFloat(date)*1000);
        if (this._callback)
            this._callback(d);
    }


    PhoneGap.addConstructor(function() {
        if(!window.plugins)
        {
            window.plugins = {};
        }
        window.plugins.datePicker = new DatePicker();
    });
};
