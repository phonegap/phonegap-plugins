
#import "Screenshot.h"


@implementation Screenshot;

@synthesize webView;


 - (void)saveScreenshot:(CDVInvokedUrlCommand*)command
//- (void)saveScreenshot:(NSArray*)arguments withDict:(NSDictionary*)options
{
	CGRect imageRect;
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	// statusBarOrientation is more reliable than UIDevice.orientation
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
	if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
		// landscape check
		imageRect = CGRectMake(0, 0, CGRectGetHeight(screenRect), CGRectGetWidth(screenRect));
	} else {
		// portrait check
		imageRect = CGRectMake(0, 0, CGRectGetWidth(screenRect), CGRectGetHeight(screenRect));
	}
    
	// Adds support for Retina Display. Code reverts back to original if iOs 4 not detected.
	if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, 0);
    else
        UIGraphicsBeginImageContext(imageRect.size);
    
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextTranslateCTM(ctx, 0, 0);
	CGContextFillRect(ctx, imageRect);
    
	[webView.layer renderInContext:ctx];
	// get path and desired name of file
    NSString *basefile = [command.arguments objectAtIndex:0];
    // get base directory where program is located and add map documents 
    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    // combine both paths
    pngPath = [pngPath stringByAppendingPathComponent: basefile];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	//save image
    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
   
}

@end
