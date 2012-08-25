var PGUniqueIdentifier = {

    generateUUID: function(success, fail) {
        return PhoneGap.exec(success, fail, "PGUniqueIdentifier", "generateUUID", []);
    },

    getUUID: function(success, fail) {
        return PhoneGap.exec(success, fail, "PGUniqueIdentifier", "getUUID", []);
    }
    
};