# SoundPlug, iOS

## Rationale
This plugin makes it possible to play low-latency sounds in an iOS app.

The native JavaScript "Audio" object in iOS is not usable at all. The same goes for the PhoneGap "Media" object, that has high latency and other problems.

Multiple sounds can play at the same time and the same sound can play overlapping itself (essential for arcade games).

The plugin has been developed for use with the game Orbium (https://github.com/bni/orbium), but It should be generally useful for all games and multimedia apps.

## Usage
Add SoundPlug.m and SoundPlug.h to your xcode project (in the Plugins dir).

Add test.wav to xcode project as a resource.

Play sound in JavaScript like this:

```javascript
PhoneGap.exec("SoundPlug.play", "test.wav");

```

For an example on how to use SoundPlug plugins on multiple platforms, see this:
https://github.com/bni/orbium/blob/gh-pages/js/player.js

## License
The MIT License

Copyright (c) 2011 Björn Nilsson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
