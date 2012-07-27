# AppLinker plugin for PhoneGap #

By Ulf Hartelius, Nindev AB

This app simply either launches Google Play and goes to the selected app OR, if the selected app is already installed, launches the app.
Good for promoting other apps or for easy connection between your apps.

## Adding the plugin to your project ##
1. Move applinker.js to your project's www folder and reference it in your html file(s).
2. Add the AppLinker.java inside a package se.nindev.applinker

## Using the plugin ##
There's only a single method: linkApp(packageName, success, fail).
In your js code, call new AppLinker().linkApp (or have an AppLinker object created earlier) with the arguments you want. Specifically, the packageName parameter is the full package name of the app you want to link to (e.g. se.lineducation.skolkoll). That's it.
Note that the package name is publicly available, so you can link to apps that you haven't created. Easiest way of finding a package name is to go to it on Google Play and see the id in the url.

## Licence ##

The MIT License

Copyright (c) 2012 Ulf Hartelius, Nindev AB

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.