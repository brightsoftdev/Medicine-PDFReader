//
//  PDFPageView.h
//  MedicalPDFReader
//
//  Created by Shwet on 15/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PDFPageView : UIView
{
    CGPDFPageRef pdfPage;
}

-(id)initWithDocumentPage:(CGPDFPageRef)page andFrame:(CGRect)frame;
@end
