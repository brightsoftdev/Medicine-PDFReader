//
//  SearchViewController.h
//  CostaCrociere
//
//  Created by Alexander 2 on 03/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridView.h"

#define SFOGLIA_HEIGHT 265
#define KEYBOARD_HEIGHT_PORTRAIT 352
#define KEYBOARD_HEIGHT_LANDSCAPE 264

@class SapnaReaderAppDelegate;
@interface SearchViewController : UIViewController <DTGridViewDelegate,DTGridViewDataSource, UISearchBarDelegate, UITableViewDelegate, UIPopoverControllerDelegate>{
	SapnaReaderAppDelegate * appDelegate;
	
	DTGridView * previewgridview;  //no need for the searchgridview
	UIToolbar * objtoolbar;
	id rootViewController;
	BOOL isLandscape;
	int currentPage;
	
	NSArray * sections;
	
	UISearchBar *mySearchBar;
	NSMutableArray *arrayOfIndices;
	NSMutableArray *arrayOfSectionIndices;
	NSString *searchElement;
	BOOL isSearched;
	BOOL isSectionSearched; //subcategory of isSearched
	int sectionPageNumber;
	int sectionRange;
	NSString *lastSectionTitle;
	UILabel *sectionLabel;
	
	BOOL isKeyboardUp;
	BOOL isPopOverPresented;
	CGRect searchBarRect;
	BOOL isTheMainNotification;
	NSDictionary *currentDictionary;
	UIPopoverController *myPopoverForSectionSearch;
	UIButton *sectionSearchButton;
	
	NSString *fileName;
	CGPDFDocumentRef myDocumentRef;
	int numberOfPages;
	
}

@property (nonatomic,assign) id rootViewController;
@property (nonatomic,retain) NSString *fileName;
-(void)reloadGridView;
-(void)currentSelectedSectionPage:(int)pageNumber withRange:(int)range andTitle: (NSString *)sectionTitle;
-(void)undoFilterButtonClickedInPopOver;
-(void)readSearchIndexFile;
-(void)makeSearch;
@end
