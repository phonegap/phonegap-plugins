//
//  SHKGoogleReader.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/20/10.

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


/*
 
Google Reader API is unoffical, this was hobbled together from:
 http://code.google.com/p/pyrfeed/wiki/GoogleReaderAPI
 http://stackoverflow.com/questions/1041389/adding-notes-using-google-readers-api
 http://www.google.com/support/reader/bin/answer.py?hl=en&answer=147149 
*/


#import "SHKGoogleReader.h"


@implementation SHKGoogleReader

@synthesize session;
@synthesize sendAfterLogin;


- (void)dealloc
{
	[session release];
	[super dealloc];
}



#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"Google Reader";
}

+ (BOOL)canShareURL
{
	return YES;
}



#pragma mark -
#pragma mark Authorization

+ (NSString *)authorizationFormCaption
{
	return SHKLocalizedString(@"Create a free account at %@", @"Google.com/reader");
}

+ (NSArray *)authorizationFormFields
{
	return [NSArray arrayWithObjects:
			[SHKFormFieldSettings label:SHKLocalizedString(@"Email") key:@"email" type:SHKFormFieldTypeText start:nil],
			[SHKFormFieldSettings label:SHKLocalizedString(@"Password") key:@"password" type:SHKFormFieldTypePassword start:nil],			
			nil];
}

- (void)authorizationFormValidate:(SHKFormController *)form
{
	// Display an activity indicator
	if (!quiet)
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Logging In...")];
	
	
	// Authorize the user through the server
	NSDictionary *formValues = [form formValues];
	
	[self getSession:[formValues objectForKey:@"email"]
			password:[formValues objectForKey:@"password"]];
	
	self.pendingForm = form;
}

- (void)getSession:(NSString *)email password:(NSString *)password
{
	NSString *params = [NSMutableString stringWithFormat:@"service=reader&source=%@&Email=%@&Passwd=%@&accountType=GOOGLE",
						[NSString stringWithFormat:@"ShareKit-%@-%@", SHKEncode(SHKMyAppName), SHK_VERSION],
						SHKEncode(email),
						SHKEncode(password)
						];
	
	self.request = [[[SHKRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.google.com/accounts/ClientLogin"]
											params:params
										  delegate:self
								isFinishedSelector:@selector(authFinished:)
											method:@"POST"
										 autostart:YES] autorelease];
}

- (void)authFinished:(SHKRequest *)aRequest
{		
	// TODO - better error handling - use error codes from ( http://code.google.com/apis/accounts/docs/AuthForInstalledApps.html )
	// TODO - capatcha support
	
	// Hide the activity indicator
	if (!sendAfterLogin)
		[[SHKActivityIndicator currentIndicator] hide];
	
	// Parse Result
	self.session = [NSMutableDictionary dictionaryWithCapacity:0];
	NSString *result = [request getResult];
	NSArray *parts;
	
	if (result != nil)
	{
		NSArray *lines = [result componentsSeparatedByString:@"\n"];
		for( NSString *line in lines)
		{
			parts = [line componentsSeparatedByString:@"="];
			if (parts.count == 2)
				[session setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
		}
	}
	
	if (session != nil && [session objectForKey:@"Auth"])
	{
		if (sendAfterLogin)
			[self tryToSend];
		
		else
			[pendingForm saveForm];
	}
	
	else
	{		
		NSString *error = [session objectForKey:@"Error"];
		NSString *message = nil;
		
		if (error != nil)
			message = [error isEqualToString:@"BadAuthentication"] ? SHKLocalizedString(@"Incorrect username and password") : error;
		
		if (message == nil) // TODO - Could use some clearer message here.
			message = SHKLocalizedString(@"There was an error logging into Google Reader");			
		
		[[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Login Error")
									 message:message
									delegate:nil
						   cancelButtonTitle:SHKLocalizedString(@"Close")
						   otherButtonTitles:nil] autorelease] show];	
	}
}


#pragma mark -
#pragma mark Share Form

- (NSArray *)shareFormFieldsForType:(SHKShareType)type
{
	if (type == SHKShareTypeURL)
		return [NSArray arrayWithObjects:
				[SHKFormFieldSettings label:SHKLocalizedString(@"Note") key:@"text" type:SHKFormFieldTypeText start:item.text],
				[SHKFormFieldSettings label:SHKLocalizedString(@"Public") key:@"share" type:SHKFormFieldTypeSwitch start:SHKFormFieldSwitchOff],
				nil];
	
	return nil;
}


#pragma mark -
#pragma mark Share API Methods

- (void)signRequest:(SHKRequest *)aRequest
{	
	// Add session cookie
	NSDictionary *cookieDictionary;
	NSHTTPCookie *cookie;
	NSMutableArray *cookies = [NSMutableArray arrayWithCapacity:0];
	for (NSString *cookieName in session)
	{
			
		cookieDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
										  cookieName, NSHTTPCookieName,										  
										  [session objectForKey:cookieName], NSHTTPCookieValue,
										  @".google.com", NSHTTPCookieDomain,
										  @"/", NSHTTPCookiePath,
										  [NSDate dateWithTimeIntervalSinceNow:1600000000], NSHTTPCookieExpires,
										  nil];
		cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary];
		[cookies addObject:cookie];
	}
	NSMutableDictionary *headers = [[[NSHTTPCookie requestHeaderFieldsWithCookies:cookies] mutableCopy] autorelease];
	
	[headers setObject:[NSString stringWithFormat:@"GoogleLogin auth=%@",[session objectForKey:@"Auth"]] forKey:@"Authorization"];
	
	[aRequest setHeaderFields:headers];
}

