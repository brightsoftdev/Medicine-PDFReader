//
//  PDF_indexerViewController.m
//  PDF indexer
//
//  Created by Columbus 2 on 5/6/11.
//  Copyright 2011 SapnaSolutions. All rights reserved.
//

#import "PDF_indexerViewController.h"
#import "PDFSearcher.h"
#define SHELFTYPE 0
#define COVERFLOWTYPE 1

@implementation PDF_indexerViewController

@synthesize nameOfFileString;

-(void)searchForText
{
	CFURLRef pdfURL = CFBundleCopyResourceURL(
                                              CFBundleGetMainBundle(),
                                              (CFStringRef)nameOfFileString,
                                              CFSTR("pdf"), NULL);
	myDocumentRef = CGPDFDocumentCreateWithURL(pdfURL);
	int numberOfPages = CGPDFDocumentGetNumberOfPages(myDocumentRef);
	
	shelfThumbnail = [self readThumbnail:myDocumentRef ofType:SHELFTYPE];
	coverflowThumbnail = [self readThumbnail:myDocumentRef ofType:COVERFLOWTYPE];

	[self createThumbnailImages:myDocumentRef];

	
	PDFSearcher *pdfSearcher = [[PDFSearcher alloc] init];
	numberOfTotalPages = numberOfPages;

	allFilesText = [[NSMutableArray alloc] init];
	
	for (int i=0; i<numberOfPages; i++)	//pdfs always start from 1 and not zero
	{
		CGPDFPageRef myPageRef = CGPDFDocumentGetPage(myDocumentRef, i + 1);
		
		NSString *pageString = [pdfSearcher returnStringForPage:myPageRef];
		//NSLog(@"this is the pagestring for page Number %d:%@", i, pageString);
		eachFilesWordsArray = [pageString componentsSeparatedByString:@" "];
		[allFilesText addObject:eachFilesWordsArray];

		CGPDFPageRelease(myPageRef);
	}	
	[pdfSearcher release];
	pdfSearcher = nil;
	[self indexTheFile];
//	CGPDFDocumentRelease(myDocumentRef);
	CFRelease(pdfURL);
}

