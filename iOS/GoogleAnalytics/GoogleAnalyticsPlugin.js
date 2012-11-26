( function ( cordova ) {

  var GoogleAnalyticsPlugin = function () {};

  /**
   * Starts the tracker
   * @param  {String} id Google Analytics profile id
   */
  GoogleAnalyticsPlugin.prototype.startTrackerWithAccountID = function GoogleAnalyticsPluginStartTrackerWithAccountID ( id ) {
    // if ( 'console' in window ) { console.log( 'DEBUG: GA : startTrackerWithAccountID :: ', id ); }
    cordova.exec( 'GoogleAnalyticsPlugin.startTrackerWithAccountID', id );
  };

  /**
   * Tracks a page view
   * @param  {String} pageUri Application page uri, must start with a forward slash
   */
  GoogleAnalyticsPlugin.prototype.trackPageview = function GoogleAnalyticsPluginTrackPageview ( pageUri ) {
    // if ( 'console' in window ) { console.log( 'DEBUG: GA : trackPageview :: ', pageUri ); }
    cordova.exec( 'GoogleAnalyticsPlugin.trackPageview', pageUri );
  };

  /**
   * Tracks an event
   * @param  {String} category Event category, eg: 'Videos'
   * @param  {String} action   Action name, eg: 'Load Time'
   * @param  {String} label    Event label, eg: 'Nyan Cat ( Original )'
   * @param  {Number} value    Event value, eg: 14000
   */
  GoogleAnalyticsPlugin.prototype.trackEvent = function GoogleAnalyticsPluginTrackEvent ( category, action, label, value ) {
    // if ( 'console' in window ) { console.log( 'DEBUG: GA : trackEvent :: ', category, action, label, value ); }
		var options = {
			'category' : category,
			'action'   : action,
			'label'    : label,
			'value'    : value
		};
		cordova.exec( 'GoogleAnalyticsPlugin.trackEvent', options );
  };

  /**
   * https://developers.google.com/analytics/devguides/collection/gajs/gaTrackingCustomVariables#setup
   * @param {Number} index Ranging from 1-5
   * @param {String} name  Variable name
   * @param {String} value Variable value
   */
  GoogleAnalyticsPlugin.prototype.setCustomVariable = function GoogleAnalyticsPluginSetCustomVariable ( index, name, value ) {
    // if ( 'console' in window ) { console.log( 'DEBUG: GA : setCustomVariable :: ', index, name, value ); }
		var options = {
			'index' : index,
			'name'  : name,
			'value' : value
		};
		cordova.exec( 'GoogleAnalyticsPlugin.setCustomVariable', options );
  };

  /**
   * Not implemented
   * @param  {String} hitString [description]
   */
  GoogleAnalyticsPlugin.prototype.hitDispatched = function GoogleAnalyticsPluginHitDispatched ( hitString ) {
    // if ( 'console' in window ) { console.log( 'DEBUG: GA : hitDispatched :: ' + hitString ); }
  };

  /**
   * Not implemented
   * @param  {Number} count
   */
  GoogleAnalyticsPlugin.prototype.trackerDispatchDidComplete = function GoogleAnalyticsPluginTrackerDispatchDidComplete ( count ) {
    // if ( 'console' in window ) { console.log( 'DEBUG: GA : trackerDispatchDidComplete :: ', count ); }
  };

  cordova.addConstructor( function () {
    window.plugins = window.plugins || {};
    window.plugins.googleAnalyticsPlugin = window.plugins.googleAnalyticsPlugin || new GoogleAnalyticsPlugin();
  } );

}( window.cordova || window.Cordova || window.PhoneGap ) );