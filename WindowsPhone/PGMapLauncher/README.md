PGMapLauncher plugin usage:
===============
Source files
---
PGMapLauncher.js - plugin definition and js implementation
PGMapLauncher.cs - native side implementation

The PGMapLauncher plugin allows you to launch the WP7 Map application with a certain state.
You can either open maps in Directions view, or Map view, depending on the calls you make.
The user will need to press the back button to return to your app.


In your doc head :
---

    [script type="text/javascript" charset="utf-8" src="PGMapLauncher.js"][/script]


Somewhere in your code :
---
    // Search near the current location using a keyword :
    navigator.plugins.pgMapLauncher.searchNear("Malaysian Food");

    // Search for a keyword near a specific location :
    navigator.plugins.pgMapLauncher.searchNear("Wedding Chapel",{latitude:36.111224, longitude:-115.172194});

    // Get directions from the current location to a nearby keyword :
    navigator.plugins.pgMapLauncher.getDirections({label:"Malaysian Food"});

    // Get directions from a specific location to a nearby keyword :
    navigator.plugins.pgMapLauncher.getDirections({label:"Malaysian Food"},{coordinates:{latitude:36.111224, longitude:-115.172194}});
    
    