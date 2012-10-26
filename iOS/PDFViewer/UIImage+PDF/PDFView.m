//
//  PDFView.m
//
//  Created by Nigel Barber on 15/10/2011.
//  Copyright 2011 Mindbrix Limited. All rights reserved.
//

#import "PDFView.h"


@implementation PDFView

@synthesize page = m_page;
@synthesize resourceName = m_resourceName;
@synthesize resourceURL = m_resourceURL;


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
	
    if (self) 
	{
        // Initialization code.
        m_page = 1;
    }
    return self;
}


-(void)setResourceName:(NSString *)resourceName
{
	m_resourceName = resourceName;
	
    self.resourceURL = [ PDFView resourceURLForName: self.resourceName ];
}


-(void)setResourceURL:(NSURL *)resourceURL
{
    m_resourceURL = resourceURL;
    
    [ self setNeedsDisplay ];
}


+(CGRect) mediaRect:(NSString *)resourceName
{
    return [ PDFView mediaRectForURL:[ PDFView resourceURLForName: resourceName ]];
}


+(CGRect) mediaRectForURL:(NSURL *)resourceURL
{
    return [ self mediaRectForURL:resourceURL atPage:1 ];
}


+(CGRect) mediaRectForURL:(NSURL *)resourceURL atPage:(int)page
{
    CGRect rect = CGRectNull;
    
    if( resourceURL )
	{
		CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL( (__bridge CFURLRef) resourceURL );
		CGPDFPageRef page1 = CGPDFDocumentGetPage( pdf, page );
		
		rect = CGPDFPageGetBoxRect( page1, kCGPDFCropBox );
		
		CGPDFDocumentRelease( pdf );
	}
    
    return rect;
}


+(int) pageCountForURL:(NSURL *)resourceURL
{
    int pageCount = 1;
    
    if( resourceURL )
	{
		CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL( (__bridge CFURLRef) resourceURL );
		
		pageCount = CGPDFDocumentGetNumberOfPages( pdf );
		
		CGPDFDocumentRelease( pdf );
	}
    
    return pageCount;
}


+(NSURL *)resourceURLForName:(NSString *)resourceName
{
    return ( resourceName ) ? [ NSURL fileURLWithPath:[[ NSBundle mainBundle ] pathForResource:resourceName ofType:nil ]] : nil;
}



/**/
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code.
    if( self.resourceURL )
	{
		/* 
		 * Reference: http://www.cocoanetics.com/2010/06/rendering-pdf-is-easier-than-you-thought/
		 */
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		
		[ self.backgroundColor set ];
		CGContextFillRect( ctx, rect );
		
		CGContextGetCTM( ctx );
		CGContextScaleCTM( ctx, 1, -1 );
		CGContextTranslateCTM( ctx, 0, -self.bounds.size.height );
		
        CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL( (__bridge CFURLRef) self.resourceURL );
		CGPDFPageRef page1 = CGPDFDocumentGetPage( pdf, self.page );
		
		CGRect mediaRect = CGPDFPageGetBoxRect( page1, kCGPDFCropBox );
		CGContextScaleCTM( ctx, rect.size.width / mediaRect.size.width, rect.size.height / mediaRect.size.height );
		CGContextTranslateCTM( ctx, -mediaRect.origin.x, -mediaRect.origin.y );
		
		CGContextDrawPDFPage( ctx, page1 );
		CGPDFDocumentRelease( pdf );
	}
}


- (void)dealloc 
{
    //[super dealloc];
}


@end
