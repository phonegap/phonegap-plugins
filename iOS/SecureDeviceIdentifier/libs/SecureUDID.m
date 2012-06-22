//
//  SecureUDID.m
//  SecureUDID
//
//  Created by Crashlytics Team on 3/22/12.
//  Copyright (c) 2012 Crashlytics, Inc. All rights reserved.
//  http://www.crashlytics.com
//  info@crashlytics.com
//

/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "SecureUDID.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <sys/sysctl.h>

#define SUUID_SCHEMA_VERSION        (1)
#define SUUID_MAX_STORAGE_LOCATIONS (64)

NSString *const SUUIDDefaultIdentifier   = @"00000000-0000-0000-0000-000000000000";

NSString *const SUUIDTypeDataDictionary  = @"public.secureudid";
NSString *const SUUIDTimeStampKey        = @"SUUIDTimeStampKey";
NSString *const SUUIDOwnerKey            = @"SUUIDOwnerKey";
NSString *const SUUIDLastAccessedKey     = @"SUUIDLastAccessedKey";
NSString *const SUUIDIdentifierKey       = @"SUUIDIdentifierKey";
NSString *const SUUIDOptOutKey           = @"SUUIDOptOutKey";
NSString *const SUUIDModelHashKey        = @"SUUIDModelHashKey";
NSString *const SUUIDSchemaVersionKey    = @"SUUIDSchemaVersionKey";
NSString *const SUUIDPastboardFileFormat = @"org.secureudid-%d";

NSData       *SUUIDCryptorToData(CCOperation operation, NSData *value, NSData *key);
NSString     *SUUIDCryptorToString(CCOperation operation, NSData *value, NSData *key);
NSData       *SUUIDHash(NSData* data);
NSData       *SUUIDModelHash(void);

void          SUUIDMarkOptedOut(void);
void          SUUIDMarkOptedIn(void);
void          SUUIDRemoveAllSecureUDIDData(void);
NSString     *SUUIDPasteboardNameForNumber(NSInteger number);
NSInteger     SUUIDStorageLocationForOwnerKey(NSData *key, NSMutableDictionary** dictionary);
NSDictionary *SUUIDDictionaryForStorageLocation(NSInteger number);
NSDictionary *SUUIDMostRecentDictionary(void);
void          SUUIDWriteDictionaryToStorageLocation(NSInteger number, NSDictionary* dictionary);
void          SUUIDDeleteStorageLocation(NSInteger number);

BOOL          SUUIDValidTopLevelObject(id object);
BOOL          SUUIDValidOwnerObject(id object);

@implementation SecureUDID

/*
 Returns a unique id for the device, sandboxed to the domain and salt provided.

 Example usage:
 #import "SecureUDID.h"

 NSString *udid = [SecureUDID UDIDForDomain:@"com.example.myapp" salt:@"superSecretCodeHere!@##%#$#%$^"];

 */
