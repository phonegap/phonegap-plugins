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


#import <Foundation/Foundation.h>


@interface DownloadTask : NSObject {
    NSString *path;
    NSURLConnection *conn;
    NSString *taskId;
    long long int size;
    long long int progress;
    float timeout;
    int temp;
    
    id downloader;
}

@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSURLConnection *conn;
@property (nonatomic, retain) NSString *taskId;
@property (nonatomic, retain) id downloader;

-(void) downloadFileWithOptions: (NSMutableDictionary *) options;
-(void) setDownloaderDelegate: (id) downloader;

+(void) deleteFileWithPath: (NSString *) path;
+(void) writeToFile: (NSData *)data withPath: (NSString *) path;

@end
