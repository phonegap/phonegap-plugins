# BundleFileReader

Read files from your app bundle.

https://github.com/tf/phonegap-plugins

## Usage

```javascript
plugins.bundleFileReader.readResource(
  'someFile', 'txt', 'www/',
  function(contents) {
    console.log('Contents of www/someFile.txt: ' + contents);
  },
  function() {
    console.log('File is missing');
  }
);
```