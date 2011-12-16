//
//  SearchTablePopup.h
//  CostaCrociere
//
//  Created by Alexander 2 on 02/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SapnaReaderAppDelegate;
@interface SearchTablePopup : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	UITableView *tableForThisView;
	SapnaReaderAppDelegate *appDelegate;
	NSArray *tsections;
	NSMutableArray *sections;
	NSArray *tsubsections;
	NSMutableArray *subsections;
	NSMutableArray *arrayOfSubSections;
	id rootDelegate;
//	UILabel *headerLabel;
	NSArray *myArrayOfIndices;
	NSMutableArray *resultInfo;
	
	NSPredicate *predicate;
	int lastPageIndex;
	
	BOOL isFoundInThisSection;
	int countOfInstances;
	NSMutableArray *countArray;
	UIButton *undoFilterButton;
	
	NSMutableArray *countSubSectionArray;
	NSMutableArray *countElementsInSubsections;
	NSMutableArray *arrayOfNumberOfRowsInSection;
	int numberOfRowsInSection;
	id currentSelectedTitle;
	id currentStartPage;
	UIImageView *checkImageView;

}

@property (nonatomic, assign)   id rootDelegate;
@property (nonatomic, retain)   NSArray *myArrayOfIndices;

- (void)generateResults;

@end
