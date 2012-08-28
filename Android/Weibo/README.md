# Weibo plugin for Phonegap #

Originally by SINA SAE

Under the Apache License 2.0.

sina.weibo

微博插件，采用新浪微博OAuth2认证方式，提供了登录，登出和GET、POST方式访问接口的方法。登录后会得到相应的access_token，然后通过GET、POST访问相应的新浪微博接口，具体接口地址为：http://open.weibo.com/wiki/API%E6%96%87%E6%A1%A3_V2

## Using the plugin ##

1. Add SinaWeiBoSDK to your project

2. Put the .h and .m files to your plugin folder. The .js files of the plugin to www folder.

## API ##

## sina.weibo.init(params,success,fail) ##

初始化接口，初始化微博插件，设定相应参数。Params为微博开放平台相关参数，{appKey:“”,appSecret:“”,redirectUrl:“”}，其中appKey和appSecret为微博开放平台申请获得，申请时选择移动应用。redirectUrl为应用回调地址，需要与微博开放平台那里填写的地址一致。

success和fail分别是成功和失败的回调函数，并提供了相应的信息。

function(message){
}

message是相应的提示信息

例子

<pre><code>
      sina.weibo.init({
        appKey:"*****", // your weibo app appkey
        appSecret:"*******", // your weibo app appSecret
        redirectUrl:"http://www.sina.com"  // your weibo app redirectUrl
      },function(msg){
        alert("init:"+msg);
      },function(msg){
        alert(msg);
      });
</code></pre>

## sina.weibo.login(success,fail) ##

微博登录接口。微博登录，会弹出微博第三方登录的对话框，引导用户登录。

用户登录成功后会回调success

function(access_token,expires_in){
｝

access_token 为微博认证的access_token
expires_in为access_token的过期时间
用户登录失败回调fail

function(){
}

例子

<pre><code>
  sina.weibo.login(function(access_token,expires_in){
    console.log("access_token:"+access_token);
    if(access_token&&expires_in){
      access_t=access_token;
      alert('loggedin');
      localStorage.setItem('access_t',access_t);
    }else{
      alert('notloggedin');
    }
  });
</pre></code>

## sina.weibo.logout(success,fail) ##

微博登出接口

用户登出成功后会回调success

function(msg){
｝

用户登出失败后会回调 fail

function(){
}

例子

<pre><code>
  sina.weibo.logout(function(response){
    alert('loggedout');
    localStorage.removeItem("access_t");
    access_t=null;
  });
</pre></code>

## sina.weibo.get(url,params,success,[fail]) ##

GET访问微博接口，发起GET请求，访问相应微博接口。

url 为http://open.weibo.com/wiki/API%E6%96%87%E6%A1%A3_V2 微博api文档的完整url，可以点击相应接口到相应页面，查看URL获得。
params 为GET请求参数，如{access_token:“”,}
请求成功后会回调success

function(response){
}

response 是返回结果，为字符串，可通过eval('('+obj+')');方法将其转为json。
请求失败后回调fail

function(response){
}

response是返回结果，为字符串
例子

<pre><code>
    $.get("https://api.weibo.com/2/account/get_uid.json" ,{
      access_token:access_t
    },function(data){
      alert('Useruidis'+data.uid);
    });
</pre></code>

## sina.weibo.post(url,params,success,[fail]) ##

POST访问微博接口，发起POST请求，访问相应微博接口。

url 为http://open.weibo.com/wiki/API%E6%96%87%E6%A1%A3_V2 微博api文档的完整url，可以点击相应接口到相应页面，查看URL获得。
params 为POST请求参数，如{access_token:“”,}
请求成功后会回调success

function(response){
}

response 是返回结果，为字符串
请求失败后回调fail

function(response){
}

response 是返回结果，为字符串

## sina.weibo.upload(url,params,file,success,[fail]) ##

上传图片接口，与sina.weibo.post(url,params,success,[fail])相似，增加file参数，主要用于访问 https://api.weibo.com/2/statuses/upload.json 该接口。

例子

<pre><code>
functiononSuccess(imageURI){
  alert("imageURI:"+imageURI);
  sina.weibo.upload("https://api.weibo.com/2/statuses/upload.json" ,{
    access_token:access_t,
    status:"testupdate"
  },
  imageURI;
 
  function(data){
    alert('updatesuccess.'+data);
  },function(response){
    alert('error:'+response);
  })
}
 
functiononFail(message){
  alert('Failedbecause:'+message);
}
 
functionupload(){
  navigator.camera.getPicture(onSuccess,onFail,{quality:50,
                              destinationType:Camera.DestinationType.FILE_URI
  });
}
</pre></code>