+ (NSString *)UDIDForDomain:(NSString *)domain usingKey:(NSString *)key {
    NSString *identifier = SUUIDDefaultIdentifier;

    // Salt the domain to make the crypt keys affectively unguessable.
    NSData *domainAndKey = [[NSString stringWithFormat:@"%@%@", domain, key] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ownerKey      = SUUIDHash(domainAndKey);

    // Encrypt the salted domain key and load the pasteboard on which to store data
    NSData *encryptedOwnerKey = SUUIDCryptorToData(kCCEncrypt, [domain dataUsingEncoding:NSUTF8StringEncoding], ownerKey);

    // @synchronized introduces an implicit @try-@finally, so care needs to be taken with the return value
    @synchronized (self) {
        NSMutableDictionary *topLevelDictionary = nil;

        // Retrieve an appropriate storage index for this owner
        NSInteger ownerIndex = SUUIDStorageLocationForOwnerKey(encryptedOwnerKey, &topLevelDictionary);

        // If the model hash key is present, verify it, otherwise add it
        NSData *storedModelHash = [topLevelDictionary objectForKey:SUUIDModelHashKey];
        NSData *modelHash       = SUUIDModelHash();

        if (storedModelHash) {
            if (![modelHash isEqual:storedModelHash]) {
                // The model hashes do not match - this structure is invalid
                [topLevelDictionary removeAllObjects];
            }
        }

        // store the current model hash
        [topLevelDictionary setObject:modelHash forKey:SUUIDModelHashKey];

        // check for the opt-out flag and return the default identifier if we find it
        if ([[topLevelDictionary objectForKey:SUUIDOptOutKey] boolValue] == YES) {
            return identifier;
        }

        // If we encounter a schema version greater than we support, there is no simple alternative
        // other than to simulate Opt Out.  Any writes to the store risk corruption.
        if ([[topLevelDictionary objectForKey:SUUIDSchemaVersionKey] intValue] > SUUID_SCHEMA_VERSION) {
            return identifier;
        }

        // Attempt to get the owner's dictionary.  Should we get back nil from the encryptedDomain key, we'll still
        // get a valid, empty mutable dictionary
        NSMutableDictionary *ownerDictionary = [NSMutableDictionary dictionaryWithDictionary:[topLevelDictionary objectForKey:encryptedOwnerKey]];

        // Set our last access time and claim ownership for this storage location.
        NSDate* lastAccessDate = [NSDate date];

        [ownerDictionary    setObject:lastAccessDate    forKey:SUUIDLastAccessedKey];
        [topLevelDictionary setObject:lastAccessDate    forKey:SUUIDTimeStampKey];
        [topLevelDictionary setObject:encryptedOwnerKey forKey:SUUIDOwnerKey];

        [topLevelDictionary setObject:[NSNumber numberWithInt:SUUID_SCHEMA_VERSION] forKey:SUUIDSchemaVersionKey];

        // Make sure our owner dictionary is in the top level structure
        [topLevelDictionary setObject:ownerDictionary forKey:encryptedOwnerKey];


        NSData *identifierData = [ownerDictionary objectForKey:SUUIDIdentifierKey];
        if (identifierData) {
            identifier = SUUIDCryptorToString(kCCDecrypt, identifierData, ownerKey);
            if (!identifier) {
                // We've failed to decrypt our identifier.  This is a sign of storage corruption.
                SUUIDDeleteStorageLocation(ownerIndex);

                // return here - do not write values back to the store
                return SUUIDDefaultIdentifier;
            }
        } else {
            // Otherwise, create a new RFC-4122 Version 4 UUID
            // http://en.wikipedia.org/wiki/Universally_unique_identifier
            CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
            identifier = [(NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuid) autorelease];
            CFRelease(uuid);

            // Encrypt it for storage.
            NSData *data = SUUIDCryptorToData(kCCEncrypt, [identifier dataUsingEncoding:NSUTF8StringEncoding], ownerKey);

            [ownerDictionary setObject:data forKey:SUUIDIdentifierKey];
        }

        SUUIDWriteDictionaryToStorageLocation(ownerIndex, topLevelDictionary);
    }

    return identifier;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
+ (void)retrieveUDIDForDomain:(NSString *)domain usingKey:(NSString *)key completion:(void (^)(NSString* identifier))completion {
    // retreive the identifier on a low-priority thread

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString* identifier;

        identifier = [SecureUDID UDIDForDomain:domain usingKey:key];

        completion(identifier);
    });
}
#endif

/*
 API to determine if a device has opted out of SecureUDID.
 */
+ (BOOL)isOptedOut {
    for (NSInteger i = 0; i < SUUID_MAX_STORAGE_LOCATIONS; ++i) {
        NSDictionary* topLevelDictionary;

        topLevelDictionary = SUUIDDictionaryForStorageLocation(i);
        if (!topLevelDictionary) {
            continue;
        }

        if ([[topLevelDictionary objectForKey:SUUIDOptOutKey] boolValue] == YES) {
            return YES;
        }
    }

    return NO;
}

/*
 Applies the operation (encrypt or decrypt) to the NSData value with the provided NSData key
 and returns the value as NSData.
 */
