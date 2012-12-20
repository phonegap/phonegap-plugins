// PDFViewer based on ChildBrowser

//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//  Copyright 2012, Randy McMillan

#import <Cordova/CDVPlugin.h>
#import "PDFViewerViewController.h"

@interface PDFViewerCommand : CDVPlugin <PDFViewerDelegate>{}

@property (nonatomic, strong) PDFViewerViewController *pdfViewer;

- (void)showPDF:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;

@end
