# Unique Identifier support for iOS applications

_Created by `Andrew Thorp`_

Usage:

    // To GENERATE a Unique ID
    PGUniqueIdentifier.generateUUID(function(result){
      // result will be the new UUID or the UUID that is stored in this apps NSDefaults
    });

    // To GET the Unique ID
    PGUniqueIdentifier.getUUID(function(result){
      // result will be the UUID stored in this apps NSDefaults
    }, function(error){
      // If a UUID has not yet been generated, you will receive the error "ERROR".
    });