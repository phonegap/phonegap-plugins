//
//  FileUploader.m
//
//  Created by Matt Kane on 14/01/2011.
//  Copyright 2011 Matt Kane. All rights reserved.
//

#import "FileUploader.h"


@implementation FileUploader

- (void) upload:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options 
{
	NSUInteger argc = [arguments count];
	
	if(argc < 2) {
		return;	
	}
	
	NSString* successCallback = [arguments objectAtIndex:0];
	NSString* failCallback = [arguments objectAtIndex:1];
	
	if(argc < 6) {
		[self writeJavascript: [NSString stringWithFormat:@"%@(\"Argument error\");", failCallback]];
		return;
	}

	NSString* progressCallback = [arguments objectAtIndex:2];
	NSString* server = [arguments objectAtIndex:3];
	NSURL* file = [NSURL fileURLWithPath:[arguments objectAtIndex:4] isDirectory: NO];
	NSString* fileKey = nil;
	NSString* fileName = nil;
	NSString* mimeType = nil;
	
	if(argc > 5) {
		fileKey = [arguments objectAtIndex:5];	
	}
	
	if(argc > 6) {
		fileName = [arguments objectAtIndex:6];
	}
	
	if(argc > 7) {
		mimeType = [arguments objectAtIndex:7];
	}
	[self uploadFile:file toServer:server withParams:options fileKey:fileKey fileName:fileName mimeType:mimeType successCallback:successCallback failCallback:failCallback progressCallback:progressCallback];
}

- (void) uploadByUri:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options 
{
	NSUInteger argc = [arguments count];
	
	if(argc < 2) {
		return;	
	}
	
	NSString* successCallback = [arguments objectAtIndex:0];
	NSString* failCallback = [arguments objectAtIndex:1];
	
	if(argc < 6) {
		[self writeJavascript: [NSString stringWithFormat:@"%@(\"Argument error\");", failCallback]];
		return;
	}
	NSString* progressCallback = [arguments objectAtIndex:2];	
	NSString* server = [arguments objectAtIndex:3];
	NSURL* file = [NSURL URLWithString:[arguments objectAtIndex:4]];
	NSString* fileKey = nil;
	NSString* fileName = nil;
	NSString* mimeType = nil;
	
	if(argc > 5) {
		fileKey = [arguments objectAtIndex:5];	
	}
	
	if(argc > 6) {
		fileName = [arguments objectAtIndex:6];
	}
	
	if(argc > 7) {
		mimeType = [arguments objectAtIndex:7];
	}
	[self uploadFile:file toServer:server withParams:options fileKey:fileKey fileName:fileName mimeType:mimeType  successCallback:successCallback failCallback:failCallback progressCallback:progressCallback];
}

- (void) uploadFile:(NSURL*)file toServer:(NSString*)server withParams:(NSMutableDictionary*)params fileKey:(NSString*)fileKey fileName:(NSString*)fileName mimeType:(NSString*)mimeType successCallback:(NSString*)successCallback failCallback:(NSString*)failCallback progressCallback:(NSString*)progressCallback 
{	
	
	if (![file isFileURL]) {
		[self writeJavascript: [NSString stringWithFormat:@"%@(\"Is not a valid file\");", failCallback]];
		return;
	}
	
	if(!fileName) {
		fileName = @"image.jpg";	
	}
	
	if(!mimeType) {
		mimeType = @"image/jpeg";	
	}
	
	if(!fileKey) {
		fileKey = @"file";	
	}
	NSURL *url = [NSURL URLWithString:server];

	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	[req setHTTPMethod:@"POST"];
	
	if([params objectForKey:@"__cookie"]) {
		[req setValue:[params objectForKey:@"__cookie"] forHTTPHeaderField:@"Cookie"];
		[params removeObjectForKey:@"__cookie"];
		[req setHTTPShouldHandleCookies:NO];
	}
	
	NSString *boundary = @"*****com.beetight.formBoundary";

	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[req setValue:contentType forHTTPHeaderField:@"Content-type"];
	[req setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
	NSString* userAgent = [[self.webView request] valueForHTTPHeaderField:@"User-agent"];
	if(userAgent) {
		[req setValue: userAgent forHTTPHeaderField:@"User-agent"];
	}
	
	NSData *imageData = [NSData dataWithContentsOfURL:file];
	
	if(!imageData) {
		[self writeJavascript: [NSString stringWithFormat:@"%@(\"Could not open file\");", failCallback]];
		return;
	}
	
	NSMutableData *postBody = [NSMutableData data];
	
	NSEnumerator *enumerator = [params keyEnumerator];
	id key;
	id val;
	while ((key = [enumerator nextObject])) {
		val = [params objectForKey:key];
		if(!val || val == [NSNull null]) {
			continue;	
		}
		[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[val dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	}

	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fileKey, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:imageData];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[req setHTTPBody:postBody];
	
	FileUploadDelegate* delegate = [[FileUploadDelegate alloc] init];
	delegate.command = self;
	delegate.successCallback = successCallback;
	delegate.failCallback = failCallback;
	delegate.progressCallback = progressCallback;
	
	[[NSURLConnection connectionWithRequest:req delegate:delegate] retain];
}

@end


@implementation FileUploadDelegate

@synthesize successCallback, failCallback, progressCallback, responseData, command;

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite 
{
	if(!self.progressCallback) {
		return;	
	}
	if (uploadIdx++ % 10 == 0) { 
		[command writeJavascript: [NSString stringWithFormat:@"%@(%d, %d);", self.progressCallback, totalBytesWritten, totalBytesExpectedToWrite]];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	NSString* response = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	NSLog(@"reponse: %@", response);
	NSString* js = [NSString stringWithFormat:@"%@(\"%@\");", self.successCallback, [response stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[command writeJavascript: js];
	[connection autorelease];
	[self autorelease];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
	[command writeJavascript: [NSString stringWithFormat:@"%@(\"%@\");", self.failCallback, [[error localizedDescription] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[connection autorelease];
	[self autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (id) init
{
    if (self = [super init]) {
		self.responseData = [NSMutableData data];
		uploadIdx = 0;
    }
    return self;
}

- (void) dealloc
{
    [successCallback release];
    [failCallback release];
	[responseData release];
	[command release];
    [super dealloc];
}


@end;