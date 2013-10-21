//
//  WBRequest.m
//  SinaWeiBoSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//

#import "WBRequest.h"
#import "WBUtil.h"
#import "JSON.h"

#import "WBSDKGlobal.h"

#define kWBRequestTimeOutInterval   180.0
#define kWBRequestStringBoundary    @"293iosfksdfkiowjksdf31jsiuwq003s02dsaffafass3qw"

@interface WBRequest (Private)

+ (NSString *)stringFromDictionary:(NSDictionary *)dict;
+ (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString;
- (NSMutableData *)postBody;

- (void)handleResponseData:(NSData *)data;
- (id)parseJSONData:(NSData *)data error:(NSError **)error;

- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;
- (void)failedWithError:(NSError *)error;
@end


@implementation WBRequest

@synthesize url;
@synthesize httpMethod;
@synthesize params;
@synthesize postDataType;
@synthesize httpHeaderFields;
@synthesize delegate;


#pragma mark - WBRequest Life Circle

- (void)dealloc
{
    [url release], url = nil;
    [httpMethod release], httpMethod = nil;
    [params release], params = nil;
    [httpHeaderFields release], httpHeaderFields = nil;
    
    [responseData release];
	responseData = nil;
    
    [connection cancel];
    [connection release], connection = nil;
    
    [super dealloc];
}

#pragma mark - WBRequest Private Methods

+ (NSString *)stringFromDictionary:(NSDictionary *)dict
{
    NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in [dict keyEnumerator])
	{
		if (!([[dict valueForKey:key] isKindOfClass:[NSString class]]))
		{
			continue;
		}
		
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [[dict objectForKey:key] URLEncodedString]]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

+ (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString
{
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSMutableData *)postBody
{
    NSMutableData *body = [NSMutableData data];
    
    if (postDataType == kWBRequestPostDataTypeNormal)
    {
        [WBRequest appendUTF8Body:body dataString:[WBRequest stringFromDictionary:params]];
    }
    else if (postDataType == kWBRequestPostDataTypeMultipart)
    {
        NSString *bodyPrefixString = [NSString stringWithFormat:@"--%@\r\n", kWBRequestStringBoundary];
		NSString *bodySuffixString = [NSString stringWithFormat:@"\r\n--%@--\r\n", kWBRequestStringBoundary];
        
        NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
        
        [WBRequest appendUTF8Body:body dataString:bodyPrefixString];
        
        for (id key in [params keyEnumerator]) 
		{
			if (([[params valueForKey:key] isKindOfClass:[UIImage class]]) || ([[params valueForKey:key] isKindOfClass:[NSData class]]))
			{
				[dataDictionary setObject:[params valueForKey:key] forKey:key];
				continue;
			}
			
			[WBRequest appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", key, [params valueForKey:key]]];
			[WBRequest appendUTF8Body:body dataString:bodyPrefixString];
		}
		
		if ([dataDictionary count] > 0) 
		{
			for (id key in dataDictionary) 
			{
				NSObject *dataParam = [dataDictionary valueForKey:key];
				
				if ([dataParam isKindOfClass:[UIImage class]]) 
				{
					NSData* imageData = UIImagePNGRepresentation((UIImage *)dataParam);
					[WBRequest appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.png\"\r\n", key]];
					[WBRequest appendUTF8Body:body dataString:[NSString stringWithString:@"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n"]];
					[body appendData:imageData];
				} 
				else if ([dataParam isKindOfClass:[NSData class]]) 
				{
					[WBRequest appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key]];
					[WBRequest appendUTF8Body:body dataString:[NSString stringWithString:@"Content-Type: content/unknown\r\nContent-Transfer-Encoding: binary\r\n\r\n"]];
					[body appendData:(NSData*)dataParam];
				}
				[WBRequest appendUTF8Body:body dataString:bodySuffixString];
			}
		}
    }
    
    return body;
}

- (void)handleResponseData:(NSData *)data 
{
    if ([delegate respondsToSelector:@selector(request:didReceiveRawData:)])
    {
        [delegate request:self didReceiveRawData:data];
    }
	
	NSError* error = nil;
	id result = [self parseJSONData:data error:&error];
	
	if (error) 
	{
		[self failedWithError:error];
	} 
	else 
	{
        if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)])
		{
            [delegate request:self didFinishLoadingWithResult:(result == nil ? data : result)];
		}
	}
}

