function Locale() {
}

Locale.prototype.get = function(name, languageCode, win, fail) {
	PhoneGap.exec(win, fail, "Localizable", "get", [ name, languageCode ]);
};

Locale.prototype.values = function(languageCode, win, fail) {
	PhoneGap.exec(win, fail, "Localizable", "values", [ languageCode ]);
};

PhoneGap.addConstructor(function() {
	PhoneGap.addPlugin("locale", new Locale());
});

