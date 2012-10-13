/**
	Cordova DatePicker Plugin
	Copyright (c) Greg Allen 2011
	MIT Licensed
**/

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
        var padDate = function(date) {
          if (date.length == 1) {
            return ("0" + date);
          }
          return date;
        };

        if (options.defaultDate) {
            options.defaultDate = options.defaultDate.getFullYear() + "-" +
                           padDate(options.defaultDate.getMonth()+1) + "-" +
                           padDate(options.defaultDate.getDate()) +
                           "T" + padDate(options.defaultDate.getHours()) + ":" +
                           padDate(options.defaultDate.getMinutes()) + ":00Z";
        }
        if (options.startDate) {
            options.startDate = options.startDate.getFullYear() + "-" +
                           padDate(options.startDate.getMonth()+1) + "-" +
                           padDate(options.startDate.getDate()) +
                           "T" + padDate(options.startDate.getHours()) + ":" +
                           padDate(options.startDate.getMinutes()) + ":00Z";
        }
        if (options.endDate) {
            options.endDate = options.endDate.getFullYear() + "-" +
                           padDate(options.endDate.getMonth()+1) + "-" +
                           padDate(options.endDate.getDate()) +
                           "T" + padDate(options.endDate.getHours()) + ":" +
                           padDate(options.endDate.getMinutes()) + ":00Z";
        }
        var defaults = {
            mode: 'datetime',
            defaultDate: '',
            startDate: '',
            endDate: '',            
            allowOldDates: true,
            allowFutureDates : true
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