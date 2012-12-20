var screenOrientation = function() {}

screenOrientation.prototype.set = function(str, success, fail) {
    var args = {};
    args.key = str;
    PhoneGap.exec(success, fail, "ScreenOrientation", "set", [args]);
};
navigator.screenOrientation = new screenOrientation();