NSData *SUUIDCryptorToData(CCOperation operation, NSData *value, NSData *key) {
    NSMutableData *output = [NSMutableData dataWithLength:value.length + kCCBlockSizeAES128];

    size_t numBytes = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],
                                          kCCKeySizeAES128,
                                          NULL,
                                          value.bytes,
                                          value.length,
                                          output.mutableBytes,
                                          output.length,
                                          &numBytes);

    if (cryptStatus == kCCSuccess) {
        return [[[NSData alloc] initWithBytes:output.bytes length:numBytes] autorelease];
    }

    return nil;
}

/*
 Applies the operation (encrypt or decrypt) to the NSData value with the provided NSData key
 and returns the value as an NSString.
 */
NSString *SUUIDCryptorToString(CCOperation operation, NSData *value, NSData *key) {
    NSData* data;

    data = SUUIDCryptorToData(operation, value, key);
    if (!data) {
        return nil;
    }

    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

/*
 Compute a SHA1 of the input.
 */
NSData *SUUIDHash(NSData __unsafe_unretained * data) {
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};

    CC_SHA1(data.bytes, data.length, digest);

    return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

NSData* SUUIDModelHash(void) {
    NSString* result;

    result = @"Unknown";

    do {
        size_t size;
        char*  value;

        value  = NULL;

        // first get the size
        if (sysctlbyname("hw.machine", NULL, &size, NULL, 0) != 0) {
            break;
        }

        value = malloc(size);
        if (!value) {
            break;
        }

        // now get the value
        if (sysctlbyname("hw.machine", value, &size, NULL, 0) != 0) {
            break;
        }

        // convert the value to an NSString
        result = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
        if (!result) {
            break;
        }

        // free our buffer
        free(value);
    } while (0);

    return SUUIDHash([result dataUsingEncoding:NSUTF8StringEncoding]);
}

/*
 Finds the most recent structure, and adds the Opt-Out flag to it.  Then writes that structure back
 out to all used storage locations, making sure to preserve ownership.
 */
void SUUIDMarkOptedOut(void) {
    NSMutableDictionary* mostRecentDictionary;

    mostRecentDictionary = [NSMutableDictionary dictionaryWithDictionary:SUUIDMostRecentDictionary()];

    [mostRecentDictionary setObject:[NSDate date]                 forKey:SUUIDTimeStampKey];
    [mostRecentDictionary setObject:[NSNumber numberWithBool:YES] forKey:SUUIDOptOutKey];

    for (NSInteger i = 0; i < SUUID_MAX_STORAGE_LOCATIONS; ++i) {
        NSData* owner;

        // Inherit the owner, if it is present.  This makes some schema assumptions.
        owner = [SUUIDDictionaryForStorageLocation(i) objectForKey:SUUIDOwnerKey];
        if (owner) {
            [mostRecentDictionary setObject:owner forKey:SUUIDOwnerKey];
        }

        // write the opt-out data even if the location was previously empty
        SUUIDWriteDictionaryToStorageLocation(i, mostRecentDictionary);
    }
}

void SUUIDMarkOptedIn(void) {
    NSDate* accessedDate;

    accessedDate = [NSDate date];

    // Opting back in is trickier.  We need to remove top-level Opt-Out markers.  Also makes some
    // schema assumptions.
    for (NSInteger i = 0; i < SUUID_MAX_STORAGE_LOCATIONS; ++i) {
        NSMutableDictionary* dictionary;

        dictionary = [NSMutableDictionary dictionaryWithDictionary:SUUIDDictionaryForStorageLocation(i)];
        if (!dictionary) {
            // This is a possible indiction of storage corruption.  However, SUUIDDictionaryForStorageLocation
            // will have already cleaned it up for us, so there's not much to do here.
            continue;
        }

        [dictionary removeObjectForKey:SUUIDOptOutKey];

        // quick check for the minimum set of keys.  If the dictionary previously held just
        // an Opt-Out marker + timestamp, dictionary is not invalid.  Writing will fail in this
        // case, leaving the data that was there.  We need to delete.
        if (!SUUIDValidTopLevelObject(dictionary)) {
            SUUIDDeleteStorageLocation(i);
            continue;
        }

        [dictionary setObject:accessedDate forKey:SUUIDTimeStampKey];

        SUUIDWriteDictionaryToStorageLocation(i, dictionary);
    }
}

/*
 Removes all SecureUDID data from storage with the exception of Opt-Out flags, which
 are never removed.  Removing the Opt-Out flags would effectively opt a user back in.
 */
void SUUIDRemoveAllSecureUDIDData(void) {
    NSDictionary* optOutPlaceholder = nil;

    if ([SecureUDID isOptedOut]) {
        optOutPlaceholder = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:SUUIDOptOutKey];
    }

    for (NSInteger i = 0; i < SUUID_MAX_STORAGE_LOCATIONS; ++i) {
        if (optOutPlaceholder) {
            SUUIDWriteDictionaryToStorageLocation(i, optOutPlaceholder);
            continue;
        }

        SUUIDDeleteStorageLocation(i);
    }
}

