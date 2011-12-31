# ShopGap plugin for Android/Phonegap

Chris Saunders // @csaunders

## About

ShopGap is a wrapper around [Shopify4J](http://github.com/shopify/Shopify4J) to allow you to make Authenticated API calls to the Shopify API.

## Dependencies

You will need to include Shopify4J and all of it's dependencies in your project in order for this tool to work.  This should be as simple as adding Shopify4J as a Library in your Android configuration.

## Using the plugin

**This has been developed against PhoneGap 1.1.0**

* Add java code to your projects source

* Register the plugin in the plugins.xml file

```xml
<plugin name="ShopGapPlugin" value="ca.christophersaunders.shopgap.ShopGapPlugin" />
```

* Setup your authenticated session with the Shopify API

```javascript
window.plugins.shopGap.setup(
  'YOUR_API_KEY',
  'GENERATED_API_PASSWORD',
  'SHOP_NAME',
  successFunctionOrNull,
  failureFunctionOrNull
);
```

* Make calls to the Shopify API

```javascript
var success = function(resultJson){
  console.log(JSON.stringify(resultJson));
}

window.plugins.shopGap.read(
  'products', // endpoint
  null, // query -- not supported yet
  null, // data -- not needed for GET requests
  function(r){success(r);}, // success callback
  function(e){console.log}); // failure callback
```

### Endpoints

The plugin takes care of most of the work for the endpoints, all you need to
do is fill in a few missing pieces.

```javascript
// get all products, 
window.plugins.shopGap.read('products', null, null, s, f);

// get product 1
window.plugins.shopGap.read('products/1', null, null, s, f);

// create product
window.plugins.shopGap.create('products', null, JSON.stringify(newProduct), s, f);

// update product 1
window.plugins.shopGap.update('products/1', null, JSON.stringify(updateProduct), s, f);

// delete product 1
window.plugins.shopGap.destry('products/1', null, null, s, f);
```

## Release Notes

0.1.0 Initial Release

## License

The MIT License

Copyright (c) 2011 Chris Saunders

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.