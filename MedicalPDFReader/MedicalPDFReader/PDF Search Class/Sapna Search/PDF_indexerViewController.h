//
//  PDF_indexerViewController.h
//  PDF indexer
//
//  Created by Columbus 2 on 5/6/11.
//  Copyright 2011 SapnaSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDF_indexerViewController : NSObject {
	CGPDFDocumentRef myDocumentRef;
	NSString *nameOfFileString;
//	IBOutlet UILabel *noOfPages;
//	IBOutlet UILabel *fileName;
//	IBOutlet UILabel *noOfIndexedWords;
//	IBOutlet UIImageView *pdfThumbnailImageView;
	int numberOfTotalPages;

	NSMutableArray *arrayOfIndices;
	NSMutableArray *arrayofElementsForPage;
	NSMutableArray *arrayofElementsForEntireCatalog;
	NSMutableArray *eachFilesElements;
	NSMutableArray *allFilesText;
	
	UIImage *shelfThumbnail;
	UIImage *coverflowThumbnail;
	NSArray *eachFilesWordsArray;
	
	//final output to be stored in these vars (well, just before plist)
	NSMutableDictionary *needlesAndLocations;
	NSMutableArray *needleIndicesArray;
	NSString *needleString;
}
@property (nonatomic, retain) NSString *nameOfFileString;

//-(IBAction)searchForText;
-(void)checkStatus;

-(void)searchForText;
-(void)indexTheFile;
- (void)saveToPlist;
-(void)createThumbnailImages:(CGPDFDocumentRef)pdf;
-(UIImage *)readThumbnail:(CGPDFDocumentRef)pdf ofType:(int)type;


@end

