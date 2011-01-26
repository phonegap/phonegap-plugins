//

//  PhoneGap
//
//

#import "MapKit.h"
#import "PGAnnotation.h"
#import "SBJsonParser.h"
#import "SBJSON.h"
#import "AsyncImageView.h"

@implementation MapKitView

@synthesize buttonCallback;
@synthesize childView;
@synthesize mapView;
@synthesize imageButton;


-(PhoneGapCommand*) initWithWebView:(UIWebView*)theWebView
{
    self = (MapKitView*)[super initWithWebView:theWebView];
    return self;
}

/**
 * Create a native map view
 */
- (void)createView
{
	childView = [[UIView alloc] init];
    mapView = [[MKMapView alloc] init];
    [mapView sizeToFit];
    mapView.delegate = self;
    mapView.multipleTouchEnabled   = YES;
    mapView.autoresizesSubviews    = YES;
    mapView.userInteractionEnabled = YES;
	mapView.showsUserLocation = YES;
	mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	childView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[childView addSubview:mapView];
	[childView addSubview:imageButton];

	[ [ [ super appViewController ] view ] addSubview:childView];  
}

- (void)destroyMap:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	if (mapView)
	{
		[ mapView removeAnnotations:mapView.annotations];
		[ mapView removeFromSuperview];

		mapView = nil;
	}
	if(imageButton)
	{
		[ imageButton removeFromSuperview];
		[ imageButton removeTarget:self action:@selector(closeButton:) forControlEvents:UIControlEventTouchUpInside];
		imageButton = nil;
		
	}
	if(childView)
	{
		[ childView removeFromSuperview];
		childView = nil;
	}
	[ buttonCallback release ];
}

/**
 * Set annotations and mapview settings
 */
- (void)setMapData:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{	
    if (!mapView) 
	{
		[self createView];
	}
	else 
	{
		[mapView removeAnnotations:mapView.annotations];
	}
	
	// default height
    CGFloat height = 480.0f;
	// default at bottom
    BOOL atBottom = YES;
		
	if ([options objectForKey:@"height"]) 
	{
		height=[[options objectForKey:@"height"] floatValue];
	}
    if ([options objectForKey:@"atBottom"]) 
	{
		atBottom=[[options objectForKey:@"position"] isEqualToString:@"bottom"];
	}
	if ([options objectForKey:@"buttonCallback"]) 
	{
		self.buttonCallback=[[options objectForKey:@"buttonCallback"] description];
	}
	
	CLLocationCoordinate2D centerCoord = { [[options objectForKey:@"lat"] floatValue] , [[options objectForKey:@"lon"] floatValue] };
	CLLocationDistance diameter = [[options objectForKey:@"diameter"] floatValue];
	
	
	SBJSON *parser=[[SBJSON alloc] init];
	NSArray *pins = [parser objectWithString:[arguments objectAtIndex:0]];
	[parser autorelease];
	CGRect webViewBounds = webView.bounds;
	
	CGRect mapBounds;
	if (atBottom) 
	{
         mapBounds = CGRectMake(
             webViewBounds.origin.x,
             webViewBounds.origin.y + webViewBounds.size.height - height,
             webViewBounds.size.width,
             height
         );
	}
	else 
	{
         mapBounds = CGRectMake(
             webViewBounds.origin.x,
             webViewBounds.origin.y,
             webViewBounds.size.width,
             webViewBounds.origin.y + height
         );
	}
	
	[childView setFrame:mapBounds];
	[mapView setFrame:mapBounds];
	
	MKCoordinateRegion region=[ mapView regionThatFits: MKCoordinateRegionMakeWithDistance(centerCoord, 
																						   diameter*(height / webViewBounds.size.width), 
																						   diameter*(height / webViewBounds.size.width))];
	[mapView setRegion:region animated:YES];
	
	for (int y = 0; y < pins.count; y++) 
	{
		NSDictionary *pinData = [pins objectAtIndex:y];
		CLLocationCoordinate2D pinCoord = { [[pinData objectForKey:@"lat"] floatValue] , [[pinData objectForKey:@"lon"] floatValue] };
		NSString *title=[[pinData valueForKey:@"title"] description];
		NSString *subTitle=[[pinData valueForKey:@"subTitle"] description];
		NSString *imageURL=[[pinData valueForKey:@"imageURL"] description];
		NSString *pinColor=[[pinData valueForKey:@"pinColor"] description];
		NSInteger index=[[pinData valueForKey:@"index"] integerValue];
		BOOL selected = [[pinData valueForKey:@"selected"] boolValue];

		PGAnnotation *annotation = [[PGAnnotation alloc] initWithCoordinate:pinCoord index:index title:title subTitle:subTitle imageURL:imageURL];
		annotation.pinColor=pinColor;
		annotation.selected = selected;

		[mapView addAnnotation:annotation];
		[annotation release];
	}
	
	CGRect frame = CGRectMake(285.0,12.0,  29.0, 29.0);

	
	[ imageButton setImage:[UIImage imageNamed:@"www/map-close-button.png"] forState:UIControlStateNormal];
	[ imageButton setFrame:frame];
	[ imageButton addTarget:self action:@selector(closeButton:) forControlEvents:UIControlEventTouchUpInside];


}

