//
//  DataProxy.m
//  DataProxy plugin for PhoneGap
//
//  Created by Brian Antonelli on 7/7/11.
//

#import "DataProxy.h"
#import <objc/runtime.h>

@implementation DataProxy
@synthesize dataStreams, callbacks;

static char dataInstanceKey;

-(PhoneGapCommand*) initWithWebView:(UIWebView*) theWebView{
    self = (DataProxy*) [super initWithWebView:theWebView];
    
    return self;
}

-(void) getData: (NSMutableArray*) arguments withDict: (NSMutableDictionary*) options{
    if(dataStreams == nil){
        dataStreams = [[NSMutableDictionary alloc] init];
        callbacks = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[options objectForKey:@"url"]]
                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                   timeoutInterval:8.0];
    
    // The caller should set the UA
    [req setValue:[options objectForKey:@"ua"] forHTTPHeaderField:@"User-Agent"];
    
    // Create a UUID to associate with the request
    NSString *uuid = [self createUUID];
    
    // Create & store data keyed off of the UUID
    NSMutableDictionary *ds = [[NSMutableData alloc] initWithCapacity:2048];
    [dataStreams setObject:ds forKey:uuid];
    [ds release];
    
    // Store the callbacks keyed off of the UUID
    [callbacks setObject:[NSArray arrayWithObjects:[arguments objectAtIndex:0], [arguments objectAtIndex:1], nil] forKey:uuid];
    
    // Create a URL connection
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    // Add an associative reference to the connection to keep the key for the data
    objc_setAssociatedObject(conn, &dataInstanceKey, uuid, OBJC_ASSOCIATION_RETAIN);
    
    // Kick off the connection
    [conn scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [conn start];
    [conn release];
}


#pragma mark -
#pragma mark Private

-(NSString*) createUUID{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef str = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    
    return [(NSString*) str autorelease];
}

-(void) removeDataStream: (NSString*) uuid{
    NSMutableData *data = (NSMutableData*) [dataStreams objectForKey:uuid];
    if(data != nil){
        data = nil;
        [dataStreams removeObjectForKey:uuid];
    }
}


-(void) connection: (NSURLConnection *) theConnection didReceiveData: (NSData *) incrementalData{
    // Pull the key out of the connection (we add when the connection is instantiated)
    NSString *uuid = (NSString*) objc_getAssociatedObject(theConnection, &dataInstanceKey);
    
    // Add the data to the correct stream
    [[dataStreams objectForKey:uuid] appendData:incrementalData];
}

-(void) connectionDidFinishLoading: (NSURLConnection*) theConnection{
    // Pull the key out of the connection (we add when the connection is instantiated)
    NSString *uuid = (NSString*) objc_getAssociatedObject(theConnection, &dataInstanceKey);
    
    // Get the correct data
    NSMutableData *data = (NSMutableData*) [dataStreams objectForKey:uuid];
    
    // Convert the result into a string
    NSString *response = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSMutableString *cleanResp = [[NSMutableString alloc] initWithString:response];
    
    // Flatten into a single line
    [cleanResp replaceOccurrencesOfString:@" +|\n" 
                               withString:@" " 
                                  options:NSRegularExpressionSearch 
                                    range:NSMakeRange(0, [cleanResp length])];
    // Get the correct callback
    NSString *successCallback = [[callbacks objectForKey:uuid] objectAtIndex:0];
    
    // Make it JS function friendly and return it
    [self writeJavascript:[NSString stringWithFormat:@"%@('%@');", successCallback, [cleanResp stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"]]];
    [cleanResp release];
    [response release];
    
    // Remove the callbacks and data
    [callbacks removeObjectForKey:uuid];
    [self removeDataStream:uuid];
}

-(void) connection: (NSURLConnection*) connection didFailWithError: (NSError*) error{
    // Pull the key out of the connection (we add when the connection is instantiated)
    NSString *uuid = (NSString*) objc_getAssociatedObject(connection, &dataInstanceKey);
    
    // Get the correct callback
    NSString *failureCallback = [[callbacks objectForKey:uuid] objectAtIndex:1];
    
    // Return the error
    [self writeJavascript:[NSString stringWithFormat:@"%@('%@');", failureCallback, [error localizedDescription]]];
    
    // Remove the callbacks and data
    [self removeDataStream:uuid];
    [callbacks removeObjectForKey:uuid];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
    for(id data in dataStreams){
        if(data != nil){
            [data release], data = nil;
        }
    }    
    [dataStreams release], dataStreams = nil;
    [callbacks release], callbacks = nil;
    
    [super dealloc];
}

@end
