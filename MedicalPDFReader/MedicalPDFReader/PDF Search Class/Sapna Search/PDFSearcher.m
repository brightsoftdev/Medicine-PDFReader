//
//  PDFSearcher.m
//  TestApp
//
//  Created by Columbus 2 on 2/21/11.
//  Copyright 2011 SapnaSolutions. All rights reserved.
//

/*
///// A method like the following can be applied to get the content of each page from the Caller
-(void)searchForText
{
	//	NSString	 *searchString = @"hello";
	CFURLRef pdfURL = CFBundleCopyResourceURL(
                                              CFBundleGetMainBundle(),
                                              CFSTR("chapter10"),
                                              CFSTR("pdf"), NULL);
	CGPDFDocumentRef myDocumentRef = CGPDFDocumentCreateWithURL(pdfURL);
	int numberOfPages = CGPDFDocumentGetNumberOfPages(myDocumentRef);
	PDFSearcher *pdfSearcher = [[PDFSearcher alloc] init];
	
	for (int i=1; i<=numberOfPages; i++)	//pdfs always start from 1 and not zero
	{
		CGPDFPageRef myPageRef = CGPDFDocumentGetPage(myDocumentRef, i);
		
		NSString *pageString = [pdfSearcher returnStringForPage:myPageRef];
		//NSLog(@"this is the pagestring for page Number %d:%@", i, pageString);
		CGPDFPageRelease(myPageRef);
	}	
	[pdfSearcher release];
	pdfSearcher = nil;
	CGPDFDocumentRelease(myDocumentRef);
 	CFRelease(pdfURL);
	
}
*/

#import "PDFSearcher.h"


@implementation PDFSearcher

@synthesize currentData;
void arrayCallback(CGPDFScannerRef inScanner, void *userInfo)
{
    PDFSearcher * searcher = (PDFSearcher *)userInfo;
	
    CGPDFArrayRef array;
	
    bool success = CGPDFScannerPopArray(inScanner, &array);
	
    for(size_t n = 0; n < CGPDFArrayGetCount(array); n += 2)
    {
        if(n >= CGPDFArrayGetCount(array))
            continue;
		
        CGPDFStringRef string;
        success = CGPDFArrayGetString(array, n, &string);
        if(success)
        {
            NSString *data = (NSString *)CGPDFStringCopyTextString(string);
            [searcher.currentData appendFormat:@"%@", data];
            [data release];
        }
    }
}

void stringCallback(CGPDFScannerRef inScanner, void *userInfo)
{
    PDFSearcher *searcher = (PDFSearcher *)userInfo;
	
    CGPDFStringRef string;
	
    bool success = CGPDFScannerPopString(inScanner, &string);
	
    if(success)
    {
        NSString *data = (NSString *)CGPDFStringCopyTextString(string);
        [searcher.currentData appendFormat:@"%@", data];
        [data release];
		
    }
}

-(id)init
{
    if(self = [super init])
    {
        table = CGPDFOperatorTableCreate();
        CGPDFOperatorTableSetCallback(table, "TJ", arrayCallback);
        CGPDFOperatorTableSetCallback(table, "Tj", stringCallback);
    }
    return self;
}

-(BOOL)page:(CGPDFPageRef)inPage containsString:(NSString *)inSearchString
{
    [self setCurrentData:[NSMutableString string]];
    CGPDFContentStreamRef contentStream = CGPDFContentStreamCreateWithPage(inPage);
    CGPDFScannerRef scanner = CGPDFScannerCreate(contentStream, table, self);
    bool ret = CGPDFScannerScan(scanner);
    CGPDFScannerRelease(scanner);
    CGPDFContentStreamRelease(contentStream);
    //NSLog(@"%u, %@", [self.currentData length], self.currentData);
    return ([[self.currentData uppercaseString] 
             rangeOfString:[inSearchString uppercaseString]].location != NSNotFound);
}

-(NSString *)returnStringForPage: (CGPDFPageRef )inPage
{
	[self setCurrentData:[NSMutableString string]];
	CGPDFContentStreamRef contentStream = CGPDFContentStreamCreateWithPage(inPage);
	CGPDFScannerRef scanner = CGPDFScannerCreate(contentStream, table, self);
	bool ret = CGPDFScannerScan(scanner);	 //this statement is MANDATORY since without this the document isn't ACTUALLY SCANNED !!!!!!!!!!!!!!!!!!!
	NSString *retString;
	if (ret)
	{
		CGPDFScannerRelease(scanner);
		CGPDFContentStreamRelease(contentStream);
		retString = (NSString *)self.currentData;
//		//NSLog(@"%u, %@", [retString length], retString);
	}
	else
		retString = nil;
	return (retString);
	
}


@end
