CDVSMSComposer
===


Cordova (iOS) Xcode Plugin Template
---




###Template Installation:
    $ cd ~/Library/Developer/Xcode/Templates/File\ Templates
    $ git clone https://github.com/RandyMcMillan/CDVSMSComposer.git

![image](https://raw.github.com/RandyMcMillan/CDVSMSComposer/master/CDVSMSComposer.xctemplate/ScreenShot.png)

###Usage:
####Open your Cordova (iOS) Xcode Project

* Press `<COMMAND+n>`    

    ![image](https://raw.github.com/RandyMcMillan/CDVSMSComposer/master/CDVSMSComposer.xctemplate/ScreenShot2.png)  


    ![image](https://raw.github.com/RandyMcMillan/CDVSMSComposer/master/CDVSMSComposer.xctemplate/ScreenShot3.png)  

* Copy the CDVSMSComposer.js file to your /www folder

    ![image](https://raw.github.com/RandyMcMillan/CDVSMSComposer/master/CDVSMSComposer.xctemplate/ScreenShot4.png)
    
[Sample index.html is included in the generated plugin](https://raw.github.com/RandyMcMillan/CDVSMSComposer/master/CDVSMSComposer.xctemplate/index.html)

####Add to www/index.html

`<script type="text/javascript" charset="utf-8" src="CDVSMSComposer 
.js"></script>`




#####Edit config.xml values

    <feature name="CDVSMSComposer">
        <param name="ios-package" value="CDVSMSComposer"/>
    </feature>

###You will need to add MessageUI.framework to your project if it is not already included.
![image](https://raw.github.com/RandyMcMillan/CDVSMSComposer/master/CDVSMSComposer.xctemplate/ScreenShot5.png)

[Sample index.html is included in the generated plugin](https://raw.github.com/RandyMcMillan/CDVSMSComposer/master/CDVSMSComposer.xctemplate/index.html)

###Usage:
    function onDeviceReady(){
                    
    var recip1 = "1231231234";
    var recip2 = "2342342344";
    var body = "This is a body string that is sent to the plugin!";
    init(recip1,recip2,body);
                    
    }
                
    function init (recip1,recip2,body) {
                    
        cordova.exec(null, null, "CDVSMSComposer", "showSMSComposer",[recip1+","+recip2,body]);
                    
    }
                
    function show () {
                    
        cordova.exec(null, null, "CDVSMSComposer", "showSMSComposer",["recip1,recip2","body1"]);
                    
    }
 
 
######And in html:
    
    <center><button onclick="show();">Compose SMS</button></center>


                

<br><br>

 
The MIT License


    CDVSMSComposer
    CDVSMSComposer Template Created Jan 7 2013
    Copyright 2013 @RandyMcMillan


Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
