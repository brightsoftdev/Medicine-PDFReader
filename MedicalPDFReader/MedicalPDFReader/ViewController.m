//
//  ViewController.m
//  MedicalPDFReader
//
//  Created by Shwet on 15/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ReaderViewController.h"
@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("data.pdf"), NULL, NULL);
        pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
        CFRelease(pdfURL);
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.opaque = YES;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    currentPageNo = 1;
//	// Do any additional setup after loading the view, typically from a nib.
//    pdfScrollView = [[UIScrollView alloc] init];
//    pdfScrollView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//    pdfScrollView.backgroundColor = [UIColor grayColor];
//    pdfScrollView.scrollsToTop = NO;
//	pdfScrollView.pagingEnabled = YES;
//	pdfScrollView.delaysContentTouches = NO;
//	pdfScrollView.showsVerticalScrollIndicator = NO;
//	pdfScrollView.showsHorizontalScrollIndicator = NO;
//	pdfScrollView.contentMode = UIViewContentModeRedraw;
//	pdfScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//	pdfScrollView.backgroundColor = [UIColor clearColor];
//	pdfScrollView.userInteractionEnabled = YES;
//	//pdfScrollView.autoresizesSubviews = NO;
//	pdfScrollView.delegate = self;
//    
//    documentPages = (int)CGPDFDocumentGetNumberOfPages(pdf);
//    NSLog(@"document count %d",documentPages);
//    
//    for (int i=1; i<=documentPages; i++) {
//        pageView = [[PDFPageView alloc] initWithDocumentPage:CGPDFDocumentGetPage(pdf, i) andFrame:self.view.frame];
//        PDFPageContainerScrollView * contentScrollView = [[PDFPageContainerScrollView alloc] initWithPageNumber:i andPage:CGPDFDocumentGetPage(pdf, i) andFrame:CGRectMake((i - 1) * pdfScrollView.frame.size.width, 0, pdfScrollView.frame.size.width, pdfScrollView.frame.size.height)];
//        [pdfScrollView addSubview:contentScrollView];
//    }
//    pdfScrollView.contentSize = CGSizeMake(documentPages*self.view.frame.size.width, 0);
//    [self.view addSubview:pdfScrollView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    // Return YES for supported orientations
//    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
//        pdfScrollView.frame = CGRectMake(0, 0, 1024, 748);
//    }
//    else if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//    {
//        pdfScrollView.frame = CGRectMake(0, 0, 768, 1004);
//    }
//    [self updateFramesForOrientation:interfaceOrientation];
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [pdfScrollView scrollRectToVisible:scrollToRect animated:YES];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    pdfScrollView.contentSize = CGSizeMake(documentPages*self.view.frame.size.width, 0);
    [self updateFramesForOrientation:toInterfaceOrientation];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentPageNo = scrollView.contentOffset.x / scrollView.frame.size.width + 1;
    NSLog(@"%@ , %d",NSStringFromCGPoint(scrollView.contentOffset),currentPageNo);
}

-(void)updateFramesForOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    scrollToRect = CGRectZero;
    for (UIScrollView * contentScrollView in [pdfScrollView subviews]) {
        contentScrollView.frame = CGRectMake((contentScrollView.tag - 1) * pdfScrollView.frame.size.width, contentScrollView.frame.origin.y, contentScrollView.frame.size.width, contentScrollView.frame.size.height);
        if(currentPageNo == contentScrollView.tag)
            scrollToRect = contentScrollView.frame;
    }
}

@end
