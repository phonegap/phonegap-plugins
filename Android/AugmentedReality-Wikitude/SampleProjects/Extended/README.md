
# Hello Image Recognition Android

This document describes all necessary steps to get the sample running.
Once set up, the app augments the [Wikitude Logo](http://www.flickr.com/photos/wikitude/5571196416/) in your camera.


####Prerequisites:
* You need to [register as developer at Wikitude](http://developer.wikitude.com) and downloaded the SDK, two files from the SDK's Android-folder are required, as described below.

* Download the Vuforia Framework from [Qualcomm](https://ar.qualcomm.at/sdk/android) (You need to register yourself as a Qualcomm developer)


# SETUP


* [Import HelloImageRecognition-project in Eclipse as Android-Project](https://www.google.com/webhp?sourceid=chrome-instant&ie=UTF-8&ion=1#hl=de&output=search&sclient=psy-ab&q=import%20android%20project%20into%20eclipse&oq=&gs_l=&pbx=1&fp=531bf0abdc9ea0e7&ion=1&bav=on.2,or.r_gc.r_pw.r_cp.r_qf.&biw=1030&bih=550)
* Copy `wikitudesdk.jar` from the Android [WikitudeSDK](http://developer.wikitude.com) to project's `libs`-folder

* Copy `libExtensionVuforia.so` from the Android [WikitudeSDK](http://developer.wikitude.com) to `libs/armeabi`-folder (create subfolder if necessary)

* From [Qualcomm's Vuforia SDK](https://ar.qualcomm.at/sdk/android): Copy `QCAR.jar` to your projects `libs`-folder and add it to your project's build. Also copy Vuforia's `libQCAR.so`  to your `libs/armeabi`-folder