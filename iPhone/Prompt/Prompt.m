//	Phonegap Prompt Plugin
//	Copyright (c) Paul Panserrieu, Zenexity 2011
//	MIT Licensed

#import "Prompt.h"

@implementation Prompt

- (void) show:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {

    NSString* callback = [arguments objectAtIndex:0];
    NSString *title = [options objectForKey:@"title"];
    NSString *okButtonTitle = [options objectForKey:@"okButtonTitle"];
    NSString *cancelButtonTitle = [options objectForKey:@"cancelButtonTitle"];

    PromptAlertView *promptAlertView = [[PromptAlertView alloc]
                                            initWithTitle:title
                                            delegate:self
                                            cancelButtonTitle:cancelButtonTitle
                                            okButtonTitle:okButtonTitle];

    promptAlertView.callback = callback;

    [promptAlertView show];
    [promptAlertView release];
}

- (void)alertView:(UIAlertView *)view clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != [view cancelButtonIndex]) {
        NSString *entered = [(PromptAlertView *)view enteredText];
        NSString* jsCallback = [ NSString 
            stringWithFormat:@"%@.okCallback(\"%@\");", [(PromptAlertView *)view getCallback], entered];
        [super writeJavascript : jsCallback];
    }
    else {
        NSString* jsCallback = [ NSString 
            stringWithFormat:@"%@.cancelCallback();", [(PromptAlertView *)view getCallback]];
        [super writeJavascript : jsCallback];
    }
    [((PromptAlertView*)view).textField resignFirstResponder];
}

@end


@implementation PromptAlertView

@synthesize textField;
@synthesize enteredText;
@synthesize callback;

- (id)initWithTitle : (NSString *) title  
             delegate:(id)delegate
             cancelButtonTitle:(NSString *)cancelButtonTitle 
             okButtonTitle:(NSString *)okayButtonTitle {
    
    self = [super initWithTitle:title
                        message:@"\n"
                        delegate:delegate
                        cancelButtonTitle:cancelButtonTitle
                        otherButtonTitles:okayButtonTitle, nil];
    if (self) {
        UITextField *theTextField = [[UITextField alloc] 
                                        initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)]; 
        [theTextField setOpaque:NO];
        [theTextField setBorderStyle : UITextBorderStyleRoundedRect];
        [self addSubview:theTextField];
        self.textField = theTextField;
        [theTextField release];
        // position fix for iOS < 4
        NSString *iOsVersion = [[UIDevice currentDevice] systemVersion];
        if ([iOsVersion intValue] < 4) {
            [self setTransform:CGAffineTransformMakeTranslation(0,130)];
        }
    }
    return self;
}

- (void) show {
    [textField becomeFirstResponder];
    [super show];
}

- (NSString *) getCallback {
    return callback;
}

- (NSString *) enteredText {
    return textField.text;
}

- (void)didPresentAlertView : (UIAlertView *) alertView {
    [textField becomeFirstResponder];
}

- (void) dealloc {
    [textField release];
    [super dealloc];
}

@end
