/*
*
* Copyright (C) 2011 Dmitry Savchenko <dg.freak@gmail.com>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*
*/

var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks

/** 
 * Flags to denote the Android Notification constants
 * Values are representation from Android Notification Flag bit vals 
 */

function Flag() {}
Flag.FLAG_AUTO_CANCEL="16";
Flag.FLAG_NO_CLEAR="32";

/** @deprecated Use the W3C standard window.Notification API instead. */
var NotificationMessenger = function() { }

/**
 * @param title Title of the notification
 * @param body Body of the notification
 * @deprecated Use the W3C standard window.Notification API instead.
 */
NotificationMessenger.prototype.notify = function(title, body, flag) {
    if (window.Notification) {
        this.activeNotification = new window.Notification(title, {
            body: body,
            flag: flag
        });
    }
}

/**
 * Clears the Notification Bar
 * @deprecated Use the W3C standard window.Notification API instead.
 */
NotificationMessenger.prototype.clear = function() {
    if (this.activeNotification) {
        this.activeNotification.close();
        this.activeNotification = undefined;
    }
}

if (!window.plugins) window.plugins = {}
if (!window.plugins.statusBarNotification) window.plugins.statusBarNotification = new NotificationMessenger();


/*
 * The W3C standard API, window.Notification. See http://www.w3.org/TR/notifications/
 * This API should be used for new applications instead of the old plugin API above.
 */
if (typeof window.Notification == 'undefined') {

    /**
     * Creates and shows a new notification.
     * @param title
     * @param options
     */
    window.Notification = function(title, options) {
        options = options || {};
        this.tag = options.tag || 'defaultTag';

        // Add this notification to the global index by tag.
        window.Notification.active[this.tag] = this;

        // May be undefined.
        this.onclick = options.onclick;
        this.onerror = options.onerror;
        this.onshow = options.onshow;
        this.onclose = options.onclose;

        var content = options.body || '';
        
        var flag = options.flag || '';

        cordova.exec(function() {
            if (this.onshow) {
                this.onshow();
            }
        }, function(error) {
            if (this.onerror) {
                this.onerror(error);
            }
        }, 'StatusBarNotification', 'notify', [this.tag, title, content, flag]);
    };

    // Permission is always granted on Android.
    window.Notification.permission = 'granted';

    window.Notification.requestPermission = function(callback) {
        callback('granted');
    };

    // Not part of the W3C API. Used by the native side to call onclick handlers.
    window.Notification.callOnclickByTag = function(tag) {
        console.log('callOnclickByTag');
        var notification = window.Notification.active[tag];
        if (notification && notification.onclick && typeof notification.onclick == 'function') {
            console.log('inside if');
            notification.onclick();
        }
    };

    // A global map of notifications by tag, so their onclick callbacks can be called.
    window.Notification.active = {};


    /**
     * Cancels a notification that has already been created and shown to the user.
     */
    window.Notification.prototype.close = function() {
        cordova.exec(function() {
            if (this.onclose) {
                this.onclose();
            }
        }, function(error) {
            if (this.onerror) {
                this.onerror(error);
            }
        }, 'StatusBarNotification', 'clear', [this.tag]);
    };
}

// vim: tabstop=4:softtabstop=4:shiftwidth=4:expandtab
