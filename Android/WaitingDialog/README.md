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