//	Phonegap Prompt Plugin
//	Copyright (c) Paul Panserrieu, Zenexity 2011
//	MIT Licensed

#import <Foundation/Foundation.h>
#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "Cordova/CDVPlugin.h"
#endif

@interface PromptAlertView : UIAlertView {
    UITextField *textField;
    NSString* callback;
}

@property (nonatomic, retain) UITextField *textField;
@property (readonly) NSString *enteredText;
@property (nonatomic, copy) NSString* callback;

- (id)initWithTitle : (NSString *) title
             delegate : (id) delegate
             cancelButtonTitle : (NSString *) cancelButtonTitle
             okButtonTitle : (NSString *) okButtonTitle;

- (NSString *)getCallback;
@end

@interface Prompt : CDVPlugin

- (void) show:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end

