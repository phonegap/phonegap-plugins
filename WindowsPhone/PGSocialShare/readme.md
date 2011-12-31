Sample Use:
===============

In your head
---

[script type="text/javascript" charset="utf-8" src="PGSocialShare.js"][/script]


Somewhere in your code 
---

        function shareStatus()
        {
            navigator.plugins.pgSocialShare.shareStatus("This was shared from JS+PhoneGap+WP7 Yo!");
        }

        function shareLink()
        {
        navigator.plugins.pgSocialShare.shareLink("WP7 PhoneGap Plugins",
        "https://github.com/purplecabbage/phonegap-plugins/tree/master/WindowsPhone",
        "Watch for updates here soon! Shared from JavaScript");
        }


In your markup :
---

    <input style="display:block;margin:40px 0px" type="button" onclick="shareLink()" value="Share a Link"/>
    <input style="display:block;margin:40px 0px" type="button" onclick="shareStatus()" value="Update your Status"/>
