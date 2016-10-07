/*
 * Copyright (C) 2011 Davide Bertola
 *
 * Authors:
 * Davide Bertola <dade@dadeb.it>
 * Joe Noon <joenoon@gmail.com>
 *
 * This library is available under the terms of the MIT License (2008). 
 * See http://opensource.org/licenses/alphabetical for full text.
 */


#import "DownloadTask.h"

@implementation DownloadTask

@synthesize path;
@synthesize conn;
@synthesize taskId;
@synthesize downloader;


-(void) sendCallbackWithError:(NSString *)err 
                 withProgress:(NSString *)_progress 
                   withFinish:(NSString *)finish {
    NSString* jsString = [NSString /* I hate how XCode indents.. can't fit in 80 cols */
                          stringWithFormat:@"navigator.downloader.handleCallback ('%@', '%@', '%@', %@);", 
                          taskId, err, _progress, finish];
    
    [self.downloader writeJavascript:jsString];
}


-(void) downloadFileWithOptions: (NSMutableDictionary *) options {
    self.path = [options objectForKey:@"path"];
    self.taskId = [options objectForKey:@"taskId"];
    NSString *timeoutString = [options objectForKey:@"timeout"];
    NSString *sourceUrl = [options objectForKey:@"url"];
    
    temp = 0;
    
    if (timeoutString) {
        timeout = [timeoutString floatValue];
    } else {
        timeout = 10.0;
    }
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:sourceUrl]
                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:timeout];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    self.conn = connection;
}


-(void) setDownloaderDelegate: (id) ref {
    self.downloader = ref;
}


- (void)connection: (NSURLConnection*) connection 
didReceiveResponse: (NSHTTPURLResponse*) response
{
    int statusCode = [response statusCode];
    if (statusCode == 200) {
        //NSLog (@"response %d", statusCode);
        [DownloadTask deleteFileWithPath:self.path];
        size = [response expectedContentLength];
        return;
    }
    NSString *error = [NSString stringWithFormat:@"HTTP error %d", statusCode];
    [self sendCallbackWithError:error withProgress:@"false" withFinish:@"false"];
}


-(void) connectionDidFinishLoading: (NSURLConnection *) conn {
    //NSLog(@"completed");
    [self sendCallbackWithError:@"false" withProgress:@"false" withFinish:@"true"];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    int i = 0;
    float percent = 0;
    if ([data length] == 0) {
        return;
    }
    progress += [data length];
    percent = progress / (size * 1.0);
    i = percent * 100;
    
    [DownloadTask writeToFile:data withPath: self.path];
    
    if (i != temp && size != 0) {
        //NSLog (@"writing %f", percent);
        NSString *stringProgress = [NSString stringWithFormat:@"%f", percent];
        [self sendCallbackWithError:@"false" withProgress:stringProgress withFinish:@"false"];
    }
    temp = i;
}


-(void)connection: (NSURLConnection *)conn  didFailWithError: (NSError *) err {
    /* TODO: Better parse the error string to be returned */
    [self sendCallbackWithError:[err localizedDescription] withProgress:@"false" withFinish:@"false"];
}

/* file operations */

+(void) deleteFileWithPath: (NSString *) path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:Nil];
}


+(void) writeToFile: (NSData *)data withPath: (NSString *) path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        [data writeToFile:path atomically:YES];
    } else {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData: data];
        [fileHandle closeFile];        
    }
}


-(void) dealloc {
    [self.conn release];
    [self.path release];
    [self.taskId release];
    [self.downloader release];
    
    [super dealloc];
}

@end