/*
 Returns an NSString formatted with the supplied number.
 */
NSString *SUUIDPasteboardNameForNumber(NSInteger number) {
    return [NSString stringWithFormat:SUUIDPastboardFileFormat, number];
}

/*
 Reads a dictionary from a storage location.  Validation occurs once data
 is read, but before it is returned.  If something fails, or if the read structure
 is invalid, the location is cleared.

 Returns the data dictionary, or nil on failure.
 */
NSDictionary *SUUIDDictionaryForStorageLocation(NSInteger number) {
    id            decodedObject;
    UIPasteboard* pasteboard;
    NSData*       data;

    // Don't even bother if the index is outside our limits
    if (number < 0 || number >= SUUID_MAX_STORAGE_LOCATIONS) {
        return nil;
    }

    pasteboard = [UIPasteboard pasteboardWithName:SUUIDPasteboardNameForNumber(number) create:NO];
    if (!pasteboard) {
        return nil;
    }

    data = [pasteboard valueForPasteboardType:SUUIDTypeDataDictionary];
    if (!data) {
        return nil;
    }

    @try {
        decodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } @catch (NSException* exception) {
        // Catching an exception like this is risky.   However, crashing here is
        // not acceptable, and unarchiveObjectWithData can throw.
        [pasteboard setData:nil forPasteboardType:SUUIDTypeDataDictionary];

        return nil;
    }

    if (!SUUIDValidTopLevelObject(decodedObject)) {
        [pasteboard setData:nil forPasteboardType:SUUIDTypeDataDictionary];

        return nil;
    }

    return decodedObject;
}

NSDictionary *SUUIDMostRecentDictionary(void) {
    NSDictionary* mostRecentDictionary;
    BOOL          found;

    mostRecentDictionary = [NSDictionary dictionaryWithObject:[NSDate distantPast] forKey:SUUIDTimeStampKey];

    // scan all locations looking for the most recent
    for (NSUInteger i = 0; i < SUUID_MAX_STORAGE_LOCATIONS; ++i) {
        NSDictionary* dictionary;
        NSDate*       date;

        dictionary = SUUIDDictionaryForStorageLocation(i);
        if (!dictionary) {
            continue;
        }

        // Schema assumption
        date = [dictionary objectForKey:SUUIDTimeStampKey];
        if ([date compare:[mostRecentDictionary objectForKey:SUUIDTimeStampKey]] == NSOrderedDescending) {
            mostRecentDictionary = dictionary;
            found = YES;
        }
    }

    if (!found) {
        return nil;
    }

    return mostRecentDictionary;
}

/*
 Writes out a dictionary to a storage location.  That dictionary must be a 'valid'
 SecureUDID structure, and the location must be within range.  A new location is
 created if is didn't already exist.
 */
void SUUIDWriteDictionaryToStorageLocation(NSInteger number, NSDictionary* dictionary) {
    UIPasteboard* pasteboard;

    // be sure to respect our limits
    if (number < 0 || number >= SUUID_MAX_STORAGE_LOCATIONS) {
        return;
    }

    // only write out valid structures
    if (!SUUIDValidTopLevelObject(dictionary)) {
        return;
    }

    pasteboard = [UIPasteboard pasteboardWithName:SUUIDPasteboardNameForNumber(number) create:YES];
    if (!pasteboard) {
        return;
    }

    pasteboard.persistent = YES;

    [pasteboard setData:[NSKeyedArchiver archivedDataWithRootObject:dictionary]
      forPasteboardType:SUUIDTypeDataDictionary];
}

