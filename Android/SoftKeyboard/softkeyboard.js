function SoftKeyBoard() {}

SoftKeyBoard.prototype.show = function(win, fail) {
    return PhoneGap.exec(
            function (args) { if(win !== undefined) { win(args); } }, 
            function (args) { if(fail !== undefined) { fail(args); } }, 
            "SoftKeyBoard", 
            "show", 
            []);	
};

SoftKeyBoard.prototype.hide = function(win, fail) {
    return PhoneGap.exec(
            function (args) { if(win !== undefined) { win(args); } }, 
            function (args) { if(fail !== undefined) { fail(args); } },
            "SoftKeyBoard", 
            "hide", 
            []);	
};

PhoneGap.addConstructor(function() {
    PhoneGap.addPlugin('SoftKeyBoard', new SoftKeyBoard());
    PluginManager.addService("SoftKeyBoard","com.zenexity.SoftKeyBoardPlugin.SoftKeyBoard");
});