- (void) closeButton:(id)button
{
	[ self hideMap:NULL withDict:NULL];
	NSString* jsString = [NSString stringWithFormat:@"%@(\"%i\");", self.buttonCallback,-1];
	[webView stringByEvaluatingJavaScriptFromString:jsString];
}

- (void)showMap:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	if (!mapView) 
	{
		[self createView];
	}
	childView.hidden = NO;
	mapView.showsUserLocation = YES;
}


- (void)hideMap:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if (!mapView || childView.hidden==YES) 
	{
		return;
	}
	// disable location services, if we no longer need it.
	mapView.showsUserLocation = NO;
	childView.hidden = YES;
}

- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation{
	
	if ([annotation class] != PGAnnotation.class) {
        return nil;
    }
	
	PGAnnotation *phAnnotation=(PGAnnotation *) annotation;
	NSString *identifier=[NSString stringWithFormat:@"INDEX[%i]", phAnnotation.index];

	MKPinAnnotationView *annView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	
	if (annView!=nil) return annView;

	annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
	
	annView.animatesDrop=YES;
	annView.canShowCallout = YES;
	if ([phAnnotation.pinColor isEqualToString:@"green"])
		annView.pinColor = MKPinAnnotationColorGreen;
	else if ([phAnnotation.pinColor isEqualToString:@"purple"])
		annView.pinColor = MKPinAnnotationColorPurple;
	else
		annView.pinColor = MKPinAnnotationColorRed;

	AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:CGRectMake(0,0, 50, 32)] autorelease];
	asyncImage.tag = 999;
	if (phAnnotation.imageURL)
	{
		NSURL *url = [[NSURL alloc] initWithString:phAnnotation.imageURL];
		[asyncImage loadImageFromURL:url];
		[ url release ];
	} 
	else 
	{
		[asyncImage loadDefaultImage];
	}
	
	annView.leftCalloutAccessoryView = asyncImage;

	
	if (self.buttonCallback && phAnnotation.index!=-1)
	{
		
		UIButton *myDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		myDetailButton.frame = CGRectMake(0, 0, 23, 23);
		myDetailButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		myDetailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		myDetailButton.tag=phAnnotation.index;
		annView.rightCalloutAccessoryView = myDetailButton;
		[ myDetailButton addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		
	}
	
	if(phAnnotation.selected)
	{
		[self performSelector:@selector(openAnnotation:) withObject:phAnnotation afterDelay:1.0];
	}

	return annView;
}

-(void)openAnnotation:(id <MKAnnotation>) annotation
{
	[ mapView selectAnnotation:annotation animated:YES];  
	
}

- (void) checkButtonTapped:(id)button 
{
	UIButton *tmpButton = button;
	NSString* jsString = [NSString stringWithFormat:@"%@(\"%i\");", self.buttonCallback, tmpButton.tag];
	[webView stringByEvaluatingJavaScriptFromString:jsString];
}

- (void)dealloc
{
    if (mapView)
	{
		[ mapView removeAnnotations:mapView.annotations];
		[ mapView removeFromSuperview];
        [ mapView release];
	}
	if(imageButton)
	{
		[ imageButton removeFromSuperview];
		[ imageButton release];
	}
	if(childView)
	{
		[ childView removeFromSuperview];
		[ childView release];
	}
	[ buttonCallback release ];
    [super dealloc];
}

@end
