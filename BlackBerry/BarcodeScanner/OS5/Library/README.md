# ZXing code for Cordova #

This directory contains a copy of the source used to build the ZXing library for use in OS 5 implementation.  The original ZXing source was simply repackaged under the `org.apache.cordova.plugins.barcodescanner` package prefix in order to work around class naming conflicts.

## Building an updated ZXing jar for OS 5 support ##

The barcode scanner plugin provides a precompiled version of the ZXing code for use with the OS 5 implementation.  The precompiled code is from ZXing v1.7.  If you need a more up to date version of ZXing it is possible to build your own copy of the ZXing jar for use in your application.  Follow these steps to build a jar that will work with the plugin:

1. Download the desired level of code from ZXing (http://code.google.com/p/zxing/downloads/list).
2. Extract the zip file of source.
3. Open a command window where the source was extracted and change directory to the "core" directory.
4. Refactor the source code contained in the core directory to prefix all the packages and packages references with `org.apache.cordova.plugins.barcodescanner`.
4. Execute `ant build` (or ant build-no-debug) on the command line to build the core.jar (requires Apache Ant).
5. Run preverify on the generated core.jar. The preverify.exe can be found in the BlackBerry WebWorks SDK installation folder (&lt;BBWW_SDK&gt;) under the "bin" folder.

    &lt;BBWW_SDK&gt;\bin\preverify.exe -classpath &lt;BBWW_SDK&gt;\lib\net_rim_api.jar core.jar
6. The preverified core.jar will be placed in a folder labeled "output" in the current directory.  Use the preverified core.jar in your application.

## LICENSE ##

This code is a package renaming of the [zxing](http://code.google.com/p/zxing/) project, which is licensed under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).
