//
//  PDFService.m
//  PDF
//
//  Created by Masashi Ono on 09/10/25.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "PDFService.h"


static PDFService *_instance;


void PDFService_defaultErrorHandler(HPDF_STATUS   error_no,
                                    HPDF_STATUS   detail_no,
                                    void         *user_data)
{
    PDFService_userData *userData = (PDFService_userData *)user_data;
    HPDF_Doc pdf = userData->pdf;
    PDFService *service = userData->service;
    NSString *filePath = userData->filePath;
    
    //  HPDF_ResetError(pdf)
    HPDF_Free(pdf);
    
    if (service.delegate) {
        [service.delegate service:service
         didFailedCreatingPDFFile:filePath
                          errorNo:error_no
                         detailNo:detail_no];
    }
}


@implementation PDFService

@synthesize delegate;

- (id) init
{
    self = [super init];
    if (self != nil) {
        //init code
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

+ (PDFService *)instance
{
    if (!_instance) {
        _instance = [[PDFService alloc] init];
    }
    return _instance;
}

- (void)createPDFFile:(NSString *)filePath
{
    // Creates a test PDF file to the specified path.
    // TODO: use UIImage to create non-optimized PNG rather than build target setting
    NSString *path = nil;
    const char *pathCString = NULL;
    
    LOG(@"[libharu] PDF Creation START");
    PDFService_userData userData;
    HPDF_Doc pdf = HPDF_New(PDFService_defaultErrorHandler, &userData);
    userData.pdf = pdf;
    userData.service = self;
    userData.filePath = filePath;
    LOG(@"[libharu] Adding page 1");
    HPDF_Page page1 = HPDF_AddPage(pdf);
    LOG(@"[libharu] SetSize page 1");
    HPDF_Page_SetSize(page1, HPDF_PAGE_SIZE_A4, HPDF_PAGE_LANDSCAPE);
    LOG(@"[libharu] TextOut page 1");
    HPDF_Page_BeginText(page1);
    HPDF_UseJPFonts (pdf);
    HPDF_UseJPEncodings (pdf);
    HPDF_Font fontEn = HPDF_GetFont(pdf, "Helvetica", "StandardEncoding");
    HPDF_Font fontJp = HPDF_GetFont(pdf, "MS-Mincyo", "90ms-RKSJ-H");
    HPDF_Page_SetFontAndSize(page1, fontEn, 16.0);
    HPDF_Page_TextOut(page1, 50.00, 500.00, "Hello libHaru!");
    HPDF_Page_SetFontAndSize(page1, fontJp, 16.0);
    HPDF_Page_TextOut(page1, 50.00, 460.00, [@"はろー日本語" cStringUsingEncoding:NSShiftJISStringEncoding]);
    HPDF_Page_EndText(page1);
    LOG(@"[libharu] Path drawing page 1");
    HPDF_Page_SetLineWidth(page1, 4.0);
    HPDF_Page_SetRGBStroke(page1, 1.0, 0, 0);
    HPDF_Page_Rectangle(page1, 200, 200, 40, 150);
    HPDF_Page_Stroke(page1);
    LOG(@"[libharu] PNG image drawing page 1");
    // comment out this line intentionally causes an error here to test error handling
//    path = [[NSBundle mainBundle] pathForResource:@"no_such_file_hogehoge"
//                                           ofType:@"png"];
    path = [[NSBundle mainBundle] pathForResource:@"test"
                                           ofType:@"png"];
    pathCString = [path cStringUsingEncoding:NSASCIIStringEncoding];
    LOG(@"[libharu] LoadPngImageFromFile path:%@\n pathCString:%s", path, pathCString);
    HPDF_Image image = HPDF_LoadPngImageFromFile(pdf, pathCString);
    HPDF_Page_DrawImage(page1, image, 260, 240, 245, 319);
    
    pathCString = [filePath cStringUsingEncoding:1];
    LOG(@"[libharu] SaveToFile filePath:%@\n pathCString:%s", filePath, pathCString);
    HPDF_SaveToFile(pdf, pathCString);
    LOG(@"[libharu] Freeing PDF object ");
    if (HPDF_HasDoc(pdf)) {
        HPDF_Free(pdf);
    }
    LOG(@"[libharu] PDF Creation END");
}

@end
