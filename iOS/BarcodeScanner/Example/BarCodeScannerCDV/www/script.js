    


  // If you want to prevent dragging, uncomment this section
  /*
  function preventBehavior(e) 
  { 
      e.preventDefault(); 
    };
  document.addEventListener("touchmove", preventBehavior, false);
  */
  
  /* If you are supporting your own protocol, the var invokeString will contain any arguments to the app launch.
  see http://iphonedevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html
  for more details -jm */
  /*
  function handleOpenURL(url)
  {
    // TODO: do something with the url passed in.
  }
  */
  
  function onBodyLoad()
  {   
    document.addEventListener("deviceready", onDeviceReady, false);

    scanButton = document.getElementById("scan-button");
    encodeButton = document.getElementById("encode-button");
    resultSpan = document.getElementById("scan-result");
    encodeImage=document.getElementById('encoded_image');
  }
  

  /* When this function is called, PhoneGap has been initialized and is ready to roll */
  /* If you are supporting your own protocol, the var invokeString will contain any arguments to the app launch.
  see http://iphonedevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html
  for more details -jm */
  function onDeviceReady()
  {
    // do your thing!
    navigator.notification.alert("PhoneGap is working");

    scanButton.addEventListener("click", clickScan, false);
    encodeButton.addEventListener("click", clickEncode, false);
  }


function clickScan() {
    window.plugins.barcodeScanner.scan(scannerSuccess, scannerFailure);
}

function clickEncode() {
    encodeImage.src='';
     window.plugins.barcodeScanner.encode(null,'Hello World',encodeSuccess,scannerFailure);
}

function encodeSuccess(result){
    encodeImage.hidden=false;
    encodeImage.src='data:image/png;base64,'+result;
}

//------------------------------------------------------------------------------
function scannerSuccess(result) {
    console.log("scannerSuccess: result: " + result)
    resultSpan.innerText = "success: " + JSON.stringify(result)
}

//------------------------------------------------------------------------------
function scannerFailure(message) {
    console.log("scannerFailure: message: " + message)
    resultSpan.innerText = "failure: " + JSON.stringify(message)
}

