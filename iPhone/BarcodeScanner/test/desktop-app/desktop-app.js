//------------------------------------------------------------------------------
// PhoneGap is available under *either* the terms of the modified BSD license *or* the
// MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
//
// Copyright (c) 2011, IBM Corporation
//------------------------------------------------------------------------------

var onLoad
var displayNextTest

;(function(){

var TestsTotal
var TestCurrent
var LastStatus
var Template

//------------------------------------------------------------------------------
function onLoadInner() {
    Template    = $("template").innerHTML
    TestsTotal  = ImageData.length + 1
    TestCurrent = -1
    LastStatus  = ""

    displayNextTest()
}

onLoad = onLoadInner

//------------------------------------------------------------------------------
function displayNextTestInner() {
    TestCurrent += 1

    if (TestCurrent >= TestsTotal - 1) {
        $("content").innerHTML = "press cancel<p><a href=''>re-run</a>"
        return
    }

    $("content").innerHTML = fillTemplate(Template)
}

displayNextTest = displayNextTestInner

//------------------------------------------------------------------------------
function fillTemplate(template) {
    template = template.replace(/{{current}}/g, TestCurrent + 1)
    template = template.replace(/{{total}}/g,   TestsTotal)
    template = template.replace(/{{image}}/g,   escapeHTML(ImageData[TestCurrent].image))
    template = template.replace(/{{text}}/g,    escapeHTML(ImageData[TestCurrent].text))
    template = template.replace(/{{format}}/g,  escapeHTML(ImageData[TestCurrent].format))

    return template
}

//------------------------------------------------------------------------------
function $(id) {
    var element = document.getElementById(id)
    if (!element) alert("can't find element with id '" + id + "'")
    return element
}

//------------------------------------------------------------------------------
function escapeHTML(string) {
    return string
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/&/g, '&amp;')
}

})();
