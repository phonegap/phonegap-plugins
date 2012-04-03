card.io iOS plug-in for Phone Gap
---------------------------------

This plug-in exposes card.io's credit card scanning. (card.io also supports charging cards; that is not yet supported in this plug-in.)


Integration instructions
------------------------

* Add the card.io library:
    * Sign up for an account at https://www.card.io/, create an app, and take note of your `app_token`.
    * Download the iOS SDK at https://www.card.io/integrate/ios.
    * Follow the instructions there to add the requisite files, frameworks, and linker flags to your Xcode project.

* Add this plug-in:
    * Add `CardIOPGPlugin.[h|m]` to your project (Plugins group).
    * Copy `CardIOPGPlugin.js` to your project's www folder using Finder or Terminal. (If you don't have a www folder yet, run in the Simulator and follow the instructions in the build warnings.)
    * Add e.g. `<script type="text/javascript" charset="utf-8" src="CardIOPGPlugin.js"></script>` to your html.
    * In `Cordova.plist`, add an entry to `Plugins` with key `CardIOPGPlugin` and value `CardIOPGPlugin`.
    * In `Cordova.plist`, add an entry to `ExternalHosts` with value `*.card.io`.
    * See `CardIOPGPlugin.js` for detailed usage information.
    * Sample `canScan` usage: `window.plugins.card_io.canScan(function(canScan) {console.log("card.io can scan: " + canScan);});`
    * Sample (minimal) `scan` usage: `window.plugins.card_io.scan("YOUR_APP_TOKEN", {}, function(response) {console.log("card number: " + response["card_number"]);}, function() {console.log("card scan cancelled");});`

### Sample HTML + JS

```html
<h1>Scan Example</h1>
<p><button id='scanBtn'>Scan now</button></p>
<script type="text/javascript">

  function onDeviceReady() {

    var cardIOResponseFields = [
      "card_type",
      "redacted_card_number",
      "card_number",
      "expiry_month",
      "expiry_year",
      "cvv",
      "zip"
    ];

    var onCardIOComplete = function(response) {
      console.log("card.io scan complete");
      for (var i = 0, len = cardIOResponseFields.length; i < len; i++) {
        var field = cardIOResponseFields[i];
        console.log(field + ": " + response[field]);
      }
    };

    var onCardIOCancel = function() {
      console.log("card.io scan cancelled");
    };

    var onCardIOCheck = function (canScan) {
      console.log("card.io canScan? " + canScan);
      var scanBtn = document.getElementById("scanBtn");
      if (!canScan) {
        scanBtn.innerHTML = "Manual entry";
      }
      scanBtn.onclick = function (e) {
        window.plugins.card_io.scan(
          "YOUR_APP_TOKEN_HERE",
          {
            "collect_expiry": true,
            "collect_cvv": false,
            "collect_zip": false,
            "shows_first_use_alert": true,
            "disable_manual_entry_buttons": false
          },
          onCardIOComplete,
          onCardIOCancel
        );
      }
    };

    window.plugins.card_io.canScan(onCardIOCheck);
  }
</script>
```

License
-------
* This plug-in is released under the MIT license: http://www.opensource.org/licenses/MIT

Notes
-----
* The minimum supported iOS version is iOS 4.0.
* Generic Phone Gap plug-in installation instructions are available at http://wiki.phonegap.com/w/page/43708792/How%20to%20Install%20a%20PhoneGap%20Plugin%20for%20iOS.

Questions? Contact `support@<the obvious domain>`.
