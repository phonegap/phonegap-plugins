# SoundPlug, webOS

## Rationale
This plugin makes it possible to play low-latency sounds in a webOS app.

The native JavaScript "Audio" object in webOS is not usable for playing sounds in games etc. The latency is too high, and playing multiple sounds for an extended period leads to various problems.

This plugin can be used in a webOS "hybrid" app. That is by using both browser code and native code in the .ipk.

The native code in this plugin uses SDL_mixer to play sound. This means multiple sounds can play at the same time and the same sound can play overlapping itself (essential for arcade games).

The plugin has been developed for use with the game Orbium (https://github.com/bni/orbium), but It should be generally useful for all games and multimedia apps.

## Usage
You must define a "object" element like this somewhere in your page (eg index.html, or in a mojo scene):

```html
<object id="soundPlug" width="1" height="1" type="application/x-palm-remote" x-palm-pass-event="true">
<param name="appid" value="<your-app-id>">
<param name="exe" value="soundplug_plugin">
<param name="Param1" value="0">
<param name="Param2" value="1">
</object>
```

Sounds can then be played from JavaScript like this:

```javascript
document.getElementById("soundPlug").play("boink.wav");

```

Copy boink.wav (and other sound files you have), to your project directory.

All the files from this repo must be added to your project.

Use build_plugin.sh to build the plugin binary itself.

For more details of the webOS JavaScript plugin interface:
https://developer.palm.com/content/api/dev-guide/pdk/js-and-plug-in-interface.html

This plugin has been built with the 3.0 SDK and verified to work on webOS 1.4.5 and 3.0. It should work on all versions and on all webOS hardware.

For an example on how to use SoundPlug plugins on multiple platforms, see this:
https://github.com/bni/orbium/blob/gh-pages/js/player.js

## License
The MIT License

Copyright (c) 2011 Björn Nilsson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
