ModalViewControllerPlugin
=========================

BonjourPlugin
=============

Native iOS modal UIViewControllers for PhoneGap/Cordova.

This plugin allows a PhoneGap/Cordova app to present/dismiss modal view controllers
on iOS.

Follows the [Cordova Plugin spec](https://github.com/alunny/cordova-plugin-spec),
so that it works with [Pluginstall](https://github.com/alunny/pluginstall).

## File Structure

    plugin.xml
    -- src
      -- ios
        -- ModalViewControllerPlugin.h
        -- ModalViewControllerPlugin.m
    -- www
      -- ModalViewControllerPlugin.js

## plugin.xml

The plugin.xml file is loosely based on the W3C's Widget Config spec.

It is in XML to facilitate transfer of nodes from this cross platform manifest
to native XML manifests (AndroidManifest.xml, App-Info.plist, config.xml (BB)).

A specification for this file format will be forthcoming once more feedback
has been received, and the tooling around plugin installation is more mature. 

## ModalViewControllerPlugin JavaScript API

As with most PhoneGap/Cordova APIs, functionality is not available until the
`deviceready` event has fired on the document. The `ModalViewControllerPlugin.js` file
should be included _after_ the `phonegap.js` file.

All functions are called on the singleton ModalViewControllerPlugin instance - accessible
as `window.plugins.modalViewControllerPlugin`.

### Methods

#### presentModalViewController

    presentModalViewController(options, callback)

Presents a modal view controller with the specified options. Once the modal has
been displayed, the callback function will be executed.

Available options:

* `viewControllerName` (String) - The name of the UIViewController subclass to present.
* `nibName` (String) - The name of the NIB to use when initializing the UIViewController subclass.
* `useNavigationController` (Boolean) - A flag indicating if the modal's view controller should be a UINavigationController that has the specified UIViewController subclass as its root view controller. 
* `animated` - A flag indicating if the presentation of the modal should be animated.

Example:

    window.plugins.modalViewControllerPlugin.presentModalViewController({
      viewControllerName: 'MyModalViewController',
      nibName: null,
      useNavigationController: true,
      animated: true
    }, function() { ... });

#### dismissModalViewController

    dismissModalViewController(options, callback)

Dismisses the current modal view controller with the specified options. Once the
modal has been dismissed, the callback function will be executed.

Available options:

* `animated` - A flag indicating if the dismissal of the modal should be animated.

Example:

    window.plugins.modalViewControllerPlugin.dismissModalViewController({
      animated: true
    }, function() { ... });

## License

Copyright 2012 Entropi Software, LLC.

Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
