Card.io android plug-in for PhoneGap
---------------------------------

This plug-in exposes card.io's credit card scanning. (card.io also supports charging cards; that is not yet supported in this plug-in.)


Integration instructions
------------------------

* Add the card.io library:
    * Sign up for an account at https://www.card.io/, create an app, and take note of your `app_token`.
    * Download the Android SDK at https://www.card.io/integrate/android.
    * Follow the instructions there to add the requisite classes, jars to your project.

* Add this plug-in:

    * Register the plugin in the `res/xml/config.xml` file.

	``` <plugin name="CardIOPGPlugin" value="com.cubettech.plugins.cardio.CardIOPGPlugin"/>```

    * Add activity entry in `AndroidManifext.xml`

	``` <activity android:name="com.cubettech.plugins.cardio.CardIOMain" />```

    * Add the package `com.cubettech.plugins.cardio` to your project's `src` folder. i.e, simply copy the `com` folder in your `src` directory
    * Copy `CardIOPGPlugin.js` to your project's www folder.
    * Add e.g. `<script type="text/javascript" charset="utf-8" src="CardIOPGPlugin.js"></script>` to your html.
    * In `config.xml`, add an entry to `ExternalHosts` with value `*.card.io`, ignore this if you have set `<access origin=".*"/>`.
    * See `CardIOPGPlugin.js` for detailed usage information.
    * Sample `scan` usage: `window.plugins.CardIOPGPlugin.scan(onCardIOComplete, onCardIOCancel);`
    * Your required fields & API key can be configure by modifying the array `cardIOConfig` in `CardIOPGPlugin.js` 

### Sample HTML + JS

```html
<h1>Scan Example</h1>
<p><button id='scanBtn'>Scan now</button></p>
<script type="text/javascript">


    	//Your response array contain these fields
	// redacted_card_number, card_number, expiry_month,expiry_year, cvv, zip

	var onCardIOComplete = function(response) {
		console.log("card.io scan completed");
		console.log(JSON.stringify(response));

	};

	var onCardIOCancel = function() {
	    	console.log("card.io scan cancelled");
	};

	$('#scanBtn').click(function() {
		window.plugins.CardIOPGPlugin.scan(onCardIOComplete, onCardIOCancel);
	});
</script>
```

License
-------
* This plug-in is released under the MIT license: http://www.opensource.org/licenses/MIT

Notes
-----
* Generic Phone Gap plug-in installation instructions are available at https://build.phonegap.com/docs/plugins-using

Questions? Contact `info@cubettech.com`.
