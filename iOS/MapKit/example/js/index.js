/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicity call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        console.log('Received Event: ' + id);
    },
	
	
	showMap : function() {
		var pins = []; // array of pin objects
		pins.push({
				  lat: 52.37282884466203, lon: 4.893712154769901, title: 'monument', subTitle:'subTitle here', pinColor: 'red', index: 1, selected: false
				  });
		pins.push({
				  lat: 52.37277190755, lon: 4.894415905414, title: 'hotel', subTitle:'subTitle here too', pinColor: 'green', index: 2, selected: false
				  });
		pins.push({
				  lat: 52.37320562232438, lon: 4.891400459990564, title: 'palace', subTitle:'subTitle', pinColor: 'purple', index: 3, selected: true
				  });
		
		var options = {buttonCallback: "app.mapCallBack", diameter:500, lat:52.37311669773997, lon: 4.892585647313581};
		
		this.showMapAndPins(options, pins);
	},
	
	mapCallBack : function(i) {
		document.getElementById('returnval').innerHTML = 'Index returned from map: ' + i;
		// clear pins
		window.plugins.mapKit.clearMapPins();
		// hide the map
		window.plugins.mapKit.hideMap();
	},
	
	// 'private' method. ugly layout because of all the callbacks
	showMapAndPins : function(options, pins) {
		window.plugins.mapKit.clearMapPins(
										   function() {
										   window.plugins.mapKit.showMap(
																		 function() {
																		 window.plugins.mapKit.setMapData(
																										  options,
																										  function() {
																										  window.plugins.mapKit.addMapPins(
																																		   pins,
																																		   function() {
		   },
																																		   function() {errorHandler();}
																																		   );
																										  },
																										  function() {errorHandler();})
																		 },
																		 function() {errorHandler();}
																		 );},
										   function() {errorHandler();}
										   );
		
	}
	
};

function errorHandler() {
	console.warn('Oops..');
}
