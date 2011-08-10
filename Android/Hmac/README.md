# HMAC plugin for Android/Phonegap #
Ionut Voda <ionut.voda@zitec.ro>

## About ##

The current plugin will help you produce UTF-8 compatible HMAC hashes(http://en.wikipedia.org/wiki/HMAC). It currently supports 2 hasher functions: sha1 which produces a HMAC-SHA1 hash and md5 which generates a HMAC-MD5.

## Installing the plugin ##

There are no special steps to follow when installing the plugin beside the official recommendation http://wiki.phonegap.com/w/page/43708611/How%20to%20Install%20a%20PhoneGap%20Plugin%20for%20Android

## Using the plugin ##

<pre>
// to generate a HMAC-SHA1 hash
window.plugins.hmac.sha1(
    "string you want to hash", 
    "key to hash with",
    function hashResult(jsonHash) {
        //the param has a single property called "hash" that contains your hash
        alert(jsonHash.hash)
    }
);
</pre>

<pre>
// or the MD5 version
window.plugins.hmac.md5(
    "string you want to hash", 
    "key to hash with",
    function hashResult(jsonHash) {
        alert(jsonHash.hash)
    }
);
</pre>

## Licence ##

The MIT License

Copyright (c) 2011 Ionut Voda

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