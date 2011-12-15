//
//  PDFPageContainerScrollView.m
//  MedicalPDFReader
//
//  Created by Shwet on 15/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFPageContainerScrollView.h"

@implementation PDFPageContainerScrollView

-(id)initWithPageNumber:(NSInteger)pageNo andPage:(CGPDFPageRef)page andFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        self.tag = pageNo;
        self.scrollsToTop = NO;
		self.delaysContentTouches = NO;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.delegate = self;
        
        if(pageNo%2==0)
            self.backgroundColor = [UIColor clearColor];
        else
            self.backgroundColor = [UIColor magentaColor];
        
		self.userInteractionEnabled = YES;
		self.bouncesZoom = YES;
		
        theContainerView =[[UIView alloc] initWithFrame:self.bounds];
        theContainerView.userInteractionEnabled = NO;
        theContainerView.contentMode = UIViewContentModeRedraw;
        theContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
        if(pageNo%2==0)
            theContainerView.backgroundColor = [UIColor clearColor];
        else
            theContainerView.backgroundColor = [UIColor clearColor];
        
        CGRect viewRect = CGRectZero;
        viewRect.size = self.bounds.size;
        
        pdfPage = [[PDFPageView alloc] initWithDocumentPage:page andFrame:viewRect];
        
        [theContainerView addSubview:pdfPage];
        [self addSubview:theContainerView];
    }
    return self;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return theContainerView;
}

@end
