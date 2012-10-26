// PDFViewer based on ChildBrowser

//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//  Copyright 2012, Randy McMillan

#import <UIKit/UIKit.h>

@protocol PDFViewerDelegate <NSObject>

- (void)onClose;

@end

@protocol CDVOrientationDelegate <NSObject>

- (NSUInteger)supportedInterfaceOrientations;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (BOOL)shouldAutorotate;

@end

@class PDFView;

@interface PDFViewerViewController : UIViewController <UIWebViewDelegate>{}

@property (nonatomic, strong) IBOutlet UIButton *closeBtn;

@property (nonatomic, strong) IBOutlet PDFView		*pdfView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView	*imageView;
@property (nonatomic, strong) IBOutlet UIToolbar	*toolBar;

// unsafe_unretained is equivalent to assign - used to prevent retain cycles in the two properties below
@property (nonatomic, unsafe_unretained) id <PDFViewerDelegate> delegate;
@property (nonatomic, unsafe_unretained) id						orientationDelegate;

- (PDFViewerViewController *)initWithScale:(BOOL)enabled;
- (IBAction)onDoneButtonPress:(id)sender;
- (void)loadPDF:(NSString *)pdfName;
- (void)closeViewer;

@end
