//
//  WBSendView.m
//  SinaWeiBoSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//

#import "WBSendView.h"

static BOOL WBIsDeviceIPad()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
		return YES;
	}
#endif
	return NO;
}

@interface WBSendView (Private)

- (void)onCloseButtonTouched:(id)sender;
- (void)onSendButtonTouched:(id)sender;
- (void)onClearTextButtonTouched:(id)sender;
- (void)onClearImageButtonTouched:(id)sender;

- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation;
- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation;
- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation;

- (void)addObservers;
- (void)removeObservers;

- (UIInterfaceOrientation)currentOrientation;

- (void)bounceOutAnimationStopped;
- (void)bounceInAnimationStopped;
- (void)bounceNormalAnimationStopped;
- (void)allAnimationsStopped;

- (int)textLength:(NSString *)text;
- (void)calculateTextLength;

- (void)hideAndCleanUp;

@end

@implementation WBSendView

@synthesize contentText;
@synthesize contentImage;
@synthesize delegate;

#pragma mark - WBSendView Life Circle

- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret text:(NSString *)text image:(UIImage *)image
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 480)])
    {
        engine = [[WBEngine alloc] initWithAppKey:appKey appSecret:appSecret];
        [engine setDelegate:self];
        
        // background settings
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        // add the panel view
        panelView = [[UIView alloc] initWithFrame:CGRectMake(16, 73, 288, 335)];
        panelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 288, 335)];
        [panelImageView setImage:[[UIImage imageNamed:@"bg.png"] stretchableImageWithLeftCapWidth:18 topCapHeight:18]];
        
        [panelView addSubview:panelImageView];
        [self addSubview:panelView];
        
        // add the buttons & labels
		closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[closeButton setShowsTouchWhenHighlighted:YES];
		[closeButton setFrame:CGRectMake(15, 13, 48, 30)];
		[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
		[closeButton setTitle:NSLocalizedString(@"关闭", nil) forState:UIControlStateNormal];
		[closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
		[closeButton addTarget:self action:@selector(onCloseButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
		[panelView addSubview:closeButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 12, 140, 30)];
        [titleLabel setText:NSLocalizedString(@"新浪微博", nil)];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        [titleLabel setCenter:CGPointMake(144, 27)];
        [titleLabel setShadowOffset:CGSizeMake(0, 1)];
		[titleLabel setShadowColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:19]];
		[panelView addSubview:titleLabel];
        
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[sendButton setShowsTouchWhenHighlighted:YES];
		[sendButton setFrame:CGRectMake(288 - 15 - 48, 13, 48, 30)];
		[sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[sendButton setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
		[sendButton setTitle: NSLocalizedString(@"发送", nil) forState:UIControlStateNormal];
		[sendButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
		[sendButton addTarget:self action:@selector(onSendButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
		[panelView addSubview:sendButton];
        
        contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(13, 60, 288 - 26, 150)];
		[contentTextView setEditable:YES];
		[contentTextView setDelegate:self];
        [contentTextView setText:text];
		[contentTextView setBackgroundColor:[UIColor clearColor]];
		[contentTextView setFont:[UIFont systemFontOfSize:16]];
 		[panelView addSubview:contentTextView];
        
        wordCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 190, 30, 30)];
		[wordCountLabel setBackgroundColor:[UIColor clearColor]];
		[wordCountLabel setTextColor:[UIColor darkGrayColor]];
		[wordCountLabel setFont:[UIFont systemFontOfSize:16]];
		[wordCountLabel setTextAlignment:UITextAlignmentCenter];
		[panelView addSubview:wordCountLabel];
        
        clearTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[clearTextButton setShowsTouchWhenHighlighted:YES];
		[clearTextButton setFrame:CGRectMake(240, 191, 30, 30)];
		[clearTextButton setContentMode:UIViewContentModeCenter];
 		[clearTextButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
		[clearTextButton addTarget:self action:@selector(onClearTextButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
		[panelView addSubview:clearTextButton];
        
        // calculate the text length
        [self calculateTextLength];
        
        self.contentText = contentTextView.text;
        
        // image(if attachted)
        if (image)
        {
			CGSize imageSize = image.size;	
            CGFloat width = imageSize.width;
			CGFloat height = imageSize.height;
			CGRect tframe = CGRectMake(0, 0, 0, 0);
			if (width > height) {
				tframe.size.width = 120;
				tframe.size.height = height * (120 / width);
			}
			else {
				tframe.size.height = 80;
				tframe.size.width = width * (80 / height);
			}
			
			contentImageView = [[UIImageView alloc] initWithFrame:tframe];
			[contentImageView setImage:image];
			[contentImageView setCenter:CGPointMake(144, 260)];
			
			CALayer *layer = [contentImageView layer];
			[layer setBorderColor:[[UIColor whiteColor] CGColor]];
			[layer setBorderWidth:5.0f];
			
			[contentImageView.layer setShadowColor:[UIColor blackColor].CGColor];
            [contentImageView.layer setShadowOffset:CGSizeMake(0, 0)];
            [contentImageView.layer setShadowOpacity:0.5]; 
            [contentImageView.layer setShadowRadius:3.0];
			
			
			[panelView addSubview:contentImageView];
 			
			clearImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
			[clearImageButton setShowsTouchWhenHighlighted:YES];
			[clearImageButton setFrame:CGRectMake(0, 0, 30, 30)];
			[clearImageButton setContentMode:UIViewContentModeCenter];
			[clearImageButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
			[clearImageButton addTarget:self action:@selector(onClearImageButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
			[clearImageButton setCenter:CGPointMake(contentImageView.center.x + contentImageView.frame.size.width / 2,
                                                    contentImageView.center.y - contentImageView.frame.size.height / 2)];
            [panelView addSubview:clearImageButton];
            
            
            self.contentImage = image;
        }
        
    }
    return self;
}


- (void)dealloc
{
    [engine setDelegate:nil];
    [engine release], engine = nil;
    
    [panelView release], panelView = nil;
    [panelImageView release], panelImageView = nil;
    [titleLabel release], titleLabel = nil;
    [contentTextView release], contentTextView = nil;
    [wordCountLabel release], wordCountLabel = nil;
    [contentImageView release], contentImageView = nil;
    
    
    [contentText release], contentText = nil;
    [contentImage release], contentImage = nil;
    
    delegate = nil;
    
    [super dealloc];
}

#pragma mark - WBSendView Private Methods

#pragma mark Actions

- (void)onCloseButtonTouched:(id)sender
{
    [self hide:YES];
}

- (void)onSendButtonTouched:(id)sender
{
    if ([contentTextView.text isEqualToString:@""])
    {
		UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"新浪微博", nil)
                                                             message:NSLocalizedString(@"请输入微博内容", nil)
                                                            delegate:nil
                                                   cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
    
    [engine sendWeiBoWithText:contentTextView.text image:contentImage];
}

- (void)onClearTextButtonTouched:(id)sender
{
   [contentTextView setText:@""];
	[self calculateTextLength];
}

- (void)onClearImageButtonTouched:(id)sender
{
    [contentImageView setHidden:YES];
    [clearImageButton setHidden:YES];
	[contentImage release], contentImage = nil;
}

#pragma mark Orientations

- (UIInterfaceOrientation)currentOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation
{
    [self setTransform:CGAffineTransformIdentity];
    
    CGRect screenFrame = [UIScreen mainScreen].applicationFrame;
    CGPoint screenCenter = CGPointMake(
                                       screenFrame.origin.x + ceil(screenFrame.size.width / 2),
                                       screenFrame.origin.y + ceil(screenFrame.size.height / 2));

    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        [self setFrame:CGRectMake(0, 0, 480, 320)];
        [panelView setFrame:CGRectMake(16, 10, 480 - 32, 280)];
        [contentTextView setFrame:CGRectMake(13, 50, 480 - 32 - 26, 60 + 50)];
        [contentImageView setCenter:CGPointMake(448 / 2, 155 + 60)];
        [clearImageButton setCenter:CGPointMake(contentImageView.center.x + contentImageView.frame.size.width / 2,
                                                contentImageView.center.y - contentImageView.frame.size.height / 2)];
    
        [wordCountLabel setFrame:CGRectMake(224 + 90, 100 + 60, 30, 30)];
        [clearTextButton setFrame:CGRectMake(224 + 120, 101 + 60, 30, 30)];
        [panelImageView setFrame:CGRectMake(0, 0, 480 - 32, 280)];
        [panelImageView setImage:[UIImage imageNamed:@"bg_land.png"]];
        [sendButton setFrame:CGRectMake(480- 32 - 15 - 48, 13, 48, 30)];
        [titleLabel setCenter:CGPointMake(448 / 2, 27)];
    
        if (isKeyboardShowing)
        {
            [contentTextView setFrame:CGRectMake(13, 50, 480 - 32 - 26, 60)];
            
            [contentImageView setCenter:CGPointMake(448 / 2, 155)];
            [clearImageButton setCenter:CGPointMake(contentImageView.center.x + contentImageView.frame.size.width / 2,
                                                    contentImageView.center.y - contentImageView.frame.size.height / 2)];
            
            [wordCountLabel setFrame:CGRectMake(224 + 90, 100, 30, 30)];
            [clearTextButton setFrame:CGRectMake(224 + 120, 101, 30, 30)];
        }
    
    }
    else
    {
        [self setFrame:CGRectMake(0, 0, 320, 480)];
        [panelView setFrame:CGRectMake(16, 73 - 10, 288, 335)];
        
        if(isKeyboardShowing)
        {
            [panelView setFrame:CGRectMake(16, 73 - 10 - 51, 288, 335)];
        }
        
        [contentTextView setFrame:CGRectMake(13, 60, 288 - 26, 150)];
        [contentImageView setCenter:CGPointMake(144, 260)];
        [clearImageButton setCenter:CGPointMake(contentImageView.center.x + contentImageView.frame.size.width / 2,
                                                contentImageView.center.y - contentImageView.frame.size.height / 2)];
        
        [wordCountLabel setFrame:CGRectMake(210, 190, 30, 30)];
        [clearTextButton setFrame:CGRectMake(240, 191, 30, 30)];
        [panelImageView setFrame:CGRectMake(0, 0, 288, 335)];
        [panelImageView setImage:[UIImage imageNamed:@"bg.png"]];
        
        [sendButton setFrame:CGRectMake(288 - 15 - 48, 13, 48, 30)];
        [titleLabel setCenter:CGPointMake(144, 27)];
    
    }
    
    [self setCenter:screenCenter];

    [self setTransform:[self transformForOrientation:orientation]];
    
    previousOrientation = orientation;
}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation
{  
	if (orientation == UIInterfaceOrientationLandscapeLeft)
    {
		return CGAffineTransformMakeRotation(-M_PI / 2);
	}
    else if (orientation == UIInterfaceOrientationLandscapeRight)
    {
		return CGAffineTransformMakeRotation(M_PI / 2);
	}
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
		return CGAffineTransformMakeRotation(-M_PI);
	}
    else
    {
		return CGAffineTransformIdentity;
	}
}

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation 
{
	if (orientation == previousOrientation)
    {
		return NO;
	}
    else
    {
		return orientation == UIInterfaceOrientationLandscapeLeft
		|| orientation == UIInterfaceOrientationLandscapeRight
		|| orientation == UIInterfaceOrientationPortrait
		|| orientation == UIInterfaceOrientationPortraitUpsideDown;
	}
    return YES;
}

#pragma mark Obeservers

- (void)addObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceOrientationDidChange:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)removeObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIKeyboardWillShowNotification" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIKeyboardWillHideNotification" object:nil];
}

#pragma mark Text Length

- (int)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}

- (void)calculateTextLength
{
    if (contentTextView.text.length > 0) 
	{ 
		[sendButton setEnabled:YES];
		[sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	else 
	{
		[sendButton setEnabled:NO];
		[sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	}
	
	int wordcount = [self textLength:contentTextView.text];
	NSInteger count  = 140 - wordcount;
	if (count < 0)
    {
		[wordCountLabel setTextColor:[UIColor redColor]];
		[sendButton setEnabled:NO];
		[sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	}
	else
    {
		[wordCountLabel setTextColor:[UIColor darkGrayColor]];
		[sendButton setEnabled:YES];
		[sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	
	[wordCountLabel setText:[NSString stringWithFormat:@"%i",count]];
}

#pragma mark Animations

- (void)bounceOutAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
    [panelView setAlpha:0.8];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
	[UIView commitAnimations];
}

- (void)bounceInAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceNormalAnimationStopped)];
    [panelView setAlpha:1.0];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
	[UIView commitAnimations];
}

- (void)bounceNormalAnimationStopped
{
    [self allAnimationsStopped];
}

- (void)allAnimationsStopped
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
    if ([delegate respondsToSelector:@selector(sendViewDidAppear:)])
    {
        [delegate sendViewDidAppear:self];
    }
}

#pragma mark Dismiss

- (void)hideAndCleanUp
{
    [self removeObservers];
	[self removeFromSuperview];	
    
    if ([delegate respondsToSelector:@selector(sendViewDidDisappear:)])
    {
        [delegate sendViewDidDisappear:self];
    }
}

#pragma mark - WBSendView Public Methods

- (void)show:(BOOL)animated
{
    [self sizeToFitOrientation:[self currentOrientation]];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if (!window)
    {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
  	[window addSubview:self];
    
    if ([delegate respondsToSelector:@selector(sendViewWillAppear:)])
    {
        [delegate sendViewWillAppear:self];
    }
    
    if (animated)
    {
        [panelView setAlpha:0];
        CGAffineTransform transform = CGAffineTransformIdentity;
        [panelView setTransform:CGAffineTransformScale(transform, 0.3, 0.3)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounceOutAnimationStopped)];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
        [panelView setAlpha:0.5];
        [panelView setTransform:CGAffineTransformScale(transform, 1.1, 1.1)];
        [UIView commitAnimations];
    }
    else
    {
        [self allAnimationsStopped];
    }
	
	[self addObservers];
    
}

- (void)hide:(BOOL)animated
{
    if ([delegate respondsToSelector:@selector(sendViewWillDisappear:)])
    {
        [delegate sendViewWillDisappear:self];
    }
    
	if (animated)
    {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hideAndCleanUp)];
		self.alpha = 0;
		[UIView commitAnimations];
	} else {
		
		[self hideAndCleanUp];
	}
}

#pragma mark - UIDeviceOrientationDidChangeNotification Methods

- (void)deviceOrientationDidChange:(id)object
{
	UIInterfaceOrientation orientation = [self currentOrientation];
	if ([self shouldRotateToOrientation:orientation])
    {
        NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[self sizeToFitOrientation:orientation];
		[UIView commitAnimations];
	}
}

#pragma mark - UIKeyboardNotification Methods

- (void)keyboardWillShow:(NSNotification*)notification
{
    if (isKeyboardShowing)
    {
        return;
    }
	
	isKeyboardShowing = YES;
	
	if (WBIsDeviceIPad())
    {
		// iPad is not supported in this version
		return;
	}
	
	if (UIInterfaceOrientationIsLandscape([self currentOrientation]))
    {
        
 		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
 		
        [contentTextView setFrame:CGRectMake(13, 50, 480 - 32 - 26, 60)];
        [contentImageView setCenter:CGPointMake(448 / 2, 155)];
        [clearImageButton setCenter:CGPointMake(contentImageView.center.x + contentImageView.frame.size.width / 2,
                                                contentImageView.center.y - contentImageView.frame.size.height / 2)];

		[wordCountLabel setFrame:CGRectMake(224 + 90, 100, 30, 30)];
		[clearTextButton setFrame:CGRectMake(224 + 120, 101, 30, 30)];
        
 		[UIView commitAnimations];
	}
	else
    {
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		
		[panelView setFrame:CGRectInset(panelView.frame, 0, -51)];
		
 		[UIView commitAnimations];
	}
}

- (void)keyboardWillHide:(NSNotification*)notification
{
	isKeyboardShowing = NO;
	
	if (WBIsDeviceIPad())
    {
		return;
	}
    
	if (UIInterfaceOrientationIsLandscape([self currentOrientation]))
    {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
 		
        [contentTextView setFrame:CGRectMake(13, 50, 480 - 32 - 26, 60 + 50)];
        [contentImageView setCenter:CGPointMake(448 / 2, 155 + 60)];
        [clearImageButton setCenter:CGPointMake(contentImageView.center.x + contentImageView.frame.size.width / 2,
                                                contentImageView.center.y - contentImageView.frame.size.height / 2)];
        
		[wordCountLabel setFrame:CGRectMake(224 + 90, 100 + 60, 30, 30)];
		[clearTextButton setFrame:CGRectMake(224 + 120, 101 + 60, 30, 30)];
		
 		[UIView commitAnimations];
	}
	else {
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		
		[panelView setFrame:CGRectInset(panelView.frame, 0, -51)];
		
		[UIView commitAnimations];
	}
    
}

#pragma mark - UITextViewDelegate Methods

- (void)textViewDidChange:(UITextView *)textView
{
	[self calculateTextLength];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{	
    return YES;
}

#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    if ([delegate respondsToSelector:@selector(sendViewDidFinishSending:)])
    {
        [delegate sendViewDidFinishSending:self];
    }
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(sendView:didFailWithError:)])
    {
        [delegate sendView:self didFailWithError:error];
    }
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    if ([delegate respondsToSelector:@selector(sendViewNotAuthorized:)])
    {
        [delegate sendViewNotAuthorized:self];
    }
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    if ([delegate respondsToSelector:@selector(sendViewAuthorizeExpired:)])
    {
        [delegate sendViewAuthorizeExpired:self];
    }
}

@end
