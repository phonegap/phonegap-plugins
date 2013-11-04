BonjourPlugin
=============

Bonjour (mDNS) plugin for PhoneGap/Cordova.

This plugin allows a PhoneGap/Cordova app to discover Bonjour (mDNS) services on
the local network. Currently, the only supported platform is iOS.

Follows the [Cordova Plugin spec](https://github.com/alunny/cordova-plugin-spec),
so that it works with [Pluginstall](https://github.com/alunny/pluginstall).

## File Structure

    plugin.xml
    -- src
      -- ios
        -- BonjourPlugin.h
        -- BonjourPlugin.m
    -- www
      -- BonjourPlugin.js

## plugin.xml

The plugin.xml file is loosely based on the W3C's Widget Config spec.

It is in XML to facilitate transfer of nodes from this cross platform manifest
to native XML manifests (AndroidManifest.xml, App-Info.plist, config.xml (BB)).

A specification for this file format will be forthcoming once more feedback
has been received, and the tooling around plugin installation is more mature. 

## BonjourPlugin JavaScript API

As with most PhoneGap/Cordova APIs, functionality is not available until the
`deviceready` event has fired on the document. The `BonjourPlugin.js` file
should be included _after_ the `phonegap.js` file.

All functions are called on the singleton BonjourPlugin instance - accessible
as `window.plugins.bonjourPlugin`.

### Methods

#### startServiceDiscovery

    startServiceDiscovery(serviceType, searchDomain, callback)

Starts searching for a network service with the specified type in the
specified search domain. When a service of the specified type is discovered,
the callback function will be executed passing in a single URL argument with
the location of the discovered service.

Example:

    window.plugins.bonjourPlugin.startServiceDiscovery('_http._tcp', 'local', function(url) { ... });

#### stopServiceDiscovery

    stopServiceDiscovery()

Stops any pending network service discoveries. NOTE: When a service has been
discovered using the `startServiceDiscovery` method, no further discoveries
will be attempted and it is not required that this method be called to stop
the search.

Example:

    window.plugins.bonjourPlugin.stopServiceDiscovery();

## License

Copyright 2012 Entropi Software, LLC.

Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