/*
 Clear a storage location, removing anything stored there.  Useful for dealing with
 potential corruption.  Be careful with this function, as it can remove Opt-Out markers.
 */
void SUUIDDeleteStorageLocation(NSInteger number) {
    UIPasteboard* pasteboard;
    NSString*     name;

    if (number < 0 || number >= SUUID_MAX_STORAGE_LOCATIONS) {
        return;
    }

    name       = SUUIDPasteboardNameForNumber(number);
    pasteboard = [UIPasteboard pasteboardWithName:name create:NO];
    if (!pasteboard)
        return;

    // While setting pasteboard data to nil seems to always remove contents, the
    // removePasteboardWithName: call doesn't appear to always work.  Using both seems
    // like the safest thing to do
    [pasteboard setData:nil forPasteboardType:SUUIDTypeDataDictionary];
    [UIPasteboard removePasteboardWithName:name];
}

/*
 SecureUDID leverages UIPasteboards to persistently store its data.
 UIPasteboards marked as 'persistent' have the following attributes:
 - They persist across application relaunches, device reboots, and OS upgrades.
 - They are destroyed when the application that created them is deleted from the device.

 To protect against the latter case, SecureUDID leverages multiple pasteboards (up to
 SUUID_MAX_STORAGE_LOCATIONS), creating one for each distinct domain/app that
 leverages the system. The permanence of SecureUDIDs increases exponentially with the
 number of apps that use it.

 This function searches for a suitable storage location for a SecureUDID structure.  It
 attempts to find the structure written by ownerKey.  If no owner is found and there are
 still open locations, the lowest numbered location is selected.  If there are no
 available locations, the last-written is selected.

 Once a spot is found, the most-recent data is re-written over this location.  The location
 is then, finally, returned.
 */
NSInteger SUUIDStorageLocationForOwnerKey(NSData *ownerKey, NSMutableDictionary** ownerDictionary) {
    NSInteger     ownerIndex;
    NSInteger     lowestUnusedIndex;
    NSInteger     oldestUsedIndex;
    NSDate*       mostRecentDate;
    NSDate*       oldestUsedDate;
    NSDictionary* mostRecentDictionary;
    BOOL          optedOut;

    ownerIndex           = -1;
    lowestUnusedIndex    = -1;
    oldestUsedIndex      = 0;  // make sure this value is always in range
    mostRecentDate       = [NSDate distantPast];
    oldestUsedDate       = [NSDate distantFuture];
    mostRecentDictionary = nil;
    optedOut             = NO;

    // The array of SecureUDID pasteboards can be sparse, since any number of
    // apps may have been deleted. To find a pasteboard owned by the the current
    // domain, iterate all of them.
    for (NSInteger i = 0; i < SUUID_MAX_STORAGE_LOCATIONS; ++i) {
        NSDate*       modifiedDate;
        NSDictionary* dictionary;

        dictionary = SUUIDDictionaryForStorageLocation(i);
        if (!dictionary) {
            if (lowestUnusedIndex == -1) {
                lowestUnusedIndex = i;
            }

            continue;
        }

        // Check the 'modified' timestamp of this pasteboard
        modifiedDate = [dictionary valueForKey:SUUIDTimeStampKey];
        optedOut     = optedOut || [[dictionary valueForKey:SUUIDOptOutKey] boolValue];

        // Hold a copy of the data if this is the newest we've found so far.
        if ([modifiedDate compare:mostRecentDate] == NSOrderedDescending) {
            mostRecentDate       = modifiedDate;
            mostRecentDictionary = dictionary;
        }

        // Check for the oldest entry in the structure, used for eviction
        if ([modifiedDate compare:oldestUsedDate] == NSOrderedAscending) {
            oldestUsedDate  = modifiedDate;
            oldestUsedIndex = i;
        }

        // Finally, check if this is the pasteboard owned by the requesting domain.
        if ([[dictionary objectForKey:SUUIDOwnerKey] isEqual:ownerKey]) {
            ownerIndex = i;
        }
    }

    // If no pasteboard is owned by this domain, establish a new one to increase the
    // likelihood of permanence.
    if (ownerIndex == -1) {
        // Unless there are no available slots, then evict the oldest entry
        if ((lowestUnusedIndex < 0) || (lowestUnusedIndex >= SUUID_MAX_STORAGE_LOCATIONS)) {
            ownerIndex = oldestUsedIndex;
        } else {
            ownerIndex = lowestUnusedIndex;
        }
    }

    // pass back the dictionary, by reference
    *ownerDictionary = [NSMutableDictionary dictionaryWithDictionary:mostRecentDictionary];

    // make sure our Opt-Out flag is consistent
    if (optedOut) {
        [*ownerDictionary setObject:[NSNumber numberWithBool:YES] forKey:SUUIDOptOutKey];
    }

    // Make sure to write the most recent structure to the new location
    SUUIDWriteDictionaryToStorageLocation(ownerIndex, mostRecentDictionary);

    return ownerIndex;
}

