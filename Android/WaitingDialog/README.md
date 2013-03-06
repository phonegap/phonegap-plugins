# Waiting dialog for Android applications

_Created by `Guido Sabatini`_

Creates a modal dialog to give a waiting feedback to users
You can only show and dismiss the dialog, it will block user interactions. You can set the text appearing in the dialog

**NOTE:** this is not a progress dialog, you can not show progress

    // To SHOW a modal waiting dialog
    window.plugins.waitingDialog.show("Your dialog text");

    // To HIDE the dialog
    window.plugins.waitingDialog.hide();
    
If you want to show a waiting dialog for a certain amount of time, you can use javascript setTimeout

	// show dialog
	window.plugins.waitingDialog.show("Your dialog text");
	// automatically hide dialog after 5 seconds
	setTimeout(function() {window.plugins.waitingDialog.hide();}, 5000);
	
	## LICENSE ##

    The MIT License

    Copyright (c) 2012 Guido Sabatini

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
