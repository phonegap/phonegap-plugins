app={};
function stringToJSON(obj) {
    return eval('(' + obj + ')');
}
app.weibo = {
    access_t : "",
    init : function() {
        CDV.WB.init({
                    appKey : "*****", // 修改成微博应用的appkey
                    appSecret : "*********", // 修改成微博应用的appSecret
                    redirectUrl : "http://weichu.sinaapp.com" // 修改成微博应用的redirectUrl
                    }, function(response) {
                    alert("init: " + response);
                    }, function(msg){
                    alert(msg);
                    });
        this.access_t = localStorage.getItem("access_t");
    },
    login : function() {
        sina.weibo.login(function(access_token, expires_in) {
                         if (access_token && expires_in) {
                         alert('logged in');
                         localStorage.setItem('access_t', access_token);
                         app.weibo.access_t = access_token;
                         } else {
                         alert('not logged in');
                         }
                         });
    },
    logout : function() {
        sina.weibo.logout(function(response) {
                          alert('logged out');
                          localStorage.removeItem("access_t");
                          this.access_t = null;
                          });
    },
    timeline : function() {
        if (this.access_t) {
            sina.weibo.get("https://api.weibo.com/2/statuses/home_timeline.json", {
                           access_token : this.access_t,
                           }, function(response) {
                           var data = stringToJSON(response);
                           alert('statuses[0].text: ' + data.statuses[0].text);
                           }, function(response) {
                           alert('error: ' + response);
                           });
        } else {
            alert('not logged in');
        }
    },
    get : function() {
        sina.weibo.get("https://api.weibo.com/2/account/get_uid.json", {
                       access_token : this.access_t,
                       }, function(response){
                       alert('User uid is ' + stringToJSON(response).uid);
                       }, function(response){
                       alert('error: ' + response);
                       });
    },
    post : function() {
        sina.weibo.post("https://api.weibo.com/2/statuses/update.json", {
                        access_token : this.access_t,
                        status : "test update"
                        }, function(data) {
                        alert('update success.' + data);
                        }, function(response){
                        alert('error: ' + response);
                        })
    },
    upload : function() {
        function onSuccess(imageURI) {
            $("#upload").html("uploading...");
            sina.weibo.upload("https://api.weibo.com/2/statuses/upload.json", {
                              access_token : this.access_t,
                              status : "test update"
                              },
                              imageURI,
                              function(data) {
                              $("#upload").html("upload");
                              alert('update success.' + data);
                              }, function(response){
                              $("#upload").html("upload");
                              alert('error: ' + response);
                              })
        }
        
        function onFail(message) {
            alert('Failed because: ' + message);
        }
        
        navigator.camera.getPicture(onSuccess, onFail, { quality: 50,
                                    destinationType: Camera.DestinationType.FILE_URI
                                    });
    }
};