/*
 Attempts to validate the full SecureUDID structure.
 */
BOOL SUUIDValidTopLevelObject(id object) {
    if (![object isKindOfClass:[NSDictionary class]]) {
        return NO;
    }

    // Now, we need to verify the current schema.  There are a few possible valid states:
    // - SUUIDTimeStampKey + SUUIDOwnerKey + at least one additional key that is not SUUIDOptOutKey
    // - SUUIDTimeStampKey + SUUIDOwnerKey + SUUIDOptOutKey

    if ([object objectForKey:SUUIDTimeStampKey] && [object objectForKey:SUUIDOwnerKey]) {
        NSMutableDictionary* ownersOnlyDictionary;
        NSData*              ownerField;

        if ([object objectForKey:SUUIDOptOutKey]) {
            return YES;
        }

        // We have to trust future schema versions.  Note that the lack of a schema version key will
        // always fail this check, since the first schema version was 1.
        if ([[object objectForKey:SUUIDSchemaVersionKey] intValue] > SUUID_SCHEMA_VERSION) {
            return YES;
        }

        ownerField = [object objectForKey:SUUIDOwnerKey];
        if (![ownerField isKindOfClass:[NSData class]]) {
            return NO;
        }

        ownersOnlyDictionary = [NSMutableDictionary dictionaryWithDictionary:object];

        [ownersOnlyDictionary removeObjectForKey:SUUIDTimeStampKey];
        [ownersOnlyDictionary removeObjectForKey:SUUIDOwnerKey];
        [ownersOnlyDictionary removeObjectForKey:SUUIDOptOutKey];
        [ownersOnlyDictionary removeObjectForKey:SUUIDModelHashKey];
        [ownersOnlyDictionary removeObjectForKey:SUUIDSchemaVersionKey];

        // now, iterate through to verify each internal structure
        for (id key in [ownersOnlyDictionary allKeys]) {
            if ([key isEqual:SUUIDTimeStampKey] || [key isEqual:SUUIDOwnerKey] || [key isEqual:SUUIDOptOutKey])
                continue;

            if (![key isKindOfClass:[NSData class]]) {
                return NO;
            }

            if (!SUUIDValidOwnerObject([ownersOnlyDictionary objectForKey:key])) {
                return NO;
            }
        }

        // if all these tests pass, this structure is valid
        return YES;
    }

    // Maybe just the SUUIDOptOutKey, on its own
    if ([[object objectForKey:SUUIDOptOutKey] boolValue] == YES) {
        return YES;
    }

    return NO;
}

/*
 Attempts to validate the structure for an "owner dictionary".
 */
BOOL SUUIDValidOwnerObject(id object) {
    if (![object isKindOfClass:[NSDictionary class]]) {
        return NO;
    }

    return [object valueForKey:SUUIDLastAccessedKey] && [object valueForKey:SUUIDIdentifierKey];
}

@end
