/* Author:

 */

var registed = false;

var appId = 'wx70800ccb252e5e34'; // please modify to your weichat application
									// ID

function onSuccess() {
	set2SendView();

	console.log('success');
	var detail = document.getElementById("detail");
	detail.innerHTML = "success";
}

function onError(response) {
	set2SendView();

	var detail = document.getElementById("detail");
	detail.innerHTML = "error:" + response.errCode;
	detail.innerHTML = detail.innerHTML + "<br>" + response.errStr;
	console.log('error');

}

function sendTextContent() {

	if (!registed) {
		registerApp(appId);
		registed = true;
	}

	plugins.weixin.textContent(onSuccess, onError, "send", "hello world");
}

function sendImageContent() {
	var app = {
		onCameraSuccess : function(imageURI) {
			console.log('imageURI:' + imageURI);
			plugins.weixin.imageContent(onSuccess, onError, "send", imageURI, {
				title : "kris",
				description : "picture",
			});
		},
		onCameraFail : function(msg) {
			var detail = document.getElementById("detail");
			detail.innerHTML = "error msg:" + msg;
			console.log('error msg:' + msg);
		},
		getPicture : function() {
			navigator.camera.getPicture(app.onCameraSuccess, app.onCameraFail,
					{
						quality : 50,
						destinationType : Camera.DestinationType.FILE_URI,
						sourceType : Camera.PictureSourceType.PHOTOLIBRARY,
						saveToPhotoAlbum : false
					});
		}
	};
	app.getPicture();
}

function sendMusicContent() {
	plugins.weixin
			.musicContent(
					onSuccess,
					onError,
					"send",
					"http://pluginlist.sinaapp.com/client/music/Sunshine.mp3",
					{
						title : "Sunshine",
						description : "Happy Music",
						thumbUrl : "http://pluginlist.sinaapp.com/client/images/music.png"
					});
}

function sendVideoContent() {
	plugins.weixin
			.videoContent(
					onSuccess,
					onError,
					"send",
					"http://www.tudou.com/listplay/0nYp1obVv60/mA_xdJq7lSo.html",
					{
						title : "video",
						description : "Happy Video",
						thumbUrl : "http://pluginlist.sinaapp.com/client/images/video.png"
					});
}

function sendWebpageContent() {
	plugins.weixin
			.webpageContent(
					onSuccess,
					onError,
					"send",
					"http://sae.sina.com.cn/?m=devcenter&catId=235",
					{
						title : "新浪移动云平台介绍",
						description : "新浪移动云是在SAE基础上的子平台，专注于为移动设备同时提供云+端的能力。\n为方便开发者使用，移动云直接集成在SAE在线管理平台中。",
						thumbUrl : "http://pluginlist.sinaapp.com/client/images/icon.png"
					});
}

function sendAPPContent() {
	plugins.weixin.APPContent(onSuccess, onError, "send", {
		title : "App消息",
		description : "您的App消息到啦，快去看看吧",
		thumbUrl : "http://pluginlist.sinaapp.com/client/images/icon.png",
		extInfo : "send APP",
		url : "http://www.sina.com.cn",
		fileData : JSON.stringify({
			title : "App消息名称",
			description : "内容描述",
			thumbUrl : "缩略图链接地址"
		})
	});
}

function getTextContent() {
	plugins.weixin.textContent(onSuccess, onError, "get", "Sina App Engine");
	set2SendView();
}

function getImageContent() {
	var app = {
		onCameraSuccess : function(imageURI) {
			console.log('imageURI:' + imageURI);
			plugins.weixin.imageContent(onSuccess, onError, "get", imageURI, {
				title : "kris",
				description : "picture",
			});
			set2SendView();
		},
		onCameraFail : function(msg) {
			var detail = document.getElementById("detail");
			detail.innerHTML = "error msg:" + msg;
			console.log('error msg:' + msg);
		},
		getPicture : function() {
			navigator.camera.getPicture(app.onCameraSuccess, app.onCameraFail,
					{
						quality : 30,
						destinationType : Camera.DestinationType.FILE_URI,
						sourceType : Camera.PictureSourceType.PHOTOLIBRARY,
						saveToPhotoAlbum : false
					});
		}
	};
	app.getPicture();
	// weixin.getImageContent(onSuccess,onError,"http://pluginlist.sinaapp.com/client/images/music.png",{
	// title:"kris",
	// description:"picture",
	// });
}

function getMusicContent() {
	var mapp = {
		onCameraSuccess : function(imageURI) {
			console.log('imageURI:' + imageURI);
			plugins.weixin.musicContent(onSuccess, onError, "get",
					"http://pluginlist.sinaapp.com/client/music/Sunshine.mp3",
					{
						title : "Sunshine",
						description : "Happy Music",
						thumbUrl : imageURI
					});
			set2SendView();
		},
		onCameraFail : function(msg) {
			var detail = document.getElementById("detail");
			detail.innerHTML = "error msg:" + msg;
			console.log('error msg:' + msg);
		},
		getPicture : function() {
			navigator.camera.getPicture(mapp.onCameraSuccess,
					mapp.onCameraFail, {
						quality : 30,
						destinationType : Camera.DestinationType.FILE_URI,
						sourceType : Camera.PictureSourceType.PHOTOLIBRARY,
						saveToPhotoAlbum : false
					});
		}
	};
	mapp.getPicture();
}

function getVideoContent() {
	plugins.weixin
			.videoContent(
					onSuccess,
					onError,
					"get",
					"http://www.tudou.com/listplay/0nYp1obVv60/mA_xdJq7lSo.html",
					{
						title : "video",
						description : "Get Happy Video",
						thumbUrl : "http://pluginlist.sinaapp.com/client/images/video.png"
					});
	set2SendView();
}

