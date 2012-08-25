var app = {
    initialize: function() {
	this.bind();
    },
    bind: function() {
	document.addEventListener('deviceready', this.deviceready, false);
    },
    deviceready: function() {
	// note that this is an event handler so the scope is that of the event
	// so we need to call app.report(), and not this.report()
	app.report('deviceready');

	// listen for orientation changes
	window.addEventListener("orientationchange", window.plugins.iAdPlugin.orientationChanged, false);
	// listen for the "iAdBannerViewDidLoadAdEvent" that is sent by the iAdPlugin
	document.addEventListener("iAdBannerViewDidLoadAdEvent", iAdBannerViewDidLoadAdEventHandler, false);
	// listen for the "iAdBannerViewDidFailToReceiveAdWithErrorEvent" that is sent by the iAdPlugin
	document.addEventListener("iAdBannerViewDidFailToReceiveAdWithErrorEvent", iAdBannerViewDidFailToReceiveAdWithErrorEventHandler, false);

	var adAtBottom = false;
	setTimeout(function() {
		   window.plugins.iAdPlugin.prepare(adAtBottom); // by default, ad is at Top
		   }, 1000);
	window.plugins.iAdPlugin.orientationChanged(true);//trigger immediately so iAd knows its orientation on first load



    },
    report: function(id) {
	console.log("report:" + id);
	// hide the .pending <p> and show the .complete <p>
	document.querySelector('#' + id + ' .pending').className += ' hide';
	var completeElem = document.querySelector('#' + id + ' .complete');
	completeElem.className = completeElem.className.split('hide').join('');
    }
};
