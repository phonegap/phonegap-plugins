//
//  FileUploader.h
//
//  Created by Matt Kane on 14/01/2011.
//  Copyright 2011 Matt Kane. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef CORDOVA_FRAMEWORK
#import <CORDOVA/CDVPlugin.h>
#else
#import "CORDOVA/CDVPlugin.h"
#endif

@interface FileUploader : CDVPlugin {

}
- (void) upload:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) uploadByUri:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) uploadFile:(NSURL*)file toServer:(NSString*)server withParams:(NSMutableDictionary*)params fileKey:(NSString*)fileKey fileName:(NSString*)fileName mimeType:(NSString*)mimeType successCallback:(NSString*)successCallback failCallback:(NSString*)failCallback progressCallback:(NSString*)progressCallback;
@end


@interface FileUploadDelegate : NSObject {
	NSString* successCallback;
	NSString* failCallback;
	NSString* progressCallback;
	FileUploader* command;
	int uploadIdx;
}

@property (nonatomic, copy) NSString* successCallback;
@property (nonatomic, copy) NSString* failCallback;
@property (nonatomic, copy) NSString* progressCallback;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) FileUploader* command;

@end;