The FBConnect.js file is basically an extension of ChildBrowser functionality.
It uses a childbrowser to open a Facebook window where the user can login and choose to allow access.
URL changes in childbrowser are watched by the FBConnect script and the accessToken is pulled from the url.

This could be developed much further to encapsulate all of the Facebook graph API, but currently only getFriends is supported.

Enjoy!
  Jesse



