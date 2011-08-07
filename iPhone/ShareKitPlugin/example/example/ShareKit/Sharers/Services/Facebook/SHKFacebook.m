//
//  SHKFacebook.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/18/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "SHKFacebook.h"
#import "SHKFBStreamDialog.h"

@implementation SHKFacebook

@synthesize session;
@synthesize pendingFacebookAction;
@synthesize login;

- (void)dealloc
{
	[session.delegates removeObject:self];
	[session release];
	[login release];
	[super dealloc];
}


#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"Facebook";
}

+ (BOOL)canShareURL
{
	return YES;
}

+ (BOOL)canShareText
{
	return YES;
}

+ (BOOL)canShareImage
{
	return YES;
}

+ (BOOL)canShareOffline
{
	return NO; // TODO - would love to make this work
}

#pragma mark -
#pragma mark Configuration : Dynamic Enable

- (BOOL)shouldAutoShare
{
	return YES; // FBConnect presents its own dialog
}

#pragma mark -
#pragma mark Authentication

- (BOOL)isAuthorized
{	
	if (session == nil)
	{
		
		if(!SHKFacebookUseSessionProxy){
			self.session = [FBSession sessionForApplication:SHKFacebookKey
													 secret:SHKFacebookSecret
												   delegate:self];
			
		}else {
			self.session = [FBSession sessionForApplication:SHKFacebookKey
											getSessionProxy:SHKFacebookSessionProxyURL
												   delegate:self];
		}

		
		return [session resume];
	}
	
	return [session isConnected];
}

- (void)promptAuthorization
{
	self.pendingFacebookAction = SHKFacebookPendingLogin;
	self.login = [[[FBLoginDialog alloc] initWithSession:[self session]] autorelease];
	[login show];
}

- (void)authFinished:(SHKRequest *)request
{		
	
}

+ (void)logout
{
	FBSession *fbSession; 
	
	if(!SHKFacebookUseSessionProxy){
		fbSession = [FBSession sessionForApplication:SHKFacebookKey
												 secret:SHKFacebookSecret
											   delegate:self];
		
	}else {
		fbSession = [FBSession sessionForApplication:SHKFacebookKey
										getSessionProxy:SHKFacebookSessionProxyURL
											   delegate:self];
	}

	[fbSession logout];
}

#pragma mark -
#pragma mark Share API Methods

- (BOOL)send
{			
	if (item.shareType == SHKShareTypeURL)
	{
		self.pendingFacebookAction = SHKFacebookPendingStatus;
		
		SHKFBStreamDialog* dialog = [[[SHKFBStreamDialog alloc] init] autorelease];
		dialog.delegate = self;
		dialog.userMessagePrompt = SHKLocalizedString(@"Enter your message:");
		dialog.attachment = [NSString stringWithFormat:
							 @"{\
							 \"name\":\"%@\",\
							 \"href\":\"%@\"\
							 }",
							 item.title == nil ? SHKEncodeURL(item.URL) : SHKEncode(item.title),
							 SHKEncodeURL(item.URL)
							 ];
		dialog.defaultStatus = item.text;
		dialog.actionLinks = [NSString stringWithFormat:@"[{\"text\":\"Get %@\",\"href\":\"%@\"}]",
							  SHKEncode(SHKMyAppName),
							  SHKEncode(SHKMyAppURL)];
		[dialog show];
		
	}
	
	else if (item.shareType == SHKShareTypeText)
	{
		self.pendingFacebookAction = SHKFacebookPendingStatus;
		
		SHKFBStreamDialog* dialog = [[[SHKFBStreamDialog alloc] init] autorelease];
		dialog.delegate = self;
		dialog.userMessagePrompt = @"Enter your message:";
		dialog.defaultStatus = item.text;
		dialog.actionLinks = [NSString stringWithFormat:@"[{\"text\":\"Get %@\",\"href\":\"%@\"}]",
							  SHKEncode(SHKMyAppName),
							  SHKEncode(SHKMyAppURL)];
		[dialog show];
		
	}
	
	else if (item.shareType == SHKShareTypeImage)
	{		
		self.pendingFacebookAction = SHKFacebookPendingImage;
		
		FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease];
		dialog.delegate = self;
		dialog.permission = @"photo_upload";
		[dialog show];		
	}
	
	return YES;
}

- (void)sendImage
{
	[self sendDidStart];

	[[FBRequest requestWithDelegate:self] call:@"facebook.photos.upload"
	params:[NSDictionary dictionaryWithObjectsAndKeys:item.title, @"caption", nil]
	dataParam:UIImageJPEGRepresentation(item.image,1.0)];
}

- (void)dialogDidSucceed:(FBDialog*)dialog
{
	if (pendingFacebookAction == SHKFacebookPendingImage)
		[self sendImage];
	
	// TODO - the dialog has a SKIP button.  Skipping still calls this even though it doesn't appear to post.
	//		- need to intercept the skip and handle it as a cancel?
	else if (pendingFacebookAction == SHKFacebookPendingStatus)
		[self sendDidFinish];
}

- (void)dialogDidCancel:(FBDialog*)dialog
{
	if (pendingFacebookAction == SHKFacebookPendingStatus)
		[self sendDidCancel];
}

- (BOOL)dialog:(FBDialog*)dialog shouldOpenURLInExternalBrowser:(NSURL*)url
{
	return YES;
}


#pragma mark FBSessionDelegate methods

- (void)session:(FBSession*)session didLogin:(FBUID)uid 
{
	// Try to share again
	if (pendingFacebookAction == SHKFacebookPendingLogin)
	{
		self.pendingFacebookAction = SHKFacebookPendingNone;
		[self share];
	}
}

- (void)session:(FBSession*)session willLogout:(FBUID)uid 
{
	// Not handling this
}


#pragma mark FBRequestDelegate methods

- (void)request:(FBRequest*)aRequest didLoad:(id)result 
{
	if ([aRequest.method isEqualToString:@"facebook.photos.upload"]) 
	{
		// PID is in [result objectForKey:@"pid"];
		[self sendDidFinish];
	}
}

- (void)request:(FBRequest*)aRequest didFailWithError:(NSError*)error 
{
	[self sendDidFailWithError:error];
}



@end
