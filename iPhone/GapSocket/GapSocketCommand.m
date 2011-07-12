//

// 
//
//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//

#import "GapSocketCommand.h"



@implementation GapSocketCommand

-(id)initWithWebView:(UIWebView *)theWebView
{
	if((self = (GapSocketCommand*)[super initWithWebView:theWebView]))	
	{
		connectedSockets = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return self;
	
}

- (void) connect:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{	
	NSUInteger argc = [arguments count];
	if(argc > 2)
	{
		NSString* host = [arguments objectAtIndex:0];
		NSString* port = [arguments objectAtIndex:1];
		NSString* userData = [arguments objectAtIndex:2];
		
		AsyncSocket* socket = [[AsyncSocket alloc] initWithDelegate:self userData:[userData longLongValue]];
		
		NSError* err;
		BOOL succ = [ socket connectToHost:host onPort:[port intValue] error:&err];
		if(succ)
		{
			
		}
		else 
		{
			
			NSString* jsString = [[NSString alloc] initWithFormat:@"GapSocket.__onError(\"%@\");",[err localizedDescription] ];
			[self.webView stringByEvaluatingJavaScriptFromString:jsString];
			[jsString release];
		}
		
	}
	else 
	{
		// FATAL
		return; 
	}

}

- (void) close:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{	
	// TODO: add a forceDisconnect param, otherwise we continue any read/write ops that are in progress before the close
	NSUInteger argc = [arguments count];
	
	if(argc > 0)
	{
		NSString* userData = [arguments objectAtIndex:0];
		int socketCount = [connectedSockets count];
		for(int x = 0; x < socketCount; x++)
		{
			AsyncSocket* sock = (AsyncSocket*)[connectedSockets objectAtIndex:x];
			if([ sock userData] == [userData longLongValue])
			{
				[sock disconnectAfterReadingAndWriting];
				break;
			}
		}
	}
		
}

- (void) send:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	NSUInteger argc = [arguments count];
	
	if(argc > 0)
	{
		NSString* userData = [arguments objectAtIndex:0];
		
		if(argc > 1)
		{
			NSString* message = [arguments objectAtIndex:1];
			BOOL foundSocket = NO;
			int socketCount = [connectedSockets count];
			for(int x = 0; x < socketCount; x++)
			{
				AsyncSocket* sock = (AsyncSocket*)[connectedSockets objectAtIndex:x];
				if([ sock userData] == [userData longLongValue])
				{
					NSData *msgData = [message dataUsingEncoding:NSUTF8StringEncoding];
					
					[sock writeData:msgData withTimeout:-1 tag:0];
					
					[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
					foundSocket = YES;
					break;
				}
			}
		}
		else 
		{
			NSString* err = [NSString stringWithFormat:@"Error: Call to GapSocketCommand::send with missing message"];
			NSLog(@"%@",err);
			NSString* jsString = [[NSString alloc] initWithFormat:@"GapSocket.__onError(\"%d\",\"%@\");",userData,err ];
			[self.webView stringByEvaluatingJavaScriptFromString:jsString];
			[jsString release];
			[ err release ];
		}
	}
	else {
		NSLog(@"Call to GapSocketCommand::send with NO arguments!");
	}


		
}


/**
 * In the event of an error, the socket is closed.
 * You may call "unreadData" during this call-back to get the last bit of data off the socket.
 * When connecting, this delegate method may be called
 * before"onSocket:didAcceptNewSocket:" or "onSocket:didConnectToHost:".
 **/
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	NSString* jsString = [[NSString alloc] initWithFormat:@"GapSocket.__onError(\"%d\",\"%@\");"
						  ,[sock userData]
						  ,[err localizedDescription] ];
	[self.webView stringByEvaluatingJavaScriptFromString:jsString];
	[jsString release];
}

