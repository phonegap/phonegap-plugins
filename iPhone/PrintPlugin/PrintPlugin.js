/**
 * Printer Plugin
 * Copyright (c) 2011 Ian Tipton (github.com/itip)
 * MIT licensed
 */

var PrintPlugin = function() {
};


PrintPlugin.UIPrintInfoOutputType = {
	UIPrintInfoOutputGeneral: 0,     // B&W or color, normal quality output for mixed text, graphics, and images
	UIPrintInfoOutputPhoto: 1,       // B&W or color, best quality output for images
	UIPrintInfoOutputGrayscale: 2,   // B&W, fast/draft quality output
};

PrintPlugin.UIPrintInfoOrientation = {
	UIPrintInfoOrientationPortrait: 0,
	UIPrintInfoOrientationLandscape: 1,
};

PrintPlugin.UIPrintInfoDuplex = {
	UIPrintInfoDuplexNone: 0,
	UIPrintInfoDuplexLongEdge: 1,   // flip back page along long edge (same orientation in portrait, flipped for landscape)
	UIPrintInfoDuplexShortEdge: 2,  // flip back page along short edge (flipped orientation for portrait, same in landscape)
};


PrintPlugin.prototype.print = function(settings) {
	settings = PrintPlugin.defaults(settings, {
		html: '',
		outputType: 'UIPrintInfoOutputGeneral',
		jobName: '',
		duplex: 'UIPrintInfoDuplexLongEdge',
		orientation: 'UIPrintInfoOrientationPortrait',
		showsPageRange: true,
		presentFromRect: [0,0,0,0],
		success: function(result) {},
		failure: function(result) {}
	});

	// process the presentFromRect and convert to string value understood by CGRectFromString
	if (Object.prototype.toString.apply(settings.presentFromRect) === '[object Array]' && settings.presentFromRect.length === 4) {
		settings.presentFromRect = '{{' + settings.presentFromRect[0] + ',' + settings.presentFromRect[1] + '},{' + settings.presentFromRect[2] + ',' + settings.presentFromRect[3] + '}}';
	}
	else {
		console.log('PrintPlugin.print warning: presentFromRect option is invalid, expecting an array in the following format: [x, y, width, height].');
		settings.presentFromRect = '{{0,0},{0,0}}';
	}

	PhoneGap.exec(settings.success, settings.failure, 'PrintPlugin', 'print', [
		settings.html,
		PrintPlugin.UIPrintInfoOutputType[settings.outputType],
		settings.jobName,
		PrintPlugin.UIPrintInfoDuplex[settings.duplex],
		PrintPlugin.UIPrintInfoOrientation[settings.orientation],
		settings.showsPageRange,
		settings.presentFromRect
	]);
};


PrintPlugin.prototype.isPrintingAvailable = function(settings) {
	settings = PrintPlugin.defaults(settings, {
		success: function() {},
		failure: function() {}
	});

	PhoneGap.exec(settings.success, settings.failure, 'PrintPlugin', 'isPrintingAvailable', []);
};


PhoneGap.addConstructor(function() {
	if (!window.plugins) {
		window.plugins = {};
	}
	window.plugins.printPlugin = new PrintPlugin();
});



// Underscore.js 1.2.3
// (c) 2009-2011 Jeremy Ashkenas, DocumentCloud Inc.
// Underscore is freely distributable under the MIT license.
// Portions of Underscore are inspired or borrowed from Prototype,
// Oliver Steele's Functional, and John Resig's Micro-Templating.
// For all details and documentation:
// http://documentcloud.github.com/underscore

// The cornerstone, an `each` implementation, aka `forEach`.
// Handles objects with the built-in `forEach`, arrays, and raw objects.
// Delegates to **ECMAScript 5**'s native `forEach` if available.
PrintPlugin.each = function(obj, iterator, context) {
	if (obj == null) return;
	if (Array.prototype.forEach && obj.forEach === Array.prototype.forEach) {
		obj.forEach(iterator, context);
	} else if (obj.length === +obj.length) {
		for (var i = 0, l = obj.length; i < l; i++) {
			if (i in obj && iterator.call(context, obj[i], i, obj) === breaker) return;
		}
	} else {
		for (var key in obj) {
			if (Object.prototype.hasOwnProperty.call(obj, key)) {
				if (iterator.call(context, obj[key], key, obj) === breaker) return;
			}
		}
	}
};

// Fill in a given object with default properties.
PrintPlugin.defaults = function(obj) {
	PrintPlugin.each(Array.prototype.slice.call(arguments, 1), function(source) {
		for (var prop in source) {
			if (obj[prop] == null) obj[prop] = source[prop];
		}
	});
	return obj;
};
