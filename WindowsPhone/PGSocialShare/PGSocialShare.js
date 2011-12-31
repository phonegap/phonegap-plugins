/* MIT licensed */
// (c) 2011 Jesse MacFadyen,  Adobe Systems Incorporated



(function(){

    var PGSocialShare = 
    {
        ShareType:
        {
            status:0,
            link:1
        }
    }
    
    PhoneGap.addConstructor(function() {

        navigator.plugins.pgSocialShare =
        {
            shareStatus:function(msg)
            {
                var options = {"message":msg,"shareType":PGSocialShare.ShareType.status};
                PhoneGap.exec(null,null,"PGSocialShare","share",options);
            },

            shareLink:function(title,url,msg)
            {
                var options = {"message":msg,
                               "title":title,
                               "url":url,
                               "shareType":PGSocialShare.ShareType.link};

                PhoneGap.exec(null,null,"PGSocialShare","share",options);
            }
        }



    });



})();