-(void)indexTheFile
{
	int i;
	int j;
	//Steps that are done here
	//	1. Read text from all files and save it in a text array	================================================================================
	//	2.  remove duplicate keywords from each page		================================================================================
	//	3.  create index with page numbers for each keyword	================================================================================
	//	4. save to a plist								================================================================================
	
//Uncomment this if its a standalone app, otherwise alloc allFilesText in the Caller itself	
#pragma mark 1. Read text from all files and save it in a text array
/*
	allFilesText = [[NSMutableArray alloc] init];
	NSString *filePath;
	NSString *test;

	//	1. Read text from all files and save it in a text array	 ================================================================================
	//	the Array eachFilesWordsArray contains all text separated by space (\r is replaced by a "space" before doing it)
	for (i=1; i<numberOfTotalPages; i++) 
	{
		filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", i+1] ofType:@"txt"];  
		if (filePath) 
		{  
			test = [NSString stringWithContentsOfFile:filePath]; //deprecated method replaced by following
			//			test = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
			//			test = [NSString stringWithContentsOfFile:filePath usedEncoding:nsut error:nil];
			test = [test stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
			eachFilesWordsArray = [test componentsSeparatedByString:@" "];
		}  
		[allFilesText addObject:eachFilesWordsArray];
	}
	//	//NSLog(@"%@", allFilesText);
*/	
	//  Now to  make the array searching for each element and storing the page numbers;
#pragma mark 2.  remove duplicate keywords from each page
	//	2.  remove duplicate keywords from each page		================================================================================
//	NSMutableArray  *haystack = [[NSMutableArray alloc] init];
	NSString *needle;
//	long indexNumber;
	int internalloop;
//	needlesAndLocations = [[NSMutableDictionary alloc] init];
//	arrayofElementsForPage = [[NSMutableArray alloc] init];
//	arrayofElementsForEntireCatalog = [[NSMutableArray alloc] init];
	for (i=0; i<numberOfTotalPages; i++) 
	{
		//		[arrayofElementsForPage removeAllObjects];
//		NSMutableArray * array = [[NSMutableArray alloc] init];		
		NSMutableArray * haystack = ([[allFilesText objectAtIndex:i] retain]);
		int originalcount = [haystack count];
		int	outerloop;
		for (outerloop=0; outerloop<originalcount; outerloop++)
		{
			needle = [haystack objectAtIndex:outerloop];
			for (internalloop=outerloop+1; internalloop<originalcount; internalloop++) 
			{
				if ([needle isEqualToString:[haystack objectAtIndex:internalloop]])
				{
					[haystack removeObjectAtIndex:internalloop];
					internalloop--;
					originalcount--;
				}
			}
			//[arrayofElementsForPage addObject:needle];
//			[array addObject:needle];
		}
//		[arrayofElementsForEntireCatalog addObject:array];
//		[array release];
		[haystack release];
		haystack = nil;
		
	}
	//	//NSLog(@"arra : %@",arrayofElementsForEntireCatalog);
	
	//	3.  create index with page numbers for each keyword	================================================================================
#pragma mark 3.  create index with page numbers for each keyword
	needlesAndLocations = [[NSMutableDictionary alloc] init];
	int pageNumber;
	for (pageNumber=0; pageNumber<numberOfTotalPages; pageNumber++)
	{
		NSMutableArray * haystack = ([[allFilesText objectAtIndex:pageNumber] retain]);
		for (j=0; j<[haystack count]; j++)
		{
			needle = [haystack objectAtIndex:j];
			//				if (needle==[needlesAndLocations ob
			if ([needlesAndLocations objectForKey:needle]) 
			{
				// key exists.
#ifdef DEBUG
				NSLog(@"Key Exists");
#endif
				needleIndicesArray = [needlesAndLocations objectForKey:needle];
				[needleIndicesArray addObject:[NSNumber numberWithInt:(pageNumber+1)]];
				//				[needlesAndLocations setObject:needleIndicesArray forKey:n
			}
			else
			{
				// add key and value to dict;
				//NSLog(@"Key Does NOT Exist");
				needleIndicesArray = [[NSMutableArray alloc] init];
				[needleIndicesArray addObject:[NSNumber numberWithInt:(pageNumber+1)]];
				[needlesAndLocations setObject:needleIndicesArray forKey:needle];
				[needleIndicesArray release];
				needleIndicesArray = nil;
			}
		}
		[haystack release];
		haystack = nil;
		//		//NSLog(@"These are the keyValue pairs for pageNumber %d = %@", pageNumber, needlesAndLocations);
	}
#ifdef DEBUG
	NSLog(@"These are the final keyValue pairs %@", needlesAndLocations);
#endif
	//	4. save to a plist								================================================================================
#pragma mark 4. save to a plist	
	[self saveToPlist];
}