- (BOOL)send
{	
	if ([self validateItem])
	{	
		BOOL sentAfterLogin = sendAfterLogin;
		
		if (session == nil)
		{
			// Login first
			self.sendAfterLogin = YES;
			[self getSession:[self getAuthValueForKey:@"email"]
					password:[self getAuthValueForKey:@"password"]];
		}
		
		else 
		{		
			
			self.sendAfterLogin = NO;
			
			self.request = [[[SHKRequest alloc] initWithURL:[NSURL URLWithString:
															 [NSString stringWithFormat:
															  @"http://www.google.com/reader/api/0/token?ck=%i",
															  [[NSDate date] timeIntervalSince1970]
															  ]]
																   params:nil
																 delegate:self
													   isFinishedSelector:@selector(tokenFinished:)
																   method:@"GET"
																autostart:NO] autorelease];
			[self signRequest:request];
			[request start];	
		}			
			
		// Notify delegate
		if (!sentAfterLogin)
			[self sendDidStart];
		
		return YES;
	}
	
	return NO;
}

- (void)tokenFinished:(SHKRequest *)aRequest
{	
	if (aRequest.success)
		[self sendWithToken:[request getResult]];
	
	else
		[self sendDidFailWithError:[SHK error:SHKLocalizedString(@"There was a problem authenticating your account.")]]; // TODO better error handling/message
}

- (void)sendWithToken:(NSString *)token
{		
	NSString *params = [NSMutableString stringWithFormat:@"T=%@&linkify=false&snippet=%@&srcTitle=%@&srcUrl=%@&title=%@&url=%@&share=%@",
						token,
						SHKEncode(item.text),
						SHKEncode(SHKMyAppName),
						SHKEncode(SHKMyAppURL),		
						SHKEncode(item.title),					
						SHKEncodeURL(item.URL),
						[item customBoolForSwitchKey:@"share"]?@"true":@""
						];
	
	self.request = [[[SHKRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.google.com/reader/api/0/item/edit"]
								 params:params
							   delegate:self
					 isFinishedSelector:@selector(sendFinished:)
								 method:@"POST"
							  autostart:NO] autorelease];
	
	[self signRequest:request];	
	[request start];
}

- (void)sendFinished:(SHKRequest *)aRequest
{			
	if (aRequest.success)
		[self sendDidFinish];
	
	else
		[self sendDidFailWithError:[SHK error:SHKLocalizedString(@"There was a problem saving your note.")]]; // TODO better error handling/message	
}


@end
