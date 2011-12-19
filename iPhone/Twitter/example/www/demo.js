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
        var tests = ["isAvailable", "isSetup", "tweet", "compose", "timeline", "mentions"];
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
    
    tweet:function(){
        TwitterDemo.log("wait..");
        window.plugins.twitter.sendTweet(
            function(s){ TwitterDemo.log("tweet success"); }, 
            function(e){ TwitterDemo.log("tweet failure: " + e); }, 
            "Tweety Poo", 
            "https://github.com/brianantonelli", 
            "http://zomgdinosaurs.com/zomg.jpg");
    },
    
    compose: function() {
        TwitterDemo.log("wait..");
          window.plugins.twitter.composeTweet();
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
