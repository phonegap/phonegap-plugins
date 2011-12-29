Notice: this plugin is tested on phonegap 1.3.0 xcode 4.1 debugger shows no error

# How to Install

1. download the plugin ,Open your Xcode project, Right-click on the Plugins folder in Xcode and select “Add Files to…”.

2. select the pixFileDownload folder. Check “Copy items into. . .” and “Create groups for. . .” 

3. Copy/Paste the pixFileDownload.js file from the pixfiledownload folder to the www folder (or where ever you are placing your js files).

5. in you index.html file add this line in the head section:

```javascript
		<script type="text/javascript" charset="utf-8" src="phonegap-1.3.0.js"></script>
        <script type="text/javascript" charset="utf-8" src="pixFileDownload.js"></script>
		<script type="text/javascript">
    
              function onBodyLoad()
              {		
                   document.addEventListener("deviceready", onDeviceReady, false);
               }
              /* When this function is called, PhoneGap has been initialized and is ready to roll */
              /* If you are supporting your own protocol, the var invokeString will contain any arguments to the app launch.
              see http://iphonedevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html
              for more details -jm */
              function onDeviceReady()
	                {   
	                    // do your thing!
                        fileDownloadMgr.downloadFile(url,filepath);
						//url :refers to the file url
						//filepath : path for downloaded file (be sure to put /www/your downloadfolder name/filename)
	                }
		 </script>
```

6. add the plugin to your PhoneGap,plist file found in (Supporting Files > PhoneGap.plist) :

```
	Key: PixFileDownload
	Type: String
	Value: PixFileDownload
```

7. now we need to add the pixfiledownload declaration to AppDelegate.m  found in (Classes > AppDelegate.m) your file should look like this

so it looks like this now:

```
	#import "AppDelegate.h"
	#ifdef PHONEGAP_FRAMEWORK
		#import <PhoneGap/PhoneGapViewController.h>
	#else
		#import "PhoneGapViewController.h"
	#endif

	#import "PixFileDownload.h"

	@implementation AppDelegate
```

now the plugin is ready to work 


## Important Notice:

Orginal work can be found in https://github.com/aaronksaunders/FileDownLoadApp

fixes taken from:

* https://github.com/aaronksaunders/FileDownLoadApp/pull/1
* https://github.com/aaronksaunders/FileDownLoadApp/issues/3
* http://blog.clearlyinnovative.com/post/2056122828/phonegap-plugin-for-downloading-url-all-the-code#comment-328769638