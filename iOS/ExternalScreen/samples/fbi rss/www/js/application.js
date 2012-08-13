/* iScroll */

document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
document.addEventListener("deviceready", onDeviceReady, false);

/* Application */
var feeds = [ { feed:"http://www.fbi.gov/wanted/topten/wanted-feed.xml", name:"Top Ten Fugitives" }, 
			  { feed:"http://www.fbi.gov/wanted/wanted_terrorists/wanted-feed.xml", name:"Most Wanted Terrorists" }, 
			  { feed:"http://www.fbi.gov/wanted/terrorinfo/wanted-feed.xml", name:"Seeking Terror Information" }, 
			  { feed:"http://www.fbi.gov/wanted/dt/wanted-feed.xml", name:"Domestic Terrorism" }, 
			  { feed:"http://www.fbi.gov/wanted/alert/wanted-feed.xml", name:"Crime Alerts" }, 
			  { feed:"http://www.fbi.gov/wanted/seeking-info/wanted-feed.xml", name:"Seeking Information" }, 
			  { feed:"http://www.fbi.gov/wanted/unknown/wanted-feed.xml", name:"Unknown Bank Robbers" }, 
			  { feed:"http://www.fbi.gov/wanted/murders/wanted-feed.xml", name:"Murders" }, 
			  { feed:"http://www.fbi.gov/wanted/additional/wanted-feed.xml", name:"Violent Crimes" }, 
			  { feed:"http://www.fbi.gov/wanted/cyber/wanted-feed.xml", name:"Cyber Crimes" }, 
			  { feed:"http://www.fbi.gov/wanted/cac/wanted-feed.xml", name:"Crimes Against Children" }, 
			  { feed:"http://www.fbi.gov/wanted/cei/wanted-feed.xml", name:"Criminal Enterprise Investigations" }, 
			  { feed:"http://www.fbi.gov/wanted/wcc/wanted-feed.xml??", name:"White Collar Crimes" } ];

function onDeviceReady()
{
    
    PGExternalScreen.setupScreenConnectionNotificationHandlers( secondScreenResultHandler, secondScreenErrorHandler ); 
	scroller = new iScroll('wrapper');
    
    var backLink = $("#back");
	backLink.hide();
    NoClickDelay( backLink.get(0) );

	loadFeeds();
}

function back() {

	$("#back").hide();
	loadFeeds();
}

function loadFeeds() {

	var content = "<ul>";
	for ( var x=0; x< feeds.length; x++) {
		content += "<li><a class='feedLink' href='" + feeds[x].feed + "' onclick='return requestFeed(event)'>" + feeds[x].name + "</a></li>";
	}
	content += "</ul>";
	
	$("#content").html( content );
	scroller.refresh();
	scroller.scrollTo( 0,0 );
    
	$("#content").find('li').each(function() {
        var div = $(this).get(0);
        NoClickDelay( div );
    });
}

function requestFeed( event ) {

	$("#content").html( '<div class="activityIndicator"></div>' );
	
	var feedURL = $(event.currentTarget).attr("href");
	
	$.ajax({
		  url: feedURL,
		  success: onFeedSuccess,
		  error: onFeedError
		});
	
	return false;
}


function onFeedSuccess(data, textStatus, jqXHR) {

	$("#back").show();
	var html = "";
	//find each 'item' in the file and parse it
	$(data).find('item').each(function() {

		//name the current found item this for this particular loop run
		var $item = $(this);
		var title = $item.find('title').text();
		var link = $item.find('link').text();
		var description = $item.find('description').text();
		var $description = $(description);
		var img = $description.find('img').attr("src");
		var lines = description.split( "<br/>" );
		var status = lines[1];
		var category = lines[2];

		// now create a var 'html' to store the markup we're using to output the feed to the browser window
		html += "<div class='listItem' onclick='showDetails(event)' id=\"" + link + "\")'><img src='" + img + "'>" +
                    "<div class='title'>" + title + "</div>" + 
					"<div class='status'>" + status + "</div>" + 
					"<div class='status'>" + category + "</div>" + 
				"</div>";

	});
	
	$("#content").html( html );
	scroller.refresh();
	scroller.scrollTo( 0,0 );
    
	$("#content").find('div').each(function() {
        var div = $(this).get(0);
        NoClickDelay( div );
    });
}

function onFeedError(jqXHR, textStatus, errorThrown) {

	$("#content").html( errorThrown );
}

function showDetails( event ) {
    var sourceDiv = $( event.currentTarget );
    var link = sourceDiv.attr("id");
    //alert( link );
	PGExternalScreen.loadHTMLResource( link, secondScreenResultHandler, secondScreenErrorHandler);
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

function secondScreenResultHandler (result) {
    //alert("SUCCESS: \r\n"+result);
}

function secondScreenErrorHandler (error) {
   // alert("ERROR: \r\n"+error);
}

