# Mail Composer

A Cordova plugin to launch mail client with attachment.  
Compatible with Cordova >= 2.5.0

### Hosted at

https://github.com/sbahal/mail-composer

### Steps to install

1. Install [cordova-plugman](https://github.com/apache/cordova-plugman).
2. ```cd``` into your project directory.
3. Execute the following command:

```
plugman --platform ios --project . --plugin https://github.com/sbahal/mail-composer.git
```

### Steps to uninstall

```
plugman --uninstall --platform ios --project . --plugin org.cordova.plugins.MailComposer
```

### Usage

```
mailComposer.sendMail([url, fileName]);
```
where,  
```url```: the URL of the file to be attached  
```fileName```: the name of the file to be attached. The same name would be used as the subject of the mail as well.

### Example

```
mailComposer.sendMail(['/www/docs/doc1.pdf', 'Foo Document']);
```