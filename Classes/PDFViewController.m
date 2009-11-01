//
//  PDFViewController.m
//  PDF
//
//  Created by Masashi Ono on 09/10/23.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "PDFViewController.h"


@implementation PDFViewController

@synthesize webView;


- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // Create and open pdf file
    [self createPDFFile];
    [self loadPDFFile];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.webView = nil;
}

- (void)dealloc
{
    [super dealloc];
}

- (IBAction)createPDFFile
{
    NSArray *arrayPaths = 
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"test.pdf"];
    PDFService *service = [PDFService instance];
    service.delegate = self;
    [service createPDFFile:path];
    service.delegate = nil;
}

- (IBAction)loadPDFFile
{
    NSArray *arrayPaths = 
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"test.pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


#pragma mark -
#pragma mark delegate method


- (void)service:(PDFService *)service
didFailedCreatingPDFFile:(NSString *)filePath
        errorNo:(HPDF_STATUS)errorNo
       detailNo:(HPDF_STATUS)detailNo
{
    NSString *message = [NSString stringWithFormat:@"Couldn't create a PDF file at %@\n errorNo:0x%04x detalNo:0x%04x",
                         filePath,
                         errorNo,
                         detailNo];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"PDF creation error"
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

@end
