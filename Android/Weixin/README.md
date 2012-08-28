#Weixin

微信插件

##Adding the Plugin to your project

1.add weixin.js to your www folder and include it to your html file below cordova.js

<pre><code>&lt;script type="text/javascript" charset="utf-8" src="cordova.js">
&lt;script type="text/javascript" charset="utf-8" src="weixin.js">
</code></pre>

2.Add Example src files to your project.

3.Add libs/libammsdk.jar file to your project libs directory.

4.Add below words to your res/xml/plugins.xml.

<pre><code>&lt;plugin name="Weixin" value="com.sina.mobile.weixin.WeixinPlugin"/>
</code></pre>

5.Modify APP_ID in src/com/sina/mobile/weixin/Constants.java file and
assets/www/script.js.

##Usage

###sina.weixin.registerApp(onSuccess,onError,appId)

在微信终端程序中注册第三方应用
说明：需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现。
  * appId 微信开发的ID (通过http://open.weixin.qq.com/ 申请，注意Android版本还需要匹配签名和包名)
  * onSuccess 注册成功时的回调函数
  * onError 注册失败时的回调函数
    * errCode 错误值
    * errStr 错误说明

demo
<pre><code>
sina.weixin.registerApp(function(){
                            registed=true;
                            },onError,"XXXXXXXXX");// 填入申请的微信应用开发appId
function onError(response){
    var detail = document.getElementById("detail");
    detail.innerHTML="error:"+response.errCode;
    detail.innerHTML=detail.innerHTML+"<br>"+response.errStr;
}
</code></pre>

###sina.weixin.isWeixinInstalled(onSuccess,onError)

检查微信是否已被用户安装
  * onSuccess 微信已安装的回调函数
  * onError 微信未安装的回调函数
    * errCode 错误值
    * errStr 错误说明

demo
<pre><code>
sina.weixin.isWeixinInstalled(function(){
                          console.log('is installed');
                          },function(){
                          console.log('not installed');
                          });
</code></pre>

###sina.weixin.isSupportApi(onSuccess,onError)

判断当前微信的版本是否支持OpenApi
  * onSuccess 当前微信版本支持OpenApi时的回调函数
  * onError 当前微信版本不支持OpenApi时的回调函数
    * errCode 错误值
    * errStr 错误说明

demo
<pre><code>
sina.weixin.isSupportApi(function(){
                                  console.log('is support api');
                                  },function(){
                                  console.log('not support api');
                                  });
</code></pre>

###sina.weixin.openWXApp(onSuccess,onError)

打开微信
  * onSuccess 成功时的回调函数
  * onError 失败时的回调函数
    * errCode 错误值
    * errStr 错误说明

demo
<pre><code>
sina.weixin.openWXApp(function(){
                          console.log('open success');
                          },function(){
                          console.log('open error');
                          });
</code></pre>

###sina.weixin.textContent(onSuccess, onError, types, text)

发送/获取 文本信息

发送：发送请求到微信,等待微信返回应答

获取：收到微信的请求，发送文本类型应答给微信，并切换到微信界面
  * onSuccess 成功时的回调函数
  * onError 失败时的回调函数
  * types 设置对文本信息的处理类型
    * send 表示：发送文本信息请求到微信
    * get 表示：收到微信的请求，发送文本类型应答给微信
  * text 文本信息内容

demo
<pre><code>
function getTextContent() {
    sina.weixin.textContent(onSuccess,onError,"get","Sina App Engine");
}

function sendTextContent() {
    sina.weixin.textContent(onSuccess,onError,"send","hello world");
}

function onSuccess(){
    console.log('success');
}

function onError(response){
    var detail = document.getElementById("detail");
    detail.innerHTML="error:"+response.errCode;
    detail.innerHTML=detail.innerHTML+"<br>"+response.errStr;
}
</code></pre>

###sina.weixin.imageContent(onSuccess, onError, types, imageUrl, options)

发送/获取 图片信息

发送：发送图片信息请求到微信,等待微信返回应答

获取：收到微信的请求，发送图片类型应答给微信，并切换到微信界面
  * onSuccess 成功时的回调函数
  * onError 失败时的回调函数
  * types 设置对图片信息的处理类型
    * send 表示：发送图片信息请求到微信
    * get 表示：收到微信的请求，发送图片类型应答给微信
  * imageUrl 图片的Url链接
  * options 相关参数项，字典类型。包括
    * title 
    * description

demo
<pre><code>
function sendImageContent(){
//从相册选择图片，并发送到微信应用
    var app={
    onCameraSuccess:function(imageURI){
        sina.weixin.imageContent(onSuccess,onError,"send",imageURI,{
                                     title:"kris",
                                     description:"picture",
                                     });
    },
    onCameraFail:function(msg){
        console.log('error msg:'+msg);
    },
    getPicture:function(){
        navigator.camera.getPicture(app.onCameraSuccess, app.onCameraFail, {
                                    quality: 50,
                                    destinationType: Camera.DestinationType.FILE_URI,
                                    sourceType: Camera.PictureSourceType.PHOTOLIBRARY,
                                    saveToPhotoAlbum: false
                                    });
    }
    };
    app.getPicture();
}

function getImageContent(){
//收到来自微信的请求后，发送图片应答给微信
    sina.weixin.getImageContent(onSuccess,onError,"http://pluginlist.sinaapp.com/client/images/music.png",{
                                title:"kris",
                                description:"picture",
                                });
}

function onSuccess(){
    console.log('success');
}
 
function onError(response){
    var detail = document.getElementById("detail");
    detail.innerHTML="error:"+response.errCode;
    detail.innerHTML=detail.innerHTML+"<br>"+response.errStr;
}
</code></pre>

###sina.weixin.musicContent(onSuccess, onError, types, musicUrl, options)

发送/获取 音乐信息。musicUrl和lowBandUrl不能同时为空。

发送：发送音乐信息请求到微信,等待微信返回应答

获取：收到微信的请求，发送音乐类型应答给微信，并切换到微信界面
  * onSuccess 成功时的回调函数
  * onError 失败时的回调函数
  * types 设置对音乐信息的处理类型
    * send 表示：发送音乐信息请求到微信
    * get 表示：收到微信的请求，发送音乐类型应答给微信
  * musicUrl 音乐数据的url地址，不支持本地音乐URL。musicUrl和lowBandUrl不能同时为空。
  * options 相关参数项，字典类型。包括
    * title 音乐信息标题
    * description 音乐信息描述内容
    * lowBandUrl 音乐lowband数据的url地址，不支持本地音乐URL。musicUrl和lowBandUrl不能同时为空。
    * thumbUrl 音乐信息缩略图url。当thumbUrl和thumbData同时设置时，采用thumbData。
    * thumbData 音乐信息缩略图base64数据，大小不能超过32K。当thumbUrl和thumbData同时设置时，采用thumbData。

demo
<pre><code>
function sendMusicContent(){
    sina.weixin.musicContent(onSuccess,onError,"send",
                                 "http://pluginlist.sinaapp.com/client/music/Sunshine.mp3",
                                 {
                                 title:"Sunshine",
                                 description:"Happy Music",
                                 thumbUrl:"http://pluginlist.sinaapp.com/client/images/music.png"
                                 });
}
function getMusicContent(){
    sina.weixin.musicContent(onSuccess,onError,"get",
                                    "http://pluginlist.sinaapp.com/client/music/Sunshine.mp3",
                                    {
                                    title:"Sunshine",
                                    description:"Happy Music",
                                    thumbUrl:"http://pluginlist.sinaapp.com/client/images/music.png"
                                    });
}
function onSuccess(){
    console.log('success');
}
function onError(response){
    var detail = document.getElementById("detail");
    detail.innerHTML="error:"+response.errCode;
    detail.innerHTML=detail.innerHTML+"<br>"+response.errStr;
}
</code></pre>

###sina.weixin.videoContent(onSuccess, onError, types, videoUrl, options)

发送/获取 视频信息。videoUrl和lowBandUrl不能同时为空。

发送：发送视频信息请求到微信,等待微信返回应答

获取：收到微信的请求，发送视频类型应答给微信，并切换到微信界面

  * onSuccess 成功时的回调函数
  * onError 失败时的回调函数
  * types 设置对视频信息的处理类型
    * send 表示：发送视频信息请求到微信
    * get 表示：收到微信的请求，发送视频类型应答给微信
  * videoUrl 视频数据的url地址，不支持本地视频URL。videoUrl和lowBandUrl不能同时为空。
  * options 相关参数项，字典类型。包括
    * title 视频信息标题
    * description 视频信息描述内容
    * lowBandUrl 视频lowband数据的url地址，不支持本地视频URL。videoUrl和lowBandUrl不能同时为空。
    * thumbUrl 视频信息缩略图url。当thumbUrl和thumbData同时设置时，采用thumbData。
    * thumbData 视频信息缩略图base64数据，大小不能超过32K。当thumbUrl和thumbData同时设置时，采用thumbData。

demo
<pre><code>
function getVideoContent(){
    sina.weixin.videoContent(onSuccess,onError,"get",
                             "http://www.tudou.com/listplay/0nYp1obVv60/mA_xdJq7lSo.html",
                             {
                             title:"video",
                             description:"Get Happy Video",
                             thumbUrl:"http://pluginlist.sinaapp.com/client/images/video.png"
                             });
}
function sendVideoContent(){
    sina.weixin.videoContent(onSuccess,onError,"send",
                                 "http://www.tudou.com/listplay/0nYp1obVv60/mA_xdJq7lSo.html",
                                 {
                                 title:"video",
                                 description:"Happy Video",
                                 thumbUrl:"http://pluginlist.sinaapp.com/client/images/video.png"
                                 });
}
</code></pre>

###sina.weixin.webpageContent(onSuccess, onError, types, webpageUrl, options)

发送/获取 网页信息

发送：发送网页信息请求到微信，等待微信返回应答

获取：收到微信的请求，发送网页类型应答给微信，并切换到微信界面
  * onSuccess 成功时的回调函数
  * onError 失败时的回调函数
  * types 设置对网页信息的处理类型
    * send 表示：发送网页信息请求到微信
    * get 表示：收到微信的请求，发送网页类型应答给微信
  * webpageUrl 网页url地址
  * options 相关参数项，字典类型。包括
    * title 网页信息标题
    * description 网页信息描述内容
    * thumbUrl 网页信息缩略图url。当thumbUrl和thumbData同时设置时，采用thumbData。
    * thumbData 网页信息缩略图base64数据，大小不能超过32K。当thumbUrl和thumbData同时设置时，采用thumbData。

demo
<pre><code>
function sendWebpageContent(){
    sina.weixin.webpageContent(onSuccess,onError,"send",
                                   "http://sae.sina.com.cn/?m=devcenter&catId=235",
                                   {
                                   title:"新浪移动云平台介绍",
                                   description:"新浪移动云是在SAE基础上的子平台，专注于为移动设备同时提供云+端的能力。\n为方便开发者使用，移动云直接集成在SAE在线管理平台中。",
                                   thumbUrl:"http://pluginlist.sinaapp.com/client/images/icon.png"
                                   });
}
function getWebpageContent(){
    sina.weixin.webpageContent(onSuccess,onError,"get",
                                  "http://sae.sina.com.cn/?m=devcenter&catId=235",
                                  {
                                  title:"新浪移动云平台介绍",
                                  description:"新浪移动云是在SAE基础上的子平台，专注于为移动设备同时提供云+端的能力。\n为方便开发者使用，移动云直接集成在SAE在线管理平台中。",
                                  thumbUrl:"http://pluginlist.sinaapp.com/client/images/icon.png"
                                  });
}
</code></pre>

###sina.weixin.APPContent(onSuccess, onError, types, options)

发送/获取 APP扩展信息。微信需要处理这种APP扩展信息时，会调用该第三方应用的监听回调方法来处理。监听回调方法的设置及相应操作，请参考sina.weixin.setResponser(responseString)。

发送：发送APP扩展信息请求到微信,等待微信返回应答

获取：收到微信的请求，发送APP扩展类型应答给微信，并切换到微信界面
  * onSuccess 成功时的回调函数
  * onError 失败时的回调函数
  * types 设置对APP扩展信息的处理类型
    * send 表示：发送APP扩展信息请求到微信
    * get 表示：收到微信的请求，发送APP扩展类型应答给微信
  * options 相关参数项，字典类型。包括
    * title APP扩展信息标题
    * description APP扩展信息描述内容
    * thumbUrl APP扩展信息缩略图url。当thumbUrl和thumbData同时设置时，采用thumbData。
    * thumbData APP扩展信息缩略图base64数据，大小不能超过32K。当thumbUrl和thumbData同时设置时，采用thumbData。
    * extInfo 自定义简单数据，长度不能超过2K。微信应用会回传给第三方应用处理。extInfo与fileData不能同时为空。
    * fileData APP文件数据，JSON对象，大小不能超过10M。该数据发送给微信好友，微信好友需要点击后下载数据，微信应用会回传给第三方应用处理。extInfo与fileData不能同时为空。
    * url 若第三方应用不存在，微信应用会打开该url所指的App下载地址。(Android版本没有此属性)

demo
<pre><code>
function getAPPContent(){
    sina.weixin.APPContent(onSuccess,onError,"get",
                           {
                           title:"App消息",
                           description:"您的App消息到啦，快去看看吧",
                           thumbUrl:"http://pluginlist.sinaapp.com/client/images/icon.png",
                           extInfo:"dictionary",
                           url:"http://sae.sina.com.cn",
                           fileData:JSON.stringify(
                                                   {title:"App消息名称",
                                                   description:"内容描述",
                                                   thumbUrl:"缩略图链接地址"}
                                                   )
                           });
}
function sendAPPContent(){
    sina.weixin.APPContent(onSuccess,onError,"send",
                           {
                           title:"App消息",
                           description:"您的App消息到啦，快去看看吧",
                           thumbUrl:"http://pluginlist.sinaapp.com/client/images/icon.png",
                           extInfo:"send APP",
                           url:"http://www.sina.com.cn",
                           fileData:JSON.stringify(
                                                   {title:"App消息名称",
                                                   description:"内容描述",
                                                   thumbUrl:"缩略图链接地址"}
                                                   )
                           });
}
</code></pre>

###sina.weixin.setResponser(responseString)

设置监听回调函数，接收来自微信应用的请求
  * responseString 监听回调方法的名字，默认为receiveResponse

function receiveResponse(response);
  * type 回调信息的类型
    * 0 表示显示APP扩展格式信息。
    * 4 表示来自微信的请求信息，获取内容后返回给微信应用。
  * 当type==0时，response还包括下面几项：
    * extInfo 第三方应用自定义简单数据，微信应用会回传给第三方应用处理。[说明：长度不能超过2K]
    * fileData APP文件数据，JSON对象。该数据发送给微信好友，微信好友需要点击后下载数据，微信应用会回传给第三方应用处理。[说明：大小不能超过10M]
    * thumbData APP扩展格式信息缩略图base64数据。

demo
<pre><code>
sina.weixin.setResponser("receiveResponse");
function receiveResponse(response){
    if(response.type==0)
    {//显示来自第三方的APP扩展信息
        var detail = document.getElementById("detail");
        detail.innerHTML="extInfo:"+response.extInfo;
        
        var a=JSON.parse(response.fileData);
        detail.innerHTML=detail.innerHTML+"<br>title:"+a.title;
        detail.innerHTML=detail.innerHTML+"<br>description:"+a.description;
        detail.innerHTML=detail.innerHTML+"<br>thumbUrl:"+a.thumbUrl;
        
        var viewport = document.getElementById('viewport');
        viewport.style.display = "";
        document.getElementById("picture").src = "data:image/jpeg;base64," + response.thumbData;
    }
    else if(response.type==4)
    {// 来自微信的请求信息，跳转到获取信息页面
        var btn1=document.getElementById("btn1");
        btn1.onclick=function(){sina.weixin.textContent(onSuccess,onError,"get","Sina App Engine");};
        btn1.innerHTML="获取文本";
    }
}
</code></pre>
