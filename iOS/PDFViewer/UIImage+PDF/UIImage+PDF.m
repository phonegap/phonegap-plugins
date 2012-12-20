//
//  UIImage+PDF.m
//
//  Created by Nigel Barber on 15/10/2011.
//  Copyright 2011 Mindbrix Limited. All rights reserved.
//

#import "UIImage+PDF.h"


@implementation  UIImage( PDF )


#pragma mark - Convenience methods

+(UIImage *) imageOrPDFNamed:(NSString *)resourceName
{
    if([[ resourceName pathExtension ] isEqualToString: @"pdf" ])
    {
        return [ UIImage originalSizeImageWithPDFNamed:resourceName ];
    }
    else
    {
        return [ UIImage imageNamed:resourceName ];
    }
}


+(UIImage *) imageOrPDFWithContentsOfFile:(NSString *)path
{
    if([[ path pathExtension ] isEqualToString: @"pdf" ])
    {
        return [ UIImage originalSizeImageWithPDFURL:[ NSURL fileURLWithPath:path ]];
    }
    else
    {
        return [ UIImage imageWithContentsOfFile:path ];
    }
}


#pragma mark - Cacheing

+(NSString *)cacheFilenameForURL:(NSURL *)resourceURL atSize:(CGSize)size atScaleFactor:(CGFloat)scaleFactor atPage:(int)page
{
    NSString *cacheFilename = nil;
    
#ifdef UIIMAGE_PDF_CACHEING
    
    NSFileManager *fileManager = [ NSFileManager defaultManager ];
    
    NSString *filePath = [ resourceURL path ];
    
    //NSLog( @"filePath: %@", filePath );
    
    NSDictionary *fileAttributes = [ fileManager attributesOfItemAtPath:filePath error:NULL ];
    
    //NSLog( @"fileAttributes: %@", fileAttributes );
    
    NSString *cacheRoot = [ NSString stringWithFormat:@"%@ - %@ - %@ - %@ - %d", [ filePath lastPathComponent ], [ fileAttributes objectForKey:NSFileSize ], [ fileAttributes objectForKey:NSFileModificationDate ], NSStringFromCGSize(CGSizeMake( size.width * scaleFactor, size.height * scaleFactor )), page ];
    
    //NSLog( @"cacheRoot: %@", cacheRoot );
    
    NSString *MD5 = [ cacheRoot MD5 ];
    
    //NSLog( @"MD5: %@", MD5 );
    
    NSString *cachesDirectory = [ NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES ) objectAtIndex:0 ];
    
    NSString *cacheDirectory = [ NSString stringWithFormat:@"%@/__PDF_CACHE__", cachesDirectory ];
    
    //NSLog( @"cacheDirectory: %@", cacheDirectory );
    
    [ fileManager createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:NULL ];
    
    cacheFilename = [ NSString stringWithFormat:@"%@/%@.png", cacheDirectory, MD5 ];
    
    //NSLog( @"cacheFilename: %@", cacheFilename );
    
#endif
    
    return cacheFilename;
}



#pragma mark - Resource name

+(UIImage *) imageWithPDFNamed:(NSString *)resourceName atSize:(CGSize)size atPage:(int)page
{
    return [ self imageWithPDFURL:[ PDFView resourceURLForName:resourceName ] atSize:size atPage:page ];
}

+(UIImage *) imageWithPDFNamed:(NSString *)resourceName atSize:(CGSize)size
{
    return [ self imageWithPDFURL:[ PDFView resourceURLForName:resourceName ] atSize:size ];
}



+(UIImage *) imageWithPDFNamed:(NSString *)resourceName atWidth:(CGFloat)width atPage:(int)page
{
    return [ self imageWithPDFURL:[ PDFView resourceURLForName:resourceName ] atWidth:width atPage:page ];
}

+(UIImage *) imageWithPDFNamed:(NSString *)resourceName atWidth:(CGFloat)width
{
    return [ self imageWithPDFURL:[ PDFView resourceURLForName:resourceName ] atWidth:width ];
}



+(UIImage *) imageWithPDFNamed:(NSString *)resourceName atHeight:(CGFloat)height atPage:(int)page
{
    return [ self imageWithPDFURL:[ PDFView resourceURLForName:resourceName ] atHeight:height atPage:page ];
}

