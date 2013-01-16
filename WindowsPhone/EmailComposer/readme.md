## Installation

- Add the EmailComposer.cs to your Plugins folder in project

- Place the EmailComposer.js file somewhere in your www folder, and include it from your html.

## Usage

You can call plugin like this:

	EmailComposer.show(to, subject, body, errback)

or

	window.plugins.emailComposer.showEmailComposer(subject,body,toRecipients,ccRecipients,bccRecipients,isHtml,attachments);

Callback and errback parameters can be null.