- (void)saveToPlist
{
	//    [paletteDictionary setObject:matchedPaletteColor1Array forKey:@"1"];
	NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:nameOfFileString];
	//		[fileManager createDirectoryAtPath:fullPath attributes:nil]; //replaced with following LOC by AltF
	[fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
	
    NSString *path = [fullPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", nameOfFileString]];
	[needlesAndLocations writeToFile:path atomically:YES];    
   // write plist to disk
//	shelfThumbnail 
//	coverflowThumbnail
	NSData *data = UIImageJPEGRepresentation(shelfThumbnail, 1.0);
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //already defined
//	NSString *documentsDirectory = [paths objectAtIndex:0];									//already defined
//	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [loginDataField objectAtIndex:0]]];
	//		[fileManager createDirectoryAtPath:fullPath attributes:nil]; //replaced with following LOC by AltF
//	NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_Shelf", nameOfFileString]];
//	[fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
	path = [fullPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_Shelf.jpg", nameOfFileString]];
	//NSLog(@"fullPath = %@", path);
	[fileManager createFileAtPath:path contents:data attributes:nil];
//	[data writeToFile:fullPath atomically:YES];

	data = UIImageJPEGRepresentation(coverflowThumbnail, 1.0);
	path= [fullPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_CoverFlow.jpg", nameOfFileString]];
	[fileManager createFileAtPath:path contents:data attributes:nil];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:YES forKey:[NSString stringWithFormat:nameOfFileString]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.reader.pdf.indexingComplete" object:nil];
    

    
    [needlesAndLocations release];
	needlesAndLocations = nil;
	[allFilesText release];
	allFilesText = nil;

}
-(UIImage *)readThumbnail:(CGPDFDocumentRef)pdf ofType:(int)type
{		
	CGPDFPageRef page;
	CGRect aRect;
	if (type==SHELFTYPE)
		aRect = CGRectMake(0, 0, 120, 150); // thumbnail size for ShelfView;
	else 
		aRect = CGRectMake(0, 0, 400, 500); // thumbnail size for coverflow;
	UIGraphicsBeginImageContext(aRect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIImage* thumbnailImage;
	
	
//	NSUInteger totalNum = CGPDFDocumentGetNumberOfPages(pdf);
	
//	for(int i = 0; i < totalNum; i++ ) {
	int i = 0;
		
		CGContextSaveGState(context);
		CGContextTranslateCTM(context, 0.0, aRect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		CGContextSetGrayFillColor(context, 1.0, 1.0);
		CGContextFillRect(context, aRect);
		
		
		// Grab the first PDF page
		page = CGPDFDocumentGetPage(pdf, i + 1);
		CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, aRect, 0, true);
		// And apply the transform.
		CGContextConcatCTM(context, pdfTransform);
		
		CGContextDrawPDFPage(context, page);
		
		// Create the new UIImage from the context
		thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
		
		//Use thumbnailImage (e.g. drawing, saving it to a file, etc)
		
		CGContextRestoreGState(context);
		
//	}
	
	
	UIGraphicsEndImageContext();    
//	CGPDFDocumentRelease(pdf);
	
	return thumbnailImage;
}
	

-(void)createThumbnailImages:(CGPDFDocumentRef)pdf
{		
	CGPDFPageRef page;
	CGRect aRect;
		aRect = CGRectMake(0, 0, 120, 160); // thumbnail size for ShelfView;
	UIGraphicsBeginImageContext(aRect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIImage* thumbnailImage;
	
	
	NSUInteger totalNum = CGPDFDocumentGetNumberOfPages(pdf);

	NSFileManager *fileManager = [NSFileManager defaultManager];
		
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:nameOfFileString];
	fullPath = [fullPath stringByAppendingPathComponent:@"thumbnails"];
	//		[fileManager createDirectoryAtPath:fullPath attributes:nil]; //replaced with following LOC by AltF
	[fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
	//NSLog(@"fullPath - %@", fullPath);
	NSString *path;
	
	for(int i = 0; i < totalNum; i++ ) 
	{
	
		CGContextSaveGState(context);
		CGContextTranslateCTM(context, 0.0, aRect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		CGContextSetGrayFillColor(context, 1.0, 1.0);
		CGContextFillRect(context, aRect);
		
		
		// Grab the first PDF page
		page = CGPDFDocumentGetPage(pdf, i + 1);
		CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, aRect, 0, true);
		// And apply the transform.
		CGContextConcatCTM(context, pdfTransform);
		
		CGContextDrawPDFPage(context, page);
		
		// Create the new UIImage from the context
		thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
		
		//Use thumbnailImage (e.g. drawing, saving it to a file, etc)
		NSData *data = UIImageJPEGRepresentation(thumbnailImage, 1.0);
		path = [fullPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", i]];
		[fileManager createFileAtPath:path contents:data attributes:nil];

		CGContextRestoreGState(context);
	
	}
	
	
	UIGraphicsEndImageContext();    
	//	CGPDFDocumentRelease(pdf);
	
//	return thumbnailImage;
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setValue: YES forKey: @"_UALastDeviceToken"];
	if (![userDefaults boolForKey:nameOfFileString])
		[userDefaults setBool:YES forKey:[NSString stringWithFormat:nameOfFileString]];
	else 
		[self searchForText];
}
 */

-(void)checkStatus
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//		[userDefaults setBool:YES forKey:[NSString stringWithFormat:nameOfFileString]];
	//    [userDefaults setValue: YES forKey: @"_UALastDeviceToken"];
	if (![userDefaults boolForKey:nameOfFileString])
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[self searchForText];
		[pool drain];
//		[userDefaults setBool:YES forKey:[NSString stringWithFormat:nameOfFileString]];
	}
//	else 
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


*/

- (void)dealloc {
//	CGPDFDocumentRelease(myDocumentRef);
	[super dealloc];
}

@end
