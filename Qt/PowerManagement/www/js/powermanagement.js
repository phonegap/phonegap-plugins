/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2011, Wolfgang Koller - http://www.gofg.at/
 */

function PowermanagementError() {
};

PowermanagementError.cast = function( p_code, p_message ) {
    var powerManagementError = new PowermanagementError();
    powerManagementError.code = p_code;
    powerManagementError.message = p_message;

    return powerManagementError;
};

PowermanagementError.ALREADY_ACTIVE = 1;
PowermanagementError.NOT_SUPPORTED = 2;
PowermanagementError.NOT_ACTIVE = 3;

PowermanagementError.prototype.code = 0;
PowermanagementError.prototype.message = "";

function Powermanagement() {
};

Powermanagement.prototype.acquired = false;

Powermanagement.prototype.acquire = function( successCallback, errorCallback ) {
    if( this.acquired ) {
        errorCallback( PowermanagementError.cast( PowermanagementError.ALREADY_ACTIVE, "Powermanagement lock already active." ) );
        return;
    }

    var me = this;
    PhoneGap.exec( function() {
                      me.acquired = true;
                      successCallback();
                  }, function() {
                      me.acquired = false;
                      errorCallback( PowermanagementError.cast( PowermanagementError.NOT_SUPPORTED, "Powermanagement not supported." ) );
                  }, "com.phonegap.plugin.Powermanagement", "acquire", [] );
};

Powermanagement.prototype.release = function( successCallback, errorCallback ) {
    if( !this.acquired ) {
        errorCallback( PowermanagementError.cast( PowermanagementError.NOT_ACTIVE, "Powermanagement lock not active." ) );
        return;
    }

    var me = this;
    PhoneGap.exec( function() {
                      me.acquired = false;
                      successCallback();
                  }, function() {
                      me.acquired = false;
                      errorCallback( PowermanagementError.cast( PowermanagementError.NOT_SUPPORTED, "Powermanagement not supported." ) );
                  }, "com.phonegap.plugin.Powermanagement", "release", [] );
};

Powermanagement.prototype.dim = function( successCallback, errorCallback ) {
    if( this.acquired ) {
        errorCallback( PowermanagementError.cast( PowermanagementError.ALREADY_ACTIVE, "Powermanagement lock already active." ) );
        return;
    }

    var me = this;
    if( !PhoneGap.exec( function() {
                      me.acquired = true;
                      successCallback();
                  }, function() {
                      me.acquired = false;
                      errorCallback( PowermanagementError.cast( PowermanagementError.NOT_SUPPORTED, "Powermanagement not supported." ) );
                  }, "com.phonegap.plugin.Powermanagement", "dim", [] ) ) {

        // If dimming doesn't work, try to acquire a full wake lock
        this.acquire( successCallback, errorCallback );
    }
};

/**
 * Create Powermanagement instance
 */
PhoneGap.addConstructor( "com.phonegap.plugin.Powermanagement", function () {
                            window.Powermanagement = new Powermanagement();
                            window.PowerManagement = window.Powermanagement;    // Alias for backwards compatibility
} );
