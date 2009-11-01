//
//  PDFAppDelegate.h
//  PDF
//
//  Created by Masashi Ono on 09/10/06.
//  Copyright Masashi Ono 2009. All rights reserved.
//
    
#import <UIKit/UIKit.h>

@class PDFViewController;

@interface PDFAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PDFViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) PDFViewController *viewController;

@end

