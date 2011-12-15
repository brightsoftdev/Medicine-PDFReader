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

@interface ViewController : UIViewController
{
    CGPDFDocumentRef pdf;
    PDFPageView *pageView;
    NSUInteger documentPages;
}

@end
