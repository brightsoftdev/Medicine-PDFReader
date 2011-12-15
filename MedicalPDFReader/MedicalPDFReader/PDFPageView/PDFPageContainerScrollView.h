//
//  PDFPageContainerScrollView.h
//  MedicalPDFReader
//
//  Created by Shwet on 15/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFPageView.h"

@interface PDFPageContainerScrollView : UIScrollView <UIScrollViewDelegate>
{
    UIView * theContainerView;
    PDFPageView * pdfPage;
}

-(id)initWithPageNumber:(NSInteger)pageNo andPage:(CGPDFPageRef)page andFrame:(CGRect)frame;
@end