/**
 * Called when a socket disconnects with or without error.  If you want to release a socket after it disconnects,
 * do so here. It is not safe to do that during "onSocket:willDisconnectWithError:".
 * 
 * If you call the disconnect method, and the socket wasn't already disconnected,
 * this delegate method will be called before the disconnect method returns.
 **/
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	[connectedSockets removeObject:sock];
	NSString* jsString = [[NSString alloc] initWithFormat:@"GapSocket.__onClosed(\"%d\");",[sock userData] ];
	[self.webView stringByEvaluatingJavaScriptFromString:jsString];
	[jsString release];
}

/**
 * Called when a socket accepts a connection.  Another socket is spawned to handle it. The new socket will have
 * the same delegate and will call "onSocket:didConnectToHost:port:".
 **/
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	[connectedSockets addObject:newSocket];
}

/**
 * Called when a socket is about to connect. This method should return YES to continue, or NO to abort.
 * If aborted, will result in AsyncSocketCanceledError.
 * 
 * If the connectToHost:onPort:error: method was called, the delegate will be able to access and configure the
 * CFReadStream and CFWriteStream as desired prior to connection.
 *
 * If the connectToAddress:error: method was called, the delegate will be able to access and configure the
 * CFSocket and CFSocketNativeHandle (BSD socket) as desired prior to connection. You will be able to access and
 * configure the CFReadStream and CFWriteStream in the onSocket:didConnectToHost:port: method.
 **/
- (BOOL)onSocketWillConnect:(AsyncSocket *)sock
{
	return YES;
}

/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	// TODO: pass host and port back to js
	NSString* jsString = [[NSString alloc] initWithFormat:@"GapSocket.__onOpen(\"%d\");",[sock userData] ];
	[self.webView stringByEvaluatingJavaScriptFromString:jsString];
	[jsString release];
	
	[connectedSockets addObject:sock];
	[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
	NSString *msg = [[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] autorelease];
	if(msg)
	{
		NSString* jsString = [[NSString alloc] initWithFormat:@"GapSocket.__onMessage(\"%d\",\"%@\");",[sock userData] , msg ];
		[self.webView stringByEvaluatingJavaScriptFromString:jsString];
		[jsString release];
	}
	else
	{
		NSLog(@"Error converting received data into UTF-8 String");
		NSString* jsString = [[NSString alloc] initWithFormat:@"GapSocket.__onError(\"%d\",\"%@\");",[sock userData] , @"Error converting received data into UTF-8 String" ];
		[self.webView stringByEvaluatingJavaScriptFromString:jsString];
		[jsString release];
	}
}

/**
 * Called when a socket has read in data, but has not yet completed the read.
 * This would occur if using readToData: or readToLength: methods.
 * It may be used to for things such as updating progress bars.
 **/
- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(CFIndex)partialLength tag:(long)tag
{
	
}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	
}

/**
 * Called when a socket has written some data, but has not yet completed the entire write.
 * It may be used to for things such as updating progress bars.
 **/
- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(CFIndex)partialLength tag:(long)tag
{
	
}

/**
 * Called if a read operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the read's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the read will timeout as usual.
 * 
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been read so far for the read operation.
 * 
 * Note that this method may be called multiple times for a single read if you return positive numbers.
 **/
/*
- (NSTimeInterval)onSocket:(AsyncSocket *)sock
  shouldTimeoutReadWithTag:(long)tag
				   elapsed:(NSTimeInterval)elapsed
				 bytesDone:(CFIndex)length;
 */

/**
 * Called if a write operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the write's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the write will timeout as usual.
 * 
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been written so far for the write operation.
 * 
 * Note that this method may be called multiple times for a single write if you return positive numbers.
 **/
/*
- (NSTimeInterval)onSocket:(AsyncSocket *)sock
 shouldTimeoutWriteWithTag:(long)tag
				   elapsed:(NSTimeInterval)elapsed
				 bytesDone:(CFIndex)length;
 */

/**
 * Called after the socket has successfully completed SSL/TLS negotiation.
 * This method is not called unless you use the provided startTLS method.
 * 
 * If a SSL/TLS negotiation fails (invalid certificate, etc) then the socket will immediately close,
 * and the onSocket:willDisconnectWithError: delegate method will be called with the specific SSL error code.
 **/
- (void)onSocketDidSecure:(AsyncSocket *)sock
{
	
}




@end
