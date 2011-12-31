PhoneGap.addConstructor(function() {
    
    var LabeledLocation = function(label,lat,lon)
    {
        this.label = label;
        if(lat && lon)
        {
            this.coordinates = {"latitude":lat,"longitude":lon};
        }
    };

    navigator.plugins.pgMapLauncher =
    {
        // searchText is required.
        // If nearToCoords is null, the map will search near to the current location
        searchNear:function(searchTerm, nearToCoords )
        {
            var options = {"searchTerm":searchTerm,"center":nearToCoords};
            PhoneGap.exec(null,null,"PGMapLauncher","searchNear",options);
        },

        // toLabeledLocation is required
        // if toLabeledLocation.
        // if fromLabeledLocation is null, the current location will be used
        getDirections:function(toLabeledLocation,fromLabeledLocation)
        {
            PhoneGap.exec(null,null,"PGMapLauncher","getDirections",
                    {"startPosition":fromLabeledLocation,"endPosition":toLabeledLocation});
        }
    }
});