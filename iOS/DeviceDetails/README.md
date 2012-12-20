# Cordova DeviceDetails plugin #

    window.plugins.deviceDetails.getDetails(function(details) {
      // {"deviceModel":"iPhone Simulator","deviceName":"iPhone Simulator","deviceSystemVersion":"5.1"}
      localStorage.setItem('deviceModel', details.deviceModel)
      localStorage.setItem('deviceName', details.deviceName)
      localStorage.setItem('deviceSystemVersion', details.deviceSystemVersion)
    })
    
    // UUID is in a separate call because it got deprecated and requires explicit user permission now
    window.plugins.deviceDetails.getUUID(function(response) {
      // {"deviceUuid":"AADCC45F-C305-5A7F-96F7-6CF122CD0388"}
      localStorage.setItem('deviceUuid', response.deviceUuid)
    })
