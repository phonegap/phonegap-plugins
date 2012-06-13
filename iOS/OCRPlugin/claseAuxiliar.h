//
//  claseAuxiliar.h
//  pruebaTesseract
//
//  Created by Admin on 03/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



#ifdef __cplusplus
#include "baseapi.h"
using namespace tesseract;
#else
@class TessBaseAPI;
#endif


@interface claseAuxiliar : NSObject {
 
    
    TessBaseAPI *tesseract;

    
}


-(NSString *) ocrImage: (UIImage *) uiImage;
-(UIImage *)resizeImage:(UIImage *)image;




@end






