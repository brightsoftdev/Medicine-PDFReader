//
//  ViewController.m
//  MedicalPDFReader
//
//  Created by Shwet on 15/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

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
	// Do any additional setup after loading the view, typically from a nib.
    UIScrollView *pdfScrollView = [[UIScrollView alloc] init];
    pdfScrollView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    pdfScrollView.backgroundColor = [UIColor grayColor];
    pdfScrollView.pagingEnabled = YES;
    
    documentPages = (int)CGPDFDocumentGetNumberOfPages(pdf);
    NSLog(@"document count %d",documentPages);
    
    for (int i=1; i<=documentPages; i++) {
        pageView = [[PDFPageView alloc] initWithDocumentPage:CGPDFDocumentGetPage(pdf, i) andFrame:CGRectMake((i-1)*self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        [pdfScrollView addSubview:pageView];
    }
    pdfScrollView.contentSize = CGSizeMake(documentPages*self.view.frame.size.width, 0);

    pdfScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //pdfScrollView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:pdfScrollView];
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
    // Return YES for supported orientations
    return YES;
}

@end
