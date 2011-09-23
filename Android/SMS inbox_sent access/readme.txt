-Author: Kaarel Kargu(karq)
-Phonegap Android SMS inbox/sent retrieve plugin
-With this plugin you can retrieve messages from androids inbox and sent folder.

RETRIEVES:
-Message body
-Number
-contact name if exists.


INSTALLATION
1)Move smsread.js to your assets/www folder.
2)Move SMSReader.java to some package in src
3)Open res/xml/plugins.xml and add this line
- <plugin name="SMSReader" value="com.example.app.SMSReader" />  <--Change the package name to where SMSReader is located.
4)Open smsread.js and changes this line 
- PluginManager.addService("SMSReader", "com.example.app.SMSReader"); <--- Change the package name again to the location of SMSReader
5)Open androidManifest file and add these lines
- <uses-permission android:name="android.permission.READ_SMS" />
- <uses-permission android:name="android.permission.READ_CONTACTS" />
6)Open your HTML file and add
- <script type="text/javascript" charset="utf-8" src="smsread.js"></script>


HOW TO USE THE PLUGIN:
1)Access inbox
window.plugins.SMSReader.getInbox("",function(data){
   //Some code here to handle data      

},function(){
 //Handle failure here
});

2)Access sent
window.plugins.SMSReader.getSent("",function(data){
      //Handle data here
},function(){
 //Handle failure here
});



AND HERE'S AN EXAMPLE OF HOW TO READ/DISPLAY MESSAGES FROM INBOX
html file:
<body>
        <h1>INBOX</h1><br />
        <div id="inbox">inbox</div><br />
</body>

js script:
document.addEventListener('deviceready',main, false);
function main(){
	window.plugins.SMSReader.getInbox("",function(data){
	      var text = getData(data);
	      $("#inbox").html(text);
	},function(){
	 alert("Something went wrong!");
	});
}

function getData(data){
   var txt = "";
  for(var i = 0; i < data.messages.length; i++){
          txt += "<b>Number:</b>" +  data.messages[i].number + " ";
          if(data.messages[i].name != ""){
            txt += "<b>Name:</b>" +  data.messages[i].name + " ";
          }
          txt += "<b> Message:</b>" + data.messages[i].text + "!<br />";
  }
  return txt;
}




