/* iScroll */

document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
document.addEventListener("deviceready", onDeviceReady, false);

/* Application */
var vehicles = [];

function onDeviceReady()
{
    $("#reset").click( function(){
                      PGExternalScreen.invokeJavaScript( "resetMap()" );
    });
    
    var div = $("#reset").get(0);
    NoClickDelay( div );
    
    PGExternalScreen.setupScreenConnectionNotificationHandlers( secondScreenResultHandler, secondScreenErrorHandler ); 
    scroller = new iScroll('wrapper');
    
    vehicles = generateVehicles();
    displayVehicles();
}

function generateVehicles() {
    var result = [];
    for ( var x=0; x<50; x++) {
        result.push( {  name:("Vehicle " + (x+1)), 
                    lat:generateLatitude(), 
                    lon:generateLongitude(), 
                    direction:generateDirection(), 
                    lastUpdate:generateDate(), 
                    speed:generateSpeed() } );
    }
    return result;
}

function generateSpeed() {
    var min = 300;
    var max = 500;
    
    return (min + Math.random() * (max-min));
}

function generateLatitude() {
    var min = -70;
    var max = 70;
    
    return (min + Math.random() * (max-min));
}

function generateLongitude() {
    var min = -180;
    var max = 180;
    
    return (min + Math.random() * (max-min));
}

function generateDirection() {
    return Math.random() * 360;
}

function generateDate() {
    return new Date();
}


function displayVehicles() {
    var html = "";
    for ( var x=0; x< vehicles.length; x++) {
        //id=\"" + link + "\")'><img src='" + img + "'
        html += "<div class='listItem' onclick='showDetails(event)' location='" + vehicles[x].lat + "," + vehicles[x].lon + "'>" +
        "<div class='imgDiv'><img src='assets/airplane.png' style=' -webkit-transform: translate(-16,-15);-webkit-transform:rotate(" + vehicles[x].direction + "deg);-webkit-transform: translate(16,15)' /></div>" + 
        "<div class='contentDiv'>" + 
        "<div class='title'>" + vehicles[x].name + "</div>" +
        "<div> Location:" + vehicles[x].lat + ", " + vehicles[x].lon + "</div>" +
        "<div><em>Last Update:" + vehicles[x].lastUpdate + "</em></div>" +
        "</div>" +
        "</div>";
    }
    $("#content").html( html );
    scroller.refresh();
    
    $("#content").find('div').each(function() {
                                   var div = $(this).get(0);
                                   NoClickDelay( div );
                                   });
}

function showDetails( event ) {
    var sourceDiv = $( event.currentTarget );
    var location = sourceDiv.attr("location");
    var jsString = "gotoLocation(" + location + ")";
    //alert( jsString );
    PGExternalScreen.invokeJavaScript( jsString );
    $("#content").find('div').each(function() {
                                   var div = $(this);
                                   if ( sourceDiv.get(0) == div.get(0) ) {
                                   sourceDiv.addClass( "selectedRow" );
                                   }
                                   else {
                                   div.removeClass( "selectedRow" );
                                   }
                                   });
}

function showVehiclesOnMap() {
    
    for ( var x=0; x< vehicles.length; x++) {
        var jsString = "addImageMarker(" + vehicles[x].lat + ", " + vehicles[x].lon + ", \"" + vehicles[x].name + "\", " + vehicles[x].direction +  ")";
        //alert( jsString );
        PGExternalScreen.invokeJavaScript( jsString );
    }
    
}

function secondScreenResultHandler (result) {
    PGExternalScreen.loadHTMLResource( "map.html" );
    setTimeout( showVehiclesOnMap, 500 );
    //alert("SUCCESS: \r\n"+result);
}

function secondScreenErrorHandler (error) {
    // alert("ERROR: \r\n"+error);
}
