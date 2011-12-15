//
//  PDFPageView.m
//  MedicalPDFReader
//
//  Created by Shwet on 15/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFPageView.h"

@implementation PDFPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(id)initWithDocumentPage:(CGPDFPageRef)page andFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        pdfPage = page;
        self.backgroundColor = [UIColor clearColor];
        //self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeScaleAspectFit; // For proper view rotation handling
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // N.B.
        self.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return  self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Grab the first PDF page
    //    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 1);
    // We're about to modify the context CTM to draw the PDF page where we want it, so save the graphics state in case we want to do more drawing
    CGContextSaveGState(context);
    // CGPDFPageGetDrawingTransform provides an easy way to get the transform for a PDF page. It will scale down to fit, including any
    // base rotations necessary to display the PDF page correctly. 
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(pdfPage, kCGPDFCropBox, self.bounds, 0, true);
    // And apply the transform.
    CGContextConcatCTM(context, pdfTransform);
    // Finally, we draw the page and restore the graphics state for further manipulations!
    CGContextDrawPDFPage(context, pdfPage);
    CGContextRestoreGState(context);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
