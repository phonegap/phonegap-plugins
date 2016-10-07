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


#import "Downloader.h"
#import "DownloadTask.h"

@implementation Downloader

-(void) downloadFile:(NSMutableArray*)paramArray withDict:(NSMutableDictionary*)options {
    NSLog(@"Creating a download task");
    DownloadTask *task = [[DownloadTask alloc] init];
    [task setDownloaderDelegate: self];
    [task downloadFileWithOptions:options];
    [task release];
}

@end
