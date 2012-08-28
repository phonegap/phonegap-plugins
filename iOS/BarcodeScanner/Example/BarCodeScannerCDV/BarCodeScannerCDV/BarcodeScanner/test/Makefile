all: help

#-------------------------------------------------------------------------------
clean:
	-@chmod +w desktop-app/*.json.js phonegap-app/*.json.js phonegap-app/images/*

#-------------------------------------------------------------------------------
build: clean
	@python rebuild-tests-json.py
	@cp desktop-app/images/* phonegap-app/images
	@cp desktop-app/*.json.js phonegap-app
	@chmod -w desktop-app/*.json.js phonegap-app/*.json.js phonegap-app/images/*

#-------------------------------------------------------------------------------
help: 
	@echo make targets available:
	@echo "  help   print this help"
	@echo "  build  build the tests"
	@echo "  clean  remove the transient test files"

