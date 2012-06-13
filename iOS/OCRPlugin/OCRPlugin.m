//
//  OCRPlugin.m
//  pruebaTesseract
//
//  Created by Admin on 09/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OCRPlugin.h"
#import "claseAuxiliar.h"

@implementation OCRPlugin
@synthesize callbackID;





- (void) recogniseOCR:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options { //get the callback id 
    
    NSString *url_string = [options objectForKey:@"url_imagen"];
    self.callbackID = [arguments pop];

    claseAuxiliar *cA = [[claseAuxiliar alloc]init];
    
    NSURL *url = [NSURL URLWithString:url_string];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *Realimage = [[UIImage alloc] initWithData:data];
    
    UIImage *newImage = [cA resizeImage:Realimage];

    NSString *text = [cA ocrImage:newImage];
    [self performSelectorOnMainThread:@selector(ocrProcessingFinished:)
                           withObject:text
                        waitUntilDone:NO];
    

    [cA release];
    
}



- (void)ocrProcessingFinished:(NSString *)result
{


    
    
    // Create Plugin Result 
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString: result ];
    
    
    // Checking if the string received is HelloWorld or not
    
    if (result == nil
        || ([result respondsToSelector:@selector(length)]
            && [(NSData *)result length] == 0)
        || ([result respondsToSelector:@selector(count)]
            && [(NSArray *)result count] == 0))
        
    {
        // Call  the Failure Javascript function
        
        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
        
                
    } else
        
    {    
        
        // Call  the Success Javascript function
        
        [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];

        
    }
}

@end
