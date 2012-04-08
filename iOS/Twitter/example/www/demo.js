function onBodyLoad(){		
	document.addEventListener("deviceready", onDeviceReady, false);
}

function onDeviceReady(){
    console.log("onDeviceReady");
    TwitterDemo.setup();
}

TwitterDemo = {
    $:function(id){
        return document.getElementById(id);
    },
    
    log:function(s){
        TwitterDemo.$("log").innerHTML = s;
    },
    
    setup:function(){
        var tests = ["isAvailable", "isSetup", "tweet1", "tweet2", "tweet3", "tweet4", "tweet5", "tweet6", "timeline", "mentions"];
        for(var i=0, l=tests.length; i<l; i++){
            this.$(tests[i]).onclick = this[tests[i]];
        }
    },
    
    isAvailable:function(){
        TwitterDemo.log("wait..");
        window.plugins.twitter.isTwitterAvailable(function(r){
            TwitterDemo.log("twitter available? " + r);
        });        
    },
    
    isSetup:function(){
        TwitterDemo.log("wait..");
        window.plugins.twitter.isTwitterSetup(function(r){
            TwitterDemo.log("twitter configured? " + r);
        });
    },
  
	tweet1:function(){
		TwitterDemo.log("wait..");
		window.plugins.twitter.composeTweet(
			function(s){ TwitterDemo.log("tweet success"); }, 
			function(e){ TwitterDemo.log("tweet failure: " + e); }, 
			"Text, Image, URL", 
			{
				urlAttach:"http://m.youtube.com/#/watch?v=obx2VOtx0qU", 
				imageAttach:"http://i.ytimg.com/vi/obx2VOtx0qU/hqdefault.jpg?w=320&h=192&sigh=QD3HYoJj9dtiytpCSXhkaq1oG8M"
			});
	},

	
	/*
	 //Original tweet1 example
    tweet1:function(){
        TwitterDemo.log("wait..");
        window.plugins.twitter.composeTweet(
            function(s){ TwitterDemo.log("tweet success"); }, 
            function(e){ TwitterDemo.log("tweet failure: " + e); }, 
            "Text, Image, URL", 
            {
                urlAttach:"https://github.com/brianantonelli", 
                imageAttach:"http://zomgdinosaurs.com/zomg.jpg"
            });
    },
	 
	 */

    tweet2:function(){
        TwitterDemo.log("wait..");
        window.plugins.twitter.composeTweet(
            function(s){ TwitterDemo.log("tweet success"); }, 
            function(e){ TwitterDemo.log("tweet failure: " + e); }, 
            "Text, Remote Image", 
            {
                imageAttach:"http://zomgdinosaurs.com/zomg.jpg"
            });
    },

    tweet6:function(){
        TwitterDemo.log("wait..");
        window.plugins.twitter.composeTweet(
                                            function(s){ TwitterDemo.log("tweet success"); }, 
                                            function(e){ TwitterDemo.log("tweet failure: " + e); }, 
                                            "Text, Local Image", 
                                            {
                                            imageAttach:"www/ninja-lolcat.gif"
                                            });
    },

    tweet3:function(){
        TwitterDemo.log("wait..");
        window.plugins.twitter.composeTweet(
            function(s){ TwitterDemo.log("tweet success"); }, 
            function(e){ TwitterDemo.log("tweet failure: " + e); }, 
            "Text, URL", 
            {
                urlAttach:"https://github.com/brianantonelli"
            });
    },

    tweet4:function(){
        TwitterDemo.log("wait..");
        window.plugins.twitter.composeTweet(
            function(s){ TwitterDemo.log("tweet success"); }, 
            function(e){ TwitterDemo.log("tweet failure: " + e); }, 
            "Text");
    },
    
    tweet5:function(){
        TwitterDemo.log("wait..");
        window.plugins.twitter.composeTweet(
            function(s){ TwitterDemo.log("tweet success"); }, 
            function(e){ TwitterDemo.log("tweet failure: " + e); });
    },

    timeline:function(){
        TwitterDemo.log("wait..");
        window.plugins.twitter.getPublicTimeline(
            function(s){ TwitterDemo.log("timeline success: " + JSON.stringify(s)); }, 
            function(e){ TwitterDemo.log("timeline failure: " + e); });
    },
    
    mentions:function(){
        TwitterDemo.log("wait..");
        window.plugins.twitter.getMentions(
            function(s){ TwitterDemo.log("mentions success: " + JSON.stringify(s)); }, 
            function(e){ TwitterDemo.log("mentions failure: " + e); });
    }
    
};