+(UIImage *) imageWithPDFNamed:(NSString *)resourceName atHeight:(CGFloat)height
{
    return [ self imageWithPDFURL:[ PDFView resourceURLForName:resourceName ] atHeight:height ];
}



+(UIImage *) originalSizeImageWithPDFNamed:(NSString *)resourceName atPage:(int)page
{
    return [ self originalSizeImageWithPDFURL:[ PDFView resourceURLForName:resourceName ] atPage:page ];
}

+(UIImage *) originalSizeImageWithPDFNamed:(NSString *)resourceName
{
    return [ self originalSizeImageWithPDFURL:[ PDFView resourceURLForName:resourceName ]];
}



#pragma mark - Resource URLs

+(UIImage *) imageWithPDFURL:(NSURL *)URL atSize:(CGSize)size atPage:(int)page
{
    UIImage *pdfImage = nil;
    
    PDFView *pdfView = [[ PDFView alloc ] initWithFrame:CGRectMake( 0, 0, size.width, size.height ) ];
    
    NSString *cacheFilename = [ self cacheFilenameForURL:URL atSize:size atScaleFactor:pdfView.contentScaleFactor atPage:page ];
    
    if([[ NSFileManager defaultManager ] fileExistsAtPath:cacheFilename ])
    {
        //NSLog( @"Cache hit" );
        
        pdfImage = [ UIImage imageWithCGImage:[[ UIImage imageWithContentsOfFile:cacheFilename ] CGImage ] scale:pdfView.contentScaleFactor orientation:UIImageOrientationUp ];
    }
    else 
    {
        //NSLog( @"Cache miss" );
    
        pdfView.backgroundColor = [ UIColor clearColor ];
        pdfView.page = page;
        pdfView.resourceURL = URL;
        
        pdfImage = [ pdfView image ];
        
        if( cacheFilename )
        {
            [ UIImagePNGRepresentation( pdfImage ) writeToFile:cacheFilename atomically:NO ];
        }
    }
    
    // [ pdfView release ];
    
	return pdfImage;
}

+(UIImage *) imageWithPDFURL:(NSURL *)URL atSize:(CGSize)size
{
    return [ self imageWithPDFURL:URL atSize:size atPage:1 ];
}




+(UIImage *) imageWithPDFURL:(NSURL *)URL atWidth:(CGFloat)width atPage:(int)page
{
    CGRect mediaRect = [ PDFView mediaRectForURL:URL ];
    CGFloat aspectRatio = mediaRect.size.width / mediaRect.size.height;
    
    CGSize size = CGSizeMake( width, ceilf( width / aspectRatio ));
    
    return [ UIImage imageWithPDFURL:URL atSize:size atPage:page ];
}

+(UIImage *) imageWithPDFURL:(NSURL *)URL atWidth:(CGFloat)width
{
    return [ UIImage imageWithPDFURL:URL atWidth:width atPage:1 ];
}



+(UIImage *) imageWithPDFURL:(NSURL *)URL atHeight:(CGFloat)height atPage:(int)page
{
    CGRect mediaRect = [ PDFView mediaRectForURL:URL ];
    CGFloat aspectRatio = mediaRect.size.width / mediaRect.size.height;
    
    CGSize size = CGSizeMake( ceilf( height * aspectRatio ), height );
    
    return [ UIImage imageWithPDFURL:URL atSize:size atPage:page ];
}

+(UIImage *) imageWithPDFURL:(NSURL *)URL atHeight:(CGFloat)height
{
    return [ UIImage imageWithPDFURL:URL atHeight:height atPage:1 ];
}



+(UIImage *) originalSizeImageWithPDFURL:(NSURL *)URL atPage:(int)page
{
    CGRect mediaRect = [ PDFView mediaRectForURL:URL ];
    
    return [ UIImage imageWithPDFURL:URL atSize:mediaRect.size atPage:page ];
}

+(UIImage *) originalSizeImageWithPDFURL:(NSURL *)URL
{
    return [ UIImage originalSizeImageWithPDFURL:URL atPage:1 ];
}



@end
