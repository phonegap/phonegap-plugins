(function( cordova ) {

    function SoftKeyBoard() {}

    SoftKeyBoard.prototype.show = function(win, fail) {
        return cordova.exec(
                function (args) { if(win !== undefined) { win(args); } },
                function (args) { if(fail !== undefined) { fail(args); } },
                "SoftKeyBoard", "show", []);
    };

    SoftKeyBoard.prototype.hide = function(win, fail) {
        return cordova.exec(
                function (args) { if(win !== undefined) { win(args); } },
                function (args) { if(fail !== undefined) { fail(args); } },
                "SoftKeyBoard", "hide", []);
    };

    SoftKeyBoard.prototype.isShowing = function(win, fail) {
        return cordova.exec(
                function (args) { if(win !== undefined) { win(args); } },
                function (args) { if(fail !== undefined) { fail(args); } },
                "SoftKeyBoard", "isShowing", []);
    };

    if(!window.plugins) {
        window.plugins = {};
    }

    if (!window.plugins.SoftKeyBoard) {
        window.plugins.SoftKeyBoard = new SoftKeyBoard();
    }

})( window.cordova );