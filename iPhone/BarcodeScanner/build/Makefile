#-------------------------------------------------------------------------------
ZXING_VERS = 1.7
ZXING_URL  = http://zxing.googlecode.com/files/ZXing-$(ZXING_VERS).zip

#-------------------------------------------------------------------------------
all: help

#-------------------------------------------------------------------------------
build: tmp/zxing.zip
	-@rm -rf zxing
	mkdir zxing
	cp -R tmp/zip/zxing/cpp/core/src/zxing/* zxing
	python onefile-zxing.py zxing ..
#	rm -rf zxing

#-------------------------------------------------------------------------------
tmp/zxing.zip:
	-@rm -rf tmp
	mkdir    tmp
	curl --output tmp/zxing.zip $(ZXING_URL)
	unzip -d tmp/zip tmp/zxing.zip

#-------------------------------------------------------------------------------
watch:
	run-when-changed "make build" *

#-------------------------------------------------------------------------------
help:
	@echo make targets available:
	@echo "  help   print this help"
	@echo "  watch  run 'make build' when a file changes"
	@echo "  build  build the zxing-all-in-one files"

