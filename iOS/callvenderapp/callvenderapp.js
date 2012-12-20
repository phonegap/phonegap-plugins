/* 
  callvenderapp.js
 

  Created by kissthink on 12-4-26.
  Copyright 2012年 __MyCompanyName__. All rights reserved.
*/


/**
* Phonegap KissthinkPlugin Instance plugin
* Copyright (c)kissthink 2012
*
*/
var KissthinkPlugin = {

run: function(types, success, fail) {
return PhoneGap.exec(success, fail, "callvenderapp", "run", types);
}
};


/**
*   exampel 
*   

KissthinkPlugin.run(
["flypiggroupnote://","http://itunes.apple.com/us/app/.....url..."] ,

function(result) {

alert("Success : \r\n"+result);      

},

function(error) {

alert("Error : \r\n"+error);      
}
); 


*/