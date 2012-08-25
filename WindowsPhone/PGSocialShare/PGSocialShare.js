/* MIT licensed */
// (c) 2011 Jesse MacFadyen,  Adobe Systems Incorporated



(function(window){

    var cdv = window.cordova || window.Cordova;

    window.plugins.pgSocialShare =
    {
        shareStatus:function(msg)
        {
            var options = {"message":msg,"shareType":0}; // 0 == status
            cdv.exec(null,null,"PGSocialShare","share",options);
        },

        shareLink:function(title,url,msg)
        {
            var options = {"message":msg, "title":title, "url":url, "shareType":1}; // 1 == link
            cdv.exec(null,null,"PGSocialShare","share",options);
        }
    }

})(window);