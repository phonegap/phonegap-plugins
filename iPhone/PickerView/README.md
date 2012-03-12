# PhoneGap PickerView Plugin #
by `Olivier Louvignes`

## DESCRIPTION ##

* This plugin provides a simple way to use the `UIPickerView` native component from IOS. It does comply with the latest (future-2.x) phonegap standards.

* There is a `Sencha Touch 2.0` plugin to easily leverage this plugin [here](https://github.com/mgcrea/sencha-touch-plugins/blob/master/PhonegapPicker.js)

## SETUP ##

Using this plugin requires [iPhone PhoneGap](http://github.com/phonegap/phonegap-iphone).

1. Make sure your PhoneGap Xcode project has been [updated for the iOS 4 SDK](http://wiki.phonegap.com/Upgrade-your-PhoneGap-Xcode-Template-for-iOS-4)
2. Drag and drop the `PickerView` folder from Finder to your Plugins folder in XCode, using "Create groups for any added folders"
3. Add the .js files to your `www` folder on disk, and add reference(s) to the .js files as <link> tags in your html file(s)
4. Add new entry with key `PickerView` and value `PickerView` to `Plugins` in `PhoneGap.plist`

## JAVASCRIPT INTERFACE ##

    // After device ready, create a local alias
    var pickerView = window.plugins.pickerView;

    // Basic with title
    var items = [{value: 'foo', text: 'Displayed Foo'}, {value: 'bar', text: 'Displayed Bar'}, {value: 'baz', text: 'Displayed Baz'}];
	pickerView.create('Title', items, function(selectedValues, buttonIndex) { console.warn('callback', [this, arguments]); });

    // Customized buttons
	var items = [{value: 'foo', text: 'Displayed Foo'}, {value: 'bar', text: 'Displayed Bar'}, {value: 'baz', text: 'Displayed Baz'}];
	pickerView.create('', items, function(selectedValues, buttonIndex) { console.warn('callback', [this, arguments]); }, {style: 'black-opaque', doneButtonLabel: 'OK', cancelButtonLabel: 'Annuler'});

	// Multiple slots & default value
	var items = [
		{
			name : 'limit_speed',
			title: 'Speed',
			data : [
				{text: '50 KB/s', value: 50},
				{text: '100 KB/s', value: 100},
				{text: '200 KB/s', value: 200},
				{text: '300 KB/s', value: 300}
			],
			value: 100
		},
		{
			name : 'road_type',
			title: 'Road',
			data : [
				{text: 'Highway', value: 50},
				{text: 'Town', value: 100},
				{text: 'City', value: 200},
				{text: 'Depart', value: 300}
			],
			value: 200
		}
	];
	pickerView.create('Title', items, function(selectedValues, buttonIndex) { console.warn('callback', [this, arguments]); });

* Check [source](http://github.com/mgcrea/phonegap-plugins/tree/master/iPhone/PickerView/PickerView.js) for additional configuration.

## BUGS AND CONTRIBUTIONS ##

Patches welcome! Send a pull request. Since this is not a part of PhoneGap Core (which requires a CLA), this should be easier.

Post issues on [Github](http://github.com/phonegap/phonegap-plugins/issues)

The latest code (my fork) will always be [here](http://github.com/mgcrea/phonegap-plugins/tree/master/iPhone/PickerView/)

## LICENSE ##

Copyright 2011 Olivier Louvignes. All rights reserved.

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
