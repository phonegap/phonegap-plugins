
/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2011, IBM Corporation
 */


/**
 * Object representing a geolocation to encode.
 */
var BarcodeLocation = function() {
    this.longitude = null;
    this.latitude = null;
};

/**
 * Object representing the information of a contact to encode.
 */
var BarcodeContact = function() {
    this.address = null;
    this.birthday = null;
    this.email = null;
    this.name = null;
    this.nickname = null;
    this.note = null;
    this.telephone = null;
    this.url = null;
};

/**
 * window.plugins.barcodeScanner
 *
 * Provides barcode scanning and encoding functionality.
 */
var BarcodeScanner = BarcodeScanner || (function() {
    /**
     * Check that window.plugins.barcodeScanner has not been initialized.
     */
    if (typeof window.plugins.barcodeScanner !== "undefined") {
        return;
    }

    /**
     * Supported formats for text encoding.  TEXT, EMAIL, PHONE and SMS are
     * sent as text strings. CONTACT must be of the form BarcodeContact and
     * LOCATION of the form BarcodeLocation.
     */
    var EncodeFormat = {
        TEXT : "TEXT",
        EMAIL : "EMAIL",
        PHONE : "PHONE",
        SMS : "SMS",
        CONTACT : "CONTACT",
        LOCATION : "LOCATION"
    };

    /**
     * Format of image that is returned from encode.
     *
     * Example: window.plugins.barcodescanner.encode(
     *      BarcodeScanner.EncodeFormat.TEXT,
     *      text,
     *      success, fail, {
     *          width: 300,
     *          height: 300,
     *          destinationType: BarcodeScanner.DestinationType.DATA_URL});
     */
    var DestinationType = {
        DATA_URL: 0                 // Return base64 encoded string
    };

    function BarcodeScanner() {
    }

    BarcodeScanner.prototype.scan = function(success, fail) {
        if (typeof options != 'undefined') {

        }
        return cordova.exec(function(args) {
            success(args);
        }, function(args) {
            fail(args);
        }, 'BarcodeScanner', 'scan', [ ]);
    };

    BarcodeScanner.prototype.encode = function(type, data, success, fail,
            options) {
        var targetWidth = 200;
        var targetHeight = 200;
        var destinationType = DestinationType.DATA_URL;

        if (typeof options !== 'undefined') {
            if (typeof options.width === 'number') {
                targetWidth = options.width;
            } else if (typeof options.width === 'string') {
                var wdth = new Number(options.width);
                if (isNaN(wdth) === false) {
                    targetWidth = wdth.valueOf();
                }
            }

            if (typeof options.height === 'number') {
                targetHeight = options.height;
            } else if (typeof options.height === 'string') {
                var hght = new Number(options.height);
                if (isNaN(hght) === false) {
                    targetHeight = hght.valueOf();
                }
            }

            if (typeof options.destinationType === 'number') {
                destinationType = options.destinationType;
            } else if (typeof options.destinationType === 'string') {
                var dest = new Number(options.destinationType);
                if (isNaN(dest) === false) {
                    destinationType = dest.valueOf();
                }
            }
        }

        var params = [ type, destinationType, targetWidth, targetHeight, data ];

        if (typeof type === 'string') {
            var encodeType = type.toUpperCase();
            if (encodeType === EncodeFormat.CONTACT) {
                if (data !== 'undefined' && data instanceof BarcodeContact) {
                    params = [ type, destinationType, targetWidth,
                            targetHeight, data.address, data.birthday,
                            data.email, data.name, data.nickname, data.note,
                            data.telephone, data.url ];
                }
            } else if (encodeType === EncodeFormat.LOCATION) {
                if (data !== 'undefined' && data instanceof BarcodeLocation) {
                    params = [ type, destinationType, targetWidth,
                            targetHeight, data.latitude, data.longitude ];
                }
            }
        }

        return cordova.exec(function(args) {
            success(args);
        }, function(args) {
            fail(args);
        }, 'BarcodeScanner', 'encode', params);
    };

    cordova.addConstructor(function() {
        cordova.addPlugin('barcodeScanner', new BarcodeScanner());
    });

    /**
     * Return an object that contains the static constants.
     */
    return {
        DestinationType: DestinationType,
        EncodeFormat: EncodeFormat
    };

})();
