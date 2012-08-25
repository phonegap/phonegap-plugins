Live Tiles plugin usage:
===============
Source files
---
liveTiles.js - plugin definition and js implementation
LiveTiles.cs - native side implementation
liveTilesExample.html- usage example

In your head
---

    [script type="text/javascript" charset="utf-8" src="liveTiles.js"][/script]


Somewhere in your code 
---

   
    navigator.plugins.liveTiles.updateAppTile(success, fail,{title: 'title', image:'Images/appbar.next.rest.png', count: 5, backTitle: 'Back title', backContent:'Back side', backImage : 'Images/appbar.close.rest.png'});    

    navigator.plugins.liveTiles.createSecondaryTile(success, fail, { title: 'title', image: 'Images/appbar.save.rest.png', count: 5, secondaryTileUri: 'www/myPage.html',backTitle:'back'});
   
    navigator.plugins.liveTiles.updateSecondaryTile(success, fail, { title: 'title', count: 5, secondaryTileUri: 'www/myPage.html' });

    navigator.plugins.liveTiles.deleteSecondaryTile(success, fail, { secondaryTileUri: 'www/myPage.html' });