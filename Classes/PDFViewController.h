//
//  PDFViewController.h
//  PDF
//
//  Created by Masashi Ono on 09/10/23.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFService.h"


@interface PDFViewController : UIViewController <PDFServiceDelegate> {
    UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (IBAction)createPDFFile;
- (IBAction)loadPDFFile;

@end
