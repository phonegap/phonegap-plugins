/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 * 
 * Copyright (c) 2005-2010, Nitobi Software Inc.
 */


#import "Image.h"

@implementation PGImage

@synthesize window;
@synthesize picker;

// TODO Move to Image.m
- (void)imagePickerController:(UIImagePickerController *)thePicker didFinishPickingImage:(UIImage *)theImage editingInfo:(NSDictionary *)editingInfo
{
	
	//modified by urbian.org - g.mueller @urbian.org
	
    NSLog(@"photo: picked image");
	
	NSData * imageData = UIImageJPEGRepresentation(theImage, 0.75);
	
	NSString *urlString = [@"http://" stringByAppendingString:photoUploadUrl]; // upload the photo to this url
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	// ---------
	//Add the header info
	NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	//create the body
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//add data field and file data
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"photo_0\"; filename=\"photo\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[NSData dataWithData:imageData]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// ---------
	[request setHTTPBody:postBody];
	
	//NSURLConnection *
	conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if(conn) {    
		receivedData=[[NSMutableData data] retain];
		NSString *sourceSt = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
		NSLog(@"%@", [@"photo: connection sucess" stringByAppendingString:sourceSt]);
		[sourceSt release];
		
	} else {
		NSLog(@"photo: upload failed!");
	}
	
	[[thePicker parentViewController] dismissModalViewControllerAnimated:YES];
	
	self.webView.hidden = NO;
	[window bringSubviewToFront:self.webView];
	
}


// TODO Move to Image.m
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)thePicker
{
	// Dismiss the image selection and close the program
	[[thePicker parentViewController] dismissModalViewControllerAnimated:YES];
	
	//added by urbian - the webapp should know when the user canceled
	NSString * jsCallBack = nil;
	
	jsCallBack = [[NSString alloc] initWithFormat:@"gotPhoto('CANCEL');", lastUploadedPhoto];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];  
	[jsCallBack release];
	
	// Hide the imagePicker and bring the web page back into focus
	NSLog(@"Photo Cancel Request");
	self.webView.hidden = NO;
	[window bringSubviewToFront:self.webView];
}



// TODO Move to Image.m
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSLog(@"photo: upload finished!");
	
	//added by urbian.org - g.mueller
	NSString *aStr = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	
	//upload.php should return "filename=<filename>"
	NSLog(@"%@", aStr);
	NSArray * parts = [aStr componentsSeparatedByString:@"="];
	//set filename
	lastUploadedPhoto = (NSString *)[parts objectAtIndex:1];
	
	//now the callback: return lastUploadedPhoto
	
	NSString * jsCallBack = nil;
	
	if(lastUploadedPhoto == nil) lastUploadedPhoto = @"ERROR";
	
	jsCallBack = [[NSString alloc] initWithFormat:@"gotPhoto('%@');", lastUploadedPhoto];
	
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
	
	NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	NSLog(@"%@", jsCallBack);
	
    // release the connection, and the data object
    [conn release];
    [receivedData release];
	[jsCallBack release];
	[aStr release];
}


// TODO Move to Image.m
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response {
	
	//added by urbian.org
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	NSLog(@"HTTP Status Code: %i", [httpResponse statusCode]);
	
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [receivedData appendData:data];
    NSLog(@"photo: progress");
}


/*
 * Failed with Error
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", [@"photo: upload failed! " stringByAppendingString:[error description]]);
    
}



@end
