//------------------------------------------------------------------------------
// PhoneGap is available under *either* the terms of the modified BSD license *or* the
// MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
//
// Copyright (c) 2011, IBM Corporation
//------------------------------------------------------------------------------

var thisImage = -1
var total     = ImageData.length

var successes = []
var failures  = []

var resultsList

for (var i=0; i<total; i++) {
    ImageData[i].type = ImageData[i].format
}

//------------------------------------------------------------------------------
function scannerFake(success, failure) {
    if (thisImage == null) {
        success({cancelled: true})
    }
    else {
        success({
            cancelled: false,
            text:      ImageData[thisImage].text,
            format:    ImageData[thisImage].format
        })
    }
}

//------------------------------------------------------------------------------
function onLoad() {
    if (window.PhoneGap) {
        document.addEventListener("deviceready",onDeviceReady,false);
    }
    else {
        if (!window.plugins)                window.plugins = {}
        if (!window.plugins.barcodeScanner) window.plugins.barcodeScanner = {
            scan: scannerFake
        }
        setTimeout(onDeviceReady,10)
    }

    $("scan-button").onclick = scanNext
    $("start-over").onclick = rerun

    updateText("test-count-total", total+1)

    resultsList = $("results-list")
}

//------------------------------------------------------------------------------
function onDeviceReady() {
    next()
}

//------------------------------------------------------------------------------
function rerun() {
    thisImage = -1
    resultsList.innerHTML = ""
    updateText("test-done", "")
    $("running-bits").style.display = "block"
    next()
}

//------------------------------------------------------------------------------
function scanNext() {
    try {
        window.plugins.barcodeScanner.scan(scannerSuccess, scannerFailure)
    }
    catch (e) {
        scannerFailure("exception scanning: " + e)
    }
}

//------------------------------------------------------------------------------
function scannerSuccess(result) {
    console.log("scanner returned: " + JSON.stringify(result))

    if (null == thisImage) {
        if (!result.cancelled) {
            scannerFailure("result does not indicate cancelled: " + result.cancelled)
            return
        }

        var newItem = "<li style='color:green'>cancelled"
        resultsList.innerHTML += newItem
    }

    else {
        if (result.cancelled) {
            scannerFailure("cancelled instead of scanning: '" + ImageData[thisImage].text + "'")
            return
        }

        if (result.text != ImageData[thisImage].text) {
            scannerFailure("scanned wrong text: '" + result.text + "'")
            return
        }

        if (result.format != ImageData[thisImage].format) {
            scannerFailure("scanned wrong format: '" + result.format + "'")
            return
        }

        var newItem = "<li style='color:green'>" + ImageData[thisImage].image
        resultsList.innerHTML += newItem
    }

    next()
}

//------------------------------------------------------------------------------
function scannerFailure(message) {
    console.log("BarcodeScanner failure: " + message)

    var newItem
    if (thisImage != null) {
        newItem = "<li style='color:red'>" + ImageData[thisImage].image + " : " + message
    }
    else {
        newItem = "<li style='color:red'>" + message
    }

    resultsList.innerHTML += newItem

    next()
}

//------------------------------------------------------------------------------
function next() {
    if (thisImage === null) {
        updateText("test-done", "All Done!")
        $("running-bits").style.display = "none"
        return
    }

    thisImage++

    if (thisImage == total) {
        thisImage = null
        updateImage("")
        updateText("scan-button", "scan: {press cancel}")
        updateText("test-text", "{press cancel}")
        updateText("test-count-current", total+1)
        return
    }

    updateImage(ImageData[thisImage].image)
    updateText("scan-button", "scan: " + ImageData[thisImage].image)
    updateText("test-text", ImageData[thisImage].text)
    updateText("test-count-current", thisImage + 1)
}

//------------------------------------------------------------------------------
function updateText(id, text) {
    $(id).innerText = text
}

//------------------------------------------------------------------------------
function updateImage(image) {
    var element = $("image")

    if (image == null) {
        element.parentNode.removeChild(element)
        return
    }

    element.src = "images/" + image
}

//------------------------------------------------------------------------------
function $(id) {
    var element = document.getElementById(id)
    if (!element) alert("can't find element with id '" + id + "'")
    return element
}
