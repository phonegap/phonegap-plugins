/* Copyright (c) 2011 - Zitec COM
 * 
 * @author: Ionut Voda <ionut.voda@zitec.ro>
 */
 
(1)The current plugin will help you produce UTF-8 compatible HMAC hashes(http://en.wikipedia.org/wiki/HMAC). It currently supports 2 hasher functions: sha1 which produces a HMAC-SHA1 hash and md5 whic generates a HMAC-MD5.

(2)How to use it:
// to generated a HMAC-SHA1 hash
window.plugins.hmac.sha1(
    "string you want to hash", 
    "key to hash with",
    function hashResult(jsonHash) {
        //the param has a single property called "hash" that contains your hash
        alert(jsonHash.hash)
    }
);

// or the MD5 version
window.plugins.hmac.md5(
    "string you want to hash", 
    "key to hash with",
    function hashResult(jsonHash) {
        alert(jsonHash.hash)
    }
);