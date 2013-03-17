# IFlyTek

科大讯飞语音识别插件

## Adding the Plugin to your project
1. To install the plugin, move www/iflytek.js to your project's www folder and include a reference to it in your html file after phonegap.js.
<pre><code>&lt;script type="text/javascript" charset="utf-8" src="phonegap.js"></script>
&lt;script type="text/javascript" charset="utf-8" src="iflytek.js"></script>
</code></pre>

2. Copy src files to your project src folder, include IFlyTekSDK folder & SAEIFlyRCPlugin

3. Add ﻿IFlyTek-SAEIFlyRCPlugin [key-value] to Cordova.plist->Plugins

## Usage

### window.plugins.iftRecognizer.init(appId)

初始化插件，appId通过http://dev.voicecloud.cn/index.php?vt=1申请

### window.plugins.iftRecognizer.setOption(params)

设置插件参数

* params 参数说明
  * engine  识别引擎选择，目前支持以下五种
  * ”sms”：普通文本转写
  * “poi”：地名搜索
  * ”vsearch”：热词搜索
  * ”video”：视频音乐搜索
  * ”asr”：命令词识别
* engineParams  附加参数列表，每项中间以逗号分隔，如在地图搜索时可指定搜索区域：”area=安徽省合肥市”，无附加参数传null
  * grammar 自定义命令词识别需要传入语法
  * sampleRate  录音采样率，支持rate8k、rate11k、rate16k、rate22k四种，默认为rate16k

例如:
<pre><code>
window.plugins.iftRecognizer.setOption({
    engine: 'sms',
    sampleRate: 'rate16k',
});
 
window.plugins.iftRecognizer.setOption({
    engine: 'poi',
    engineParams: 'area=北京',
});
 
window.plugins.iftRecognizer.setOption({
    grammar: extendID
});
</code></pre>
注意engine, engineParams, grammar的配合。

### window.plugins.iftRecognizer.setListener(name)

设置监听回调函数

* name 为监听回调函数的名字，例如设定成onResults（默认即为onResults），当语音识别一轮结束后，会回调该方法。

### function onResults(response);

* response.isLast 为是否是最后一次识别的状态表示, true表示最后一次结果，false表示结果未取完
* response.results 是当前这次识别的列表，为recognizerResult object，识别结果，请参考RecognizerResult定义

* recognizerResult 说明
  * String text 识别文本结果
  * int confidence  结果置信度
  * semanteme 语义结果，由本次识别所选择服务定义

例子:
<pre><code>
function onResults(response) {
  console.log('isLast: ' + response.isLast);
  response.results.forEach(function(recognizerResult) {
    console.log(recognizerResult.text + "##" + recognizerResult.confidence);
    $("#text").append(recognizerResult.text + "##");
  })  
}
</code></pre>

### window.plugins.iftRecognizer.start(onEnd)

开始监听,开始语音识别，弹出对话框。

* onEnd(response);
  * response.errorCode 错误码
  * response.message 信息

### window.plugins.iftRecognizer.uploadKeyword(keys, contentId, onDataUploaded, onEnd)

上传关键词列表

* keys  需要上传的关键词列表 例如”计算机,科技,文学”
* contentID 保存在服务器端的数据名称，已有的名称会进行覆盖操作，如果是第一次上传，则会在服务端按照此名称新建

* onDataUploaded(response)
  * response.contentID 用于UploadDialog.setContent(byte[],String,String)中contentID参数，表示对前面的结果进行覆盖。
  * response.extendID 用于RecognizerDialog.setEngine(String,String,String)中grammar参数，表示命令词识别所用的语法。

* onEnd(response);
  * response.errorCode 错误码
  * response.message 信息

## Demos
<pre><code>
// 语音听写：
window.plugins.iftRecognizer.init(appId);
window.plugins.iftRecognizer.setOption({
  engine: 'sms',
  sampleRate: 'rate16k',
}); 
window.plugins.iftRecognizer.setListener("onResults");
window.plugins.iftRecognizer.start(function(response) {
  console.log("response: " + response.errorCode + ", msg: " + response.message);
});

// 关键词识别：
var keys = "互联网,计算机,科技,生活,人文,天文,月球的多面,第三集";
window.plugins.iftRecognizer.uploadKeyword(keys, "tags", function(result) {
  extendID = result.extendID;
  console.log("extendID: " + extendID);
}, function(response) {
  console.log("response: " + response.errorCode + ", msg: " + response.message);
});
window.plugins.iftRecognizer.init(appId);
window.plugins.iftRecognizer.setOption({grammar: extendID});
window.plugins.iftRecognizer.setListener("onResults");
window.plugins.iftRecognizer.start(function(response) {
  console.log("response: " + response.errorCode + ", msg: " + response.message);
});

// 回调函数:
function onResults(response) {
  console.log('isLast: ' + response.isLast);
  response.results.forEach(function(recognizerResult) {
    console.log(recognizerResult.text + "##" + recognizerResult.confidence);
    $("#text").append(recognizerResult.text + "##");
  })
}
</pre></code>