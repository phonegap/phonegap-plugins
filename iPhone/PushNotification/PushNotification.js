var PushNotification = function() {}

// call this to register for push notifications
PushNotification.prototype.register = function(success, fail, options) {
  PhoneGap.exec(success, fail, "PushNotification", "registerAPN", options);
};

if(!window.plugins) window.plugins = {};
window.plugins.pushNotification = new PushNotification();