function getWebpageContent() {
	plugins.weixin
			.webpageContent(
					onSuccess,
					onError,
					"get",
					"http://sae.sina.com.cn/?m=devcenter&catId=235",
					{
						title : "新浪移动云平台介绍",
						description : "新浪移动云是在SAE基础上的子平台，专注于为移动设备同时提供云+端的能力。\n为方便开发者使用，移动云直接集成在SAE在线管理平台中。",
						thumbUrl : "http://pluginlist.sinaapp.com/client/images/icon.png"
					});
	set2SendView();
}

function getAPPContent() {
	plugins.weixin.APPContent(onSuccess, onError, "get", {
		title : "App消息",
		description : "您的App消息到啦，快去看看吧",
		thumbUrl : "http://pluginlist.sinaapp.com/client/images/icon.png",
		extInfo : "dictionary",
		url : "http://sae.sina.com.cn",
		fileData : JSON.stringify({
			title : "App消息名称",
			description : "内容描述",
			thumbUrl : "缩略图链接地址"
		})
	});
	set2SendView();
}

function cancle() {
	plugins.weixin.cancleGet();
}

function getWXAppInstallUrl() {
	plugins.weixin.getWXAppInstallUrl(function(resultUrl) {
		var detail = document.getElementById("detail");
		detail.innerHTML = "下载地址：" + resultUrl;
	}, onError);
}

function openWXApp() {
	plugins.weixin.openWXApp(function() {
		console.log('open success');
		var detail = document.getElementById("detail");
		detail.innerHTML = "open success";
	}, function() {
		console.log('open error');
		var detail = document.getElementById("detail");
		detail.innerHTML = "open error";
	});
}

function isWeixinInstalled() {
	plugins.weixin.isWeixinInstalled(function() {
		console.log('is installed');
		var detail = document.getElementById("detail");
		detail.innerHTML = "微信已安装";
	}, function() {
		console.log('not installed');
		var detail = document.getElementById("detail");
		detail.innerHTML = "微信未安装";
	});
}

function isSupportApi() {
	plugins.weixin.isSupportApi(function() {
		console.log('is support api');
		var detail = document.getElementById("detail");
		detail.innerHTML = "支持微信API";
	}, function() {
		console.log('not support api');
		var detail = document.getElementById("detail");
		detail.innerHTML = "不支持微信API";
	});
}

function registerApp() {
	plugins.weixin.registerApp(function() {
		alert("registerApp success");
		registed = true;
	}, onError, appId);
}

function setResponse() {
	plugins.weixin.setResponser("receiveResponse");
}

function receiveResponse(response) {
	console.log("receiveResponse: " + JSON.stringify(response));
	if (response.type == 0) {// 显示来自第三方的APP扩展信息
		var detail = document.getElementById("detail");
		detail.innerHTML = "response";
		detail.innerHTML = detail.innerHTML + "<br>extInfo:" + response.extInfo;
		detail.innerHTML = detail.innerHTML + "<br>url:" + response.url;
		var a = JSON.parse(response.fileData);
		detail.innerHTML = detail.innerHTML + "<br>---file data---<br>title:"
				+ a.title;
		detail.innerHTML = detail.innerHTML + "<br>description:"
				+ a.description;
		detail.innerHTML = detail.innerHTML + "<br>thumbUrl:" + a.thumbUrl;

		var viewport = document.getElementById('viewport');
		viewport.style.display = "";
		document.getElementById("picture").src = "data:image/jpeg;base64,"
				+ response.thumbData;
	} else if (response.type == 4) {// 来自微信的请求信息，跳转到获取信息页面
		set2GetView();
	}
}

function set2SendView() {
	var btn1 = document.getElementById("btn1");
	btn1.onclick = function() {
		sendTextContent();
	};
	btn1.innerHTML = "发送文本";

	var btn2 = document.getElementById("btn2");
	btn2.onclick = function() {
		sendImageContent();
	};
	btn2.innerHTML = "发送图像";

	var btn3 = document.getElementById("btn3");
	btn3.onclick = function() {
		sendMusicContent();
	};
	btn3.innerHTML = "发送音乐";

	var btn4 = document.getElementById("btn4");
	btn4.onclick = function() {
		sendVideoContent();
	};
	btn4.innerHTML = "发送视频";

	var btn5 = document.getElementById("btn5");
	btn5.onclick = function() {
		sendWebpageContent();
	};
	btn5.innerHTML = "发送网页";

	var btn6 = document.getElementById("btn6");
	btn6.onclick = function() {
		sendAPPContent();
	};
	btn6.innerHTML = "发送APP";

	document.getElementById("picture").src = "";
}

function set2GetView() {
	var detail = document.getElementById("detail");
	detail.innerHTML = "...........................";

	var btn1 = document.getElementById("btn1");
	btn1.onclick = function() {
		getTextContent();
	};
	btn1.innerHTML = "获取文本";

	var btn2 = document.getElementById("btn2");
	btn2.onclick = function() {
		getImageContent();
	};
	btn2.innerHTML = "获取图像";

	var btn3 = document.getElementById("btn3");
	btn3.onclick = function() {
		getMusicContent();
	};
	btn3.innerHTML = "获取音乐";

	var btn4 = document.getElementById("btn4");
	btn4.onclick = function() {
		getVideoContent();
	};
	btn4.innerHTML = "获取视频";

	var btn5 = document.getElementById("btn5");
	btn5.onclick = function() {
		getWebpageContent();
	};
	btn5.innerHTML = "获取网页";

	var btn6 = document.getElementById("btn6");
	btn6.onclick = function() {
		getAPPContent();
	};
	btn6.innerHTML = "获取APP";

	document.getElementById("picture").src = "";
}
