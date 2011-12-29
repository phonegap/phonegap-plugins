//
//  PixFileDownload.h
//  FileDownLoadApp
//
//  Created by Aaron saunders on 9/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>

@interface PixFileDownload : PGPlugin {
	NSMutableArray* params;
}

-(void) downloadFile:(NSMutableArray*)paramArray withDict:(NSMutableDictionary*)options;
-(void) downloadComplete:(NSString *)filePath;
-(void) downloadCompleteWithError:(NSString *)errorStr; 
-(void) downloadFileFromUrlInBackgroundTask:(NSMutableArray*)paramArray;
-(void) downloadFileFromUrl:(NSMutableArray*)paramArray;
@end
