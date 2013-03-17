var appId = '4fa1e775';

var extendID = "";
var recognizerInited = false;
var listenerName = 'onResults';

function startRecognize() {
  $("#voice-text").html("");
  if(!this.recognizerInited) {
      plugins.iftRecognizer.init(this.appId);
      this.recognizerInited = true;
  }

  plugins.iftRecognizer.setOption({
      engine: 'sms',
      sampleRate: 'rate16k',
  });

  plugins.iftRecognizer.setListener(this.listenerName);

  plugins.iftRecognizer.start(function(response) {
      console.log("response: " + response.errorCode + ", msg: " + response.message);
  });

  console.log("start");
}

function onResults(response) {
  console.log('isLast: ' + response.isLast);
  console.log(response);
  response.results.forEach(function(recognizerResult) {
      console.log(recognizerResult.text + "##" + recognizerResult.confidence);
      $("#voice-text").append(recognizerResult.text);
  });
}

function uploadKeyword() {
  if(!this.recognizerInited) {
      plugins.iftRecognizer.init(this.appId);
      this.recognizerInited = true;
  }

  var keys = "互联网,计算机,科技,生活,人文,天文,月球的多面,第三集";
  plugins.iftRecognizer.uploadKeyword(keys, "tags", function(result) {
      extendID = result.extendID;
      console.log("extendID: " + result.extendID);
  }, function(response) {
      console.log("response: " + response.errorCode + ", msg: " + response.message);
  });

  console.log("uploadKeyword");
}

function keywordRecognize() {
  if(!this.recognizerInited) {
      plugins.iftRecognizer.init(this.appId);
      this.recognizerInited = true;
  }

  console.log("extendID: " + extendID);
  plugins.iftRecognizer.setOption({grammar: this.extendID});
  plugins.iftRecognizer.setListener(this.listenerName);

  plugins.iftRecognizer.start(function(response) {
      console.log("response: " + response.errorCode + ", msg: " + response.message);
  });

  console.log("keywordRecogize");
}