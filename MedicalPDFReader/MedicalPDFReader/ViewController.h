//
//  ViewController.h
//  MedicalPDFReader
//
//  Created by Shwet on 15/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PDFPageView.h"
#import "PDFPageContainerScrollView.h"
@interface ViewController : UIViewController <UIScrollViewDelegate>
{
    CGPDFDocumentRef pdf;
    PDFPageView *pageView;
    NSUInteger documentPages;
    UIScrollView *pdfScrollView;
    int currentPageNo;
    CGRect scrollToRect;
}
-(void)updateFramesForOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end