- (id)parseJSONData:(NSData *)data error:(NSError **)error
{
	
	NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return dataString;//liulei10@, for js
    
	SBJSON *jsonParser = [[SBJSON alloc]init];
	
	NSError *parseError = nil;
	id result = [jsonParser objectWithString:dataString error:&parseError];
	
	if (parseError)
    {
        if (error != nil)
        {
            *error = [self errorWithCode:kWBErrorCodeSDK
                                userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", kWBSDKErrorCodeParseError]
                                                                     forKey:kWBSDKErrorCodeKey]];
        }
	}
        
	[dataString release];
	[jsonParser release];
	
    
	if ([result isKindOfClass:[NSDictionary class]])
	{
		if ([result objectForKey:@"error_code"] != nil && [[result objectForKey:@"error_code"] intValue] != 200)
		{
			if (error != nil) 
			{
				*error = [self errorWithCode:kWBErrorCodeInterface userInfo:result];
			}
		}
	}
	
	return result;
}

- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:kWBSDKErrorDomain code:code userInfo:userInfo];
}

- (void)failedWithError:(NSError *)error 
{
	if ([delegate respondsToSelector:@selector(request:didFailWithError:)]) 
	{
		[delegate request:self didFailWithError:error];
	}
}

#pragma mark - WBRequest Public Methods

+ (WBRequest *)requestWithURL:(NSString *)url 
                   httpMethod:(NSString *)httpMethod 
                       params:(NSDictionary *)params
                 postDataType:(WBRequestPostDataType)postDataType
             httpHeaderFields:(NSDictionary *)httpHeaderFields
                     delegate:(id<WBRequestDelegate>)delegate
{
    WBRequest *request = [[[WBRequest alloc] init] autorelease];
    
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.postDataType = postDataType;
    request.httpHeaderFields = httpHeaderFields;
    request.delegate = delegate;
    
    return request;
}

+ (WBRequest *)requestWithAccessToken:(NSString *)accessToken
                                  url:(NSString *)url
                           httpMethod:(NSString *)httpMethod 
                               params:(NSDictionary *)params
                         postDataType:(WBRequestPostDataType)postDataType
                     httpHeaderFields:(NSDictionary *)httpHeaderFields
                             delegate:(id<WBRequestDelegate>)delegate
{
    // add the access token field
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [mutableParams setObject:accessToken forKey:@"access_token"];
    return [WBRequest requestWithURL:url
                          httpMethod:httpMethod
                              params:mutableParams
                        postDataType:postDataType 
                    httpHeaderFields:httpHeaderFields
                            delegate:delegate];
}

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    if (![httpMethod isEqualToString:@"GET"])
    {
        return baseURL;
    }
    
    NSURL *parsedURL = [NSURL URLWithString:baseURL];
	NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString *query = [WBRequest stringFromDictionary:params];
	
	return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

- (void)connect
{
    NSString *urlString = [WBRequest serializeURL:url params:params httpMethod:httpMethod];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
													   timeoutInterval:kWBRequestTimeOutInterval];
    
    [request setHTTPMethod:httpMethod];
    
    if ([httpMethod isEqualToString:@"POST"])
    {
        if (postDataType == kWBRequestPostDataTypeMultipart)
        {
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kWBRequestStringBoundary];
            [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        }
        
        [request setHTTPBody:[self postBody]];
    }
    
    for (NSString *key in [httpHeaderFields keyEnumerator])
    {
        [request setValue:[httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
    }
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)disconnect
{
    [responseData release];
	responseData = nil;
    
    [connection cancel];
    [connection release], connection = nil;
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	responseData = [[NSMutableData alloc] init];
	
	if ([delegate respondsToSelector:@selector(request:didReceiveResponse:)])
    {
		[delegate request:self didReceiveResponse:response];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse*)cachedResponse 
{
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
	[self handleResponseData:responseData];
    
	[responseData release];
	responseData = nil;
    
    [connection cancel];
	[connection release];
	connection = nil;
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
	[self failedWithError:error];
	
	[responseData release];
	responseData = nil;
    
    [connection cancel];
	[connection release];
	connection = nil;
}

@end
