//
//  WBLogInAlertView.m
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

#import "WBLogInAlertView.h"
#import "WBSDKGlobal.h"

@implementation WBLogInAlertView

@synthesize delegate;

#pragma mark - WBLogInAlertView Life Circle

- (id)init
{
    if (self = [super init])
    {
        self.message = @"\n\n\n\n\n\n";
		self.title = @"";
        
        [self addButtonWithTitle:NSLocalizedString(@"取消", nil)];
		[self addButtonWithTitle:NSLocalizedString(@"登录", nil)];
        
        UILabel *userIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 90, 22)];
		[userIDLabel setFont:[UIFont systemFontOfSize:16]];
		[userIDLabel setBackgroundColor:[UIColor clearColor]];
        [userIDLabel setTextColor:[UIColor whiteColor]];
        [userIDLabel setTextAlignment:UITextAlignmentLeft];
        [userIDLabel setText:NSLocalizedString(@"用户名", nil)];
		[self addSubview:userIDLabel];
		[userIDLabel release];
        
        userIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 245, 30)];
        [userIDTextField setBorderStyle:UITextBorderStyleRoundedRect];
		[userIDTextField setKeyboardType:UIKeyboardTypeEmailAddress];
		[userIDTextField setReturnKeyType:UIReturnKeyDone];
		[userIDTextField setBackgroundColor:[UIColor clearColor]];
		[userIDTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[userIDTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
		[userIDTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[self addSubview:userIDTextField];
        [userIDTextField becomeFirstResponder];        
        
        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 90, 22)];
		[passwordLabel setFont:[UIFont systemFontOfSize:16]];
		[passwordLabel setBackgroundColor:[UIColor clearColor]];
        [passwordLabel setTextColor:[UIColor whiteColor]];
        [passwordLabel setTextAlignment:UITextAlignmentLeft];
        [passwordLabel setText:NSLocalizedString(@"密码", nil)];
		[self addSubview:passwordLabel];
		[passwordLabel release];
        
        passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 110, 245, 30)];
        [passwordTextField setBorderStyle:UITextBorderStyleRoundedRect];
		[passwordTextField setKeyboardType:UIKeyboardTypeDefault];
		[passwordTextField setReturnKeyType:UIReturnKeyDone];
		[passwordTextField setBackgroundColor:[UIColor clearColor]];
		[passwordTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[passwordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
		[passwordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [passwordTextField setSecureTextEntry:YES];
		[self addSubview:passwordTextField];
        
        NSString *curSysVer = [[UIDevice currentDevice] systemVersion];
        if ([curSysVer compare:@"4.0" options:NSNumericSearch] == NSOrderedAscending)
        {
            [self setTransform:CGAffineTransformTranslate(self.transform, 0.0, 100.0)];
            [userIDTextField setBackgroundColor:[UIColor clearColor]];
            [passwordTextField setBackgroundColor:[UIColor clearColor]];
        }
        else if ([curSysVer compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending)
        {
            [userIDTextField setBackgroundColor:[UIColor whiteColor]];
            [passwordTextField setBackgroundColor:[UIColor whiteColor]];
        }
        else
        {
            [self setTransform:CGAffineTransformTranslate(self.transform, 0.0, -10.0)];
        }
    }
    return self;
}

- (void)dealloc
{
    delegate = nil;
    
    [userIDTextField release], userIDTextField = nil;
    [passwordTextField release], passwordTextField = nil;
    
    [super dealloc];
}

#pragma mark - UIAlertView Overload Methods

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    
    if (buttonIndex == 1)
    {
        if ([userIDTextField.text length] == 0 || [passwordTextField.text length] == 0)
        {
            return;
        }
        
        if ([delegate respondsToSelector:@selector(logInAlertView:logInWithUserID:password:)])
        {
            [delegate logInAlertView:self logInWithUserID:userIDTextField.text password:passwordTextField.text];
        }
    }
    
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

@end
