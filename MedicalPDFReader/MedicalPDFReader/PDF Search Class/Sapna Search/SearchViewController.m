    //
//  SearchViewController.m
//  CostaCrociere
//
//  Created by Alexander 2 on 03/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
//#import "SapnaReaderAppDelegate.h"
#import "SearchTablePopup.h"
#import "PageIndexCell.h"
#import "UIXToolbarView.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
@implementation SearchViewController
@synthesize rootViewController;
@synthesize fileName;

- (void)loadView {
	[super loadView];
	currentDictionary = nil;
	searchElement = nil;
	
	
	[self readSearchIndexFile];
	CFURLRef pdfURL = CFBundleCopyResourceURL(
                                              CFBundleGetMainBundle(),
                                              (CFStringRef)fileName,
                                              CFSTR("pdf"), NULL);
	myDocumentRef = CGPDFDocumentCreateWithURL(pdfURL);
	numberOfPages = CGPDFDocumentGetNumberOfPages(myDocumentRef);
	
	arrayOfIndices = [[NSMutableArray alloc] init];
	arrayOfSectionIndices = [[NSMutableArray alloc] init];
	
	
	objtoolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0,0,1024 ,45)];
	objtoolbar.tintColor = [UIColor clearColor];
    objtoolbar.backgroundColor = [UIColor clearColor];
//	objtoolbar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBarP.png"]];
//	objtoolbar.barStyle = UIBarStyleDefault;
    
    UIXToolbarView * view = [[UIXToolbarView alloc] init];
    [objtoolbar addSubview:view];
    [view release];
	[self.view addSubview:objtoolbar];
	
//	UIImageView *toolbarBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBarP.png"]];
////	toolbarBG.frame = objtoolbar.frame;
//	[objtoolbar addSubview:toolbarBG];
//	[toolbarBG release];
	
	mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 335, 30)];
//	mySearchBar.placeholder = @"Inserisci un termine per inizare la ricerca";
    mySearchBar.placeholder = NSLocalizedString(@"Search Text", @"Search Text");
	mySearchBar.delegate = self;
	
	
	
//	mySearchBar.inputAccessoryView
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	UIButton *close=[UIButton buttonWithType:UIButtonTypeCustom];
	
	[close setImage:[UIImage imageNamed:@"close-Button.png"] forState:UIControlStateNormal];
	[close setImage:[UIImage imageNamed:@"close-buttonPressed.png"] forState:UIControlStateSelected];
	close.frame=CGRectMake(0, 0, 30, 30);
	close.backgroundColor=[UIColor clearColor];
	[close addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem * customItem=[[UIBarButtonItem alloc]  initWithCustomView:close];
	
//	sectionSearchButton=[UIButton buttonWithType:UIButtonTypeCustom];
//	sectionSearchButton.enabled = NO;
//	[sectionSearchButton setImage:[UIImage imageNamed:@"close-Button.png"] forState:UIControlStateNormal];
//	[sectionSearchButton setImage:[UIImage imageNamed:@"close-buttonPressed.png"] forState:UIControlStateSelected];
//	sectionSearchButton.frame=CGRectMake(0, 0, 30, 30);
//	sectionSearchButton.backgroundColor=[UIColor clearColor];
//	[sectionSearchButton addTarget:self action:@selector(sectionSearchButtonAction) forControlEvents:UIControlEventTouchUpInside];
//	UIBarButtonItem * sectionButtonItem=[[UIBarButtonItem alloc]  initWithCustomView:sectionSearchButton];
	
	
	sectionLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0,300,20 ) ];
	sectionLabel.text=@"";
	sectionLabel.textColor= [UIColor whiteColor];//RGBCOLOR(255, 204, 41);
	sectionLabel.backgroundColor=[UIColor clearColor];
	[sectionLabel setFont:[UIFont fontWithName:@"helvetica" size:16]];
	UIBarButtonItem * labelbutton=[[UIBarButtonItem alloc] initWithCustomView:sectionLabel];
	
	UIBarButtonItem * searchBarView = [[UIBarButtonItem alloc] initWithCustomView:mySearchBar];
	NSArray * array=[NSArray arrayWithObjects:searchBarView,/*sectionButtonItem,*/ labelbutton, flexItem,customItem,  nil ];
	
	[objtoolbar setItems:array];
	[flexItem release];
	[customItem release];
//	[sectionButtonItem release];
//	[label release];
//	[labelbutton release];
	[searchBarView release];
	
	previewgridview = [[DTGridView alloc] initWithFrame:CGRectMake(0,objtoolbar.frame.size.height,1024,220)];
	previewgridview.backgroundColor = [UIColor clearColor];//RGBCOLOR(205, 130, 54);
//	previewgridview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backroundFoglia.png"]];
//	previewgridview.backgroundColor = [UIImage imageNamed:@"backroundFoglia.png"];
	previewgridview.delegate = self;
	previewgridview.dataSource = self;
	[self.view addSubview:previewgridview];

//	UIImageView *gridBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backroundFoglia.png"]];
//	//	toolbarBG.frame = objtoolbar.frame;
//	[previewgridview addSubview:gridBG];
//	[gridBG release];
	
	
	
	
//	currentDictionary = [rootViewController giveMeTheDictionary];

//	isSearched = appDelegate.isSearchedAlready;
//	isSectionSearched = appDelegate.isSectionSearchedAlready;
//	sectionPageNumber = appDelegate.sectionPageNumber;
//	sectionRange = appDelegate.sectionRange;
	
//	if (isSearched) 
//	{
//		searchElement = appDelegate.lastSearchedString;
//		mySearchBar.text = searchElement;
//		//NSLog(@"%@", searchElement);
//		[self searchBarSearchButtonClicked:mySearchBar];
//
//	}
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *previousFileName = [userDefaults stringForKey:@"lastSavedSearchFileName"];
	NSString *previousSearchString = [userDefaults stringForKey:@"lastSavedSearchString"];
	
	if ([previousFileName isEqualToString:fileName])
	{
		mySearchBar.text = previousSearchString;
		searchElement = [previousSearchString retain];
		[self makeSearch];
		
	}
	[mySearchBar release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotate:) name:@"actualRotation" object:nil];
}

-(void)doRotate: (id) sender
{
	//NSLog(@"found Solutions");
	[myPopoverForSectionSearch dismissPopoverAnimated:YES];
	//	if (isPopOverPresented)
	//	{
	//		[myPopoverForSectionSearch dismissPopoverAnimated:YES];
	//		[self sectionSearchButtonAction];
	//	}	
	
	
	UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	int shiftsize;
	if (isKeyboardUp)
	{
		//			[mySearchBar resignFirstResponder];
		if (interfaceOrientation== UIDeviceOrientationLandscapeRight||interfaceOrientation== UIDeviceOrientationLandscapeLeft) 	
		{
			shiftsize = KEYBOARD_HEIGHT_PORTRAIT;
			//				searchBarRect = CGRectMake(0, 0-352, 1024, 300);
			searchBarRect = CGRectMake(self.view.frame.origin.x, 768-SFOGLIA_HEIGHT-shiftsize, self.view.frame.size.width, self.view.frame.size.height);
			self.view.frame = searchBarRect;//CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-shiftsize, self.view.frame.size.width, self.view.frame.size.height);
			
			objtoolbar.frame=CGRectMake(0,0,1024 ,45);
			previewgridview.frame =CGRectMake(0,objtoolbar.frame.size.height,1024,220);
			isLandscape=YES;
			
		}
		else if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
		{
			shiftsize = KEYBOARD_HEIGHT_LANDSCAPE;
			//				searchBarRect = CGRectMake(0, 0-264, 768, 300);
			searchBarRect = CGRectMake(self.view.frame.origin.x, 1024-SFOGLIA_HEIGHT-shiftsize, self.view.frame.size.width, self.view.frame.size.height);
			self.view.frame = searchBarRect;//CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-shiftsize, self.view.frame.size.width, self.view.frame.size.height);
			
			objtoolbar.frame=CGRectMake(0,0 ,768,45);
			previewgridview.frame =CGRectMake(0,objtoolbar.frame.size.height,768,220);
			isLandscape=NO;
			
		}
	}
	else 
	{
		if (interfaceOrientation== UIDeviceOrientationLandscapeRight||interfaceOrientation== UIDeviceOrientationLandscapeLeft) 	
		{
			self.view.frame=CGRectMake(0,768-SFOGLIA_HEIGHT ,1024,SFOGLIA_HEIGHT);
			objtoolbar.frame=CGRectMake(0,0 ,1024,45);
			previewgridview.frame =CGRectMake(0,objtoolbar.frame.size.height,1024,220);
			isLandscape=YES;
			//NSLog(@"currently in Landscape");
			
		} 
		else if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
		{
			self.view.frame=CGRectMake(0,1024-SFOGLIA_HEIGHT,768,SFOGLIA_HEIGHT);
			objtoolbar.frame=CGRectMake(0,0 ,768,45);
			previewgridview.frame =CGRectMake(0,objtoolbar.frame.size.height,768,220);
			isLandscape=NO;
			//NSLog(@"currently in Portrait");
			
		}
	}
}

-(void)scrollGridview:(int)pageNO{
	currentPage=pageNO;
//	printf("\n\n scroll grid view");
	//int pageNO= ((RootViewController*)rootViewController).currentPageIndex;
	[previewgridview scrollViewToRow:0 column:pageNO scrollPosition:DTGridViewScrollPositionNone animated:NO];	
}
//-(void) detectOrientation {
//	//NSLog(@" Danger! Danger !");
//	if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || 
//		([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)) {
//		self.view.frame=CGRectMake(0,768-300 ,1024,300);
//		objtoolbar.frame=CGRectMake(0,0 ,1024,50);
//		previewgridview.frame =CGRectMake(0,50,1024,220);
//		tabBarStrip.frame=CGRectMake(0,266, 1024, 34);
//		isLandscape=YES;
//		
//    } 
//	else if ([[UIDevice currentDevice] orientation]== UIDeviceOrientationPortrait||[[UIDevice currentDevice] orientation]== UIDeviceOrientationPortraitUpsideDown) {
//		self.view.frame=CGRectMake(0,1004-300,768,300);
//		objtoolbar.frame=CGRectMake(0,0 ,768,50);
//		previewgridview.frame =CGRectMake(0,50,768,220);
//		tabBarStrip.frame=CGRectMake(0,266, 768, 34);
//		isLandscape=NO;
//	}
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (interfaceOrientation== UIDeviceOrientationLandscapeRight||interfaceOrientation== UIDeviceOrientationLandscapeLeft) 	{

//		self.view.frame=CGRectMake(0,1024-300,1024,300);
		objtoolbar.frame = CGRectMake(0,0 ,1024,45);
		previewgridview.frame =CGRectMake(0,objtoolbar.frame.size.height,1024,220);
		isLandscape=YES;
	}
	
	else if (interfaceOrientation== UIDeviceOrientationPortrait||interfaceOrientation== UIDeviceOrientationPortraitUpsideDown) {
//		self.view.frame = CGRectMake(0,768-300 ,768,300);
		objtoolbar.frame=CGRectMake(0,0 ,768,45);
		previewgridview.frame =CGRectMake(0,objtoolbar.frame.size.height,768,220);
		isLandscape=NO;

	}
//    return YES;
	return NO;

}


-(void)didRotate:(NSNotification *)nsn_notification {
//	if (isTheMainNotification) 
//	{
//		isTheMainNotification = NO;
		UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

		int shiftsize;
		if (isKeyboardUp)
		{
//			[mySearchBar resignFirstResponder];
			if (interfaceOrientation== UIDeviceOrientationLandscapeRight||interfaceOrientation== UIDeviceOrientationLandscapeLeft) 	
			{
				shiftsize = 352;
//				searchBarRect = CGRectMake(0, 0-352, 1024, 300);
				searchBarRect = CGRectMake(self.view.frame.origin.x, 768-SFOGLIA_HEIGHT-shiftsize, self.view.frame.size.width, self.view.frame.size.height);
				self.view.frame = searchBarRect;//CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-shiftsize, self.view.frame.size.width, self.view.frame.size.height);

				objtoolbar.frame=CGRectMake(0,0 ,1024,45);
				previewgridview.frame =CGRectMake(0,objtoolbar.frame.size.height,1024,220);
				isLandscape=YES;
				
			}
			else if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
			{
				shiftsize = 264;
//				searchBarRect = CGRectMake(0, 0-264, 768, 300);
				searchBarRect = CGRectMake(self.view.frame.origin.x, 1024-SFOGLIA_HEIGHT-shiftsize, self.view.frame.size.width, self.view.frame.size.height);
				self.view.frame = searchBarRect;//CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-shiftsize, self.view.frame.size.width, self.view.frame.size.height);
				
				objtoolbar.frame=CGRectMake(0,0 ,768,45);
				previewgridview.frame =CGRectMake(0,objtoolbar.frame.size.height,768,220);
				isLandscape=NO;
			}
		}
		else 
		{
			if (interfaceOrientation== UIDeviceOrientationLandscapeRight||interfaceOrientation== UIDeviceOrientationLandscapeLeft) 	
			{
				self.view.frame=CGRectMake(0,768-SFOGLIA_HEIGHT ,1024,SFOGLIA_HEIGHT);
				objtoolbar.frame=CGRectMake(0,0 ,1024,45);
				previewgridview.frame =CGRectMake(0,objtoolbar.frame.size.height,1024,220);
				isLandscape=YES;
				//NSLog(@"currently in Landscape");
				
			} 
			else if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
			{
				self.view.frame=CGRectMake(0,1024-SFOGLIA_HEIGHT,768,SFOGLIA_HEIGHT);
				objtoolbar.frame=CGRectMake(0,0 ,768,45);
				previewgridview.frame =CGRectMake(0,objtoolbar.frame.size.height,768,220);
				isLandscape=NO;
				//NSLog(@"currently in Portrait");

			}
		}
		if (isPopOverPresented)
		{
			[myPopoverForSectionSearch dismissPopoverAnimated:YES];
			[self sectionSearchButtonAction];
		}	
	
//	}
//	else 
//	{
//		isTheMainNotification = YES;
//	}
}

-(void)action:(id)sender{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	self.view.frame=CGRectMake(0, 1024,768, SFOGLIA_HEIGHT);
	[UIView commitAnimations];
	[self performSelector:@selector(removefromsuperview) withObject:nil afterDelay:0.2];
}	

-(void)sectionSearchButtonAction
{
	isPopOverPresented = YES;
	SearchTablePopup *searchTable = [[SearchTablePopup alloc] init];
	searchTable.myArrayOfIndices = arrayOfIndices;
	myPopoverForSectionSearch = [[UIPopoverController alloc] initWithContentViewController:searchTable];
	myPopoverForSectionSearch.delegate = self;
	if (isLandscape)
	{
		myPopoverForSectionSearch.popoverContentSize = CGSizeMake(320,300);
		[myPopoverForSectionSearch presentPopoverFromRect: CGRectMake(375, -5, 1, 1)
												   inView:self.view 
								 permittedArrowDirections:UIPopoverArrowDirectionDown
												 animated:YES];	
		
	}
	else 
	{
		myPopoverForSectionSearch.popoverContentSize = CGSizeMake(320,300);
		[myPopoverForSectionSearch presentPopoverFromRect: CGRectMake(375, -5, 1, 1)
												   inView:self.view 
								 permittedArrowDirections:UIPopoverArrowDirectionDown
												 animated:YES];	
	}	
	[searchTable release];
}

-(void)removefromsuperview{
	//[rootViewController setStatus];
	[self.view.superview removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	CGPDFDocumentRelease(myDocumentRef);
	if (searchElement)
	{
		[searchElement release];
		searchElement = nil;
	}
	
	[objtoolbar release];
	[sectionLabel release];
 	[currentDictionary release];
	[previewgridview release];
	[arrayOfIndices release];
	[arrayOfSectionIndices release];
	[super dealloc];

}

#pragma mark -
#pragma mark DTGridViewDataSource methods

- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView {
	return 1;
}

- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)index {
	if (isSearched)
	{
		if (isSectionSearched)
			return [arrayOfSectionIndices count];
		return [arrayOfIndices count];
	}
	else 
	{
		return numberOfPages;
//		//NSLog(@"number of pages = %@", catalog.numberOfPages);
//		return [catalog.numberOfPages integerValue]; // anthony
	}
}

- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex {
	return 200.0;
}

- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	return 130.0;
}


- (DTGridViewCell *)gridView:(DTGridView *)gv viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	
	PageIndexCell * cell= (PageIndexCell*)[gv dequeueReusableCellWithIdentifier:@"cell"];
	//	UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",columnIndex+1]];
	//if (columnIndex<405) {
	if (!cell) {
		cell = [[[PageIndexCell alloc] initWithReuseIdentifier:@"cell" ] autorelease];
	}
	
	int pageNumber;
	if (isSearched)
	{
		if (isSectionSearched)
			pageNumber = [[arrayOfSectionIndices objectAtIndex:columnIndex] integerValue] -1;
		else 
			pageNumber = [[arrayOfIndices objectAtIndex:columnIndex] integerValue] -1;
		
	}
	else 
		pageNumber = columnIndex;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullPath;
	if (isSearched)
	{
		fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/thumbnails/%d.jpg", fileName, pageNumber]];
	}
	else 
	{
		fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/thumbnails/%d.jpg", fileName, columnIndex]];
		
	}
	cell.pagePreviewImageView.image = [UIImage imageWithContentsOfFile:fullPath];
	

//	NSString * photoURL = [NSString stringWithFormat:@"%@/preview/%@.jpg",catalog.url,[NSString stringWithFormat:@"%d",pageNumber]];
//	NSString * pageNo;
//	if (isSearched)
//	{
//		if (isSectionSearched)
//		{
//			int page= [[arrayOfSectionIndices objectAtIndex:columnIndex] integerValue]-2;
//			if (page<=0)
//				pageNo = @"";
//			else 
//				pageNo = [NSString stringWithFormat:@"%d", page];
//			
//		}
//		else 
//		{
//			int page= [[arrayOfIndices objectAtIndex:columnIndex] integerValue]-2;
//			if (page<=0)
//				pageNo = @"";
//			else 
//				pageNo = [NSString stringWithFormat:@"%d", page];
//			
//		}
//	}
//	else 
//	{
////		int pageCount = (columnIndex+2) - [catalog.firstPage integerValue];
////		
////		if ( pageCount > 0 ) {
////			pageNo = [NSString stringWithFormat:@"%d",pageCount];
////		}else {
////			pageNo = @"";
////		}
//		photoURL = [NSString stringWithFormat:@"PreviewDefault.png"];
//		pageNo = @"";
//	}		
	
	//}	
	return cell;
}

#pragma mark -
#pragma mark DTGridViewDelegate methods

- (void)gridView:(DTGridView *)gv selectionMadeAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	[self.view.superview removeFromSuperview];
	if (isSearched)
	{
		if (isSectionSearched)
//			[rootViewController showPage:[[arrayOfSectionIndices objectAtIndex:columnIndex] integerValue]-2];
			[rootViewController goToPageIndex:[[arrayOfSectionIndices objectAtIndex:columnIndex] integerValue]-1];
		else 
//			[rootViewController showPage:[[arrayOfIndices objectAtIndex:columnIndex] integerValue]-2];
			[rootViewController goToPageIndex:[[arrayOfIndices objectAtIndex:columnIndex] integerValue]-1];
	}
	else 
		[rootViewController goToPageIndex:columnIndex];

}

- (void)gridViewDidLoad:(DTGridView *)gridView{
//	printf("\n\nGridview did load");
	[self scrollGridview:currentPage];
}
#pragma mark -
#pragma mark SearchBarDelegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar                      // return NO to not become first responder
{
	//iPad keyboard dimensions portrait=264 landscape=352
	isKeyboardUp = YES;
	int shiftsize;
	if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
		shiftsize = KEYBOARD_HEIGHT_LANDSCAPE;
	else 
		shiftsize = KEYBOARD_HEIGHT_PORTRAIT;

	//time to do some animation with the view;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	searchBarRect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -shiftsize, self.view.frame.size.width, self.view.frame.size.height);
	self.view.frame = searchBarRect;
		
	[UIView commitAnimations];
	return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar                       // called when text ends editing
{
//	int shiftsize;
	isKeyboardUp = NO;
	if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)){
		searchBarRect = CGRectMake(self.view.frame.origin.x, 1024-SFOGLIA_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
	}
	else {
		searchBarRect = CGRectMake(self.view.frame.origin.x, 768-SFOGLIA_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	self.view.frame = searchBarRect;
	[UIView commitAnimations];
//	return YES;
	isSectionSearched = NO;
}
/*
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear
{
	searchElement = searchText;
	NSLog(@"searchElement = %@", searchElement);
	if ([searchElement isEqualToString:@""])
	{
		sectionLabel.text = @"";
		
	}
	else 
	{
		
		NSArray *testArray;
		testArray = [searchElement componentsSeparatedByString:@" "];
		int loopNumber;
		[arrayOfIndices removeAllObjects];
		for (loopNumber=0; loopNumber<[testArray count]; loopNumber++)
		{
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF contains[cd] %@)",[testArray objectAtIndex:loopNumber]];
			NSArray *filtered = [[currentDictionary allKeys] filteredArrayUsingPredicate:predicate];
			//	filtered = [appDelegate.pageIndicesForGreen dictionaryWithValuesForKeys:filtered];
			
			//	NSLog(@"array returned = %@ ", filtered);
			if ([filtered count])
			{
				for (int i=0; i<[filtered count]; i++) 
				{
					NSArray *pageIndexArray = [currentDictionary objectForKey:[filtered objectAtIndex:i]];
					for (int j=0; j<[pageIndexArray count]; j++) 
					{
						[arrayOfIndices addObject:[pageIndexArray objectAtIndex:j]];
						
					}
					//		[arrayOfIndices addObject:[appDelegate.pageIndicesForGreen objectForKey:[filtered objectAtIndex:i]]];
					//				[pageIndexArray release];
				}
				//	[arrayOfIndices addObject:nil];
 
				NSLog(@"array before sorting = %@", arrayOfIndices);
				
				isSearched = YES;
				
				//			[filtered release];
				//			[predicate release];
			}
			else 
			{
				NSLog(@"Search String not present in the catalog");
				isSearched = NO;
			}
		}
		NSArray *copy = [arrayOfIndices copy];
		NSInteger index = [copy count] - 1;
		for (id object in [copy reverseObjectEnumerator]) {
			if ([arrayOfIndices indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
				[arrayOfIndices removeObjectAtIndex:index];
			}
			index--;
		}
		[copy release];
		
		
		[arrayOfIndices sortUsingSelector: @selector(compare:)];
		
		if (![arrayOfIndices count]) 
		{
			//		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Attenzione"
			//														 message:@"Nessun risultato trovato"
			//														delegate:self
			//											   cancelButtonTitle:@"Annulla"
			//											   otherButtonTitles:nil];
			//		[alert show];
			sectionLabel.textColor = [UIColor redColor];
			sectionSearchButton.enabled = NO;
			isSearched = NO;
		}
		else 
		{
			sectionLabel.textColor = [UIColor darkGrayColor];
			sectionSearchButton.enabled = YES;
			isSearched = YES;
		}
		//	arrayOfIndices = [arrayOfIndices sortedArrayUsingFunction:fileSyncObjectSort context:NULL];
		NSLog(@"array after sorting = %@", arrayOfIndices);
		//	[testArray release];
		sectionLabel.text = [NSString stringWithFormat:@"%d pagine trovate in Tutto il catalogo", [arrayOfIndices count]];
		
	}
	
	[self reloadGridView];	
	
	
}
*/




#pragma mark -

-(void)makeSearch
{
	NSArray *testArray;
	testArray = [searchElement componentsSeparatedByString:@" "];
	int loopNumber;
	[arrayOfIndices removeAllObjects];
	for (loopNumber=0; loopNumber<[testArray count]; loopNumber++)
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF contains[cd] %@)",[testArray objectAtIndex:loopNumber]];
		NSArray *filtered = [[currentDictionary allKeys] filteredArrayUsingPredicate:predicate];
		//	filtered = [appDelegate.pageIndicesForGreen dictionaryWithValuesForKeys:filtered];
		
		//	//NSLog(@"array returned = %@ ", filtered);
		if ([filtered count])
		{
			for (int i=0; i<[filtered count]; i++) 
			{
				NSArray *pageIndexArray = [currentDictionary objectForKey:[filtered objectAtIndex:i]];
				for (int j=0; j<[pageIndexArray count]; j++) 
				{
					[arrayOfIndices addObject:[pageIndexArray objectAtIndex:j]];
					
				}
				//		[arrayOfIndices addObject:[appDelegate.pageIndicesForGreen objectForKey:[filtered objectAtIndex:i]]];
				//				[pageIndexArray release];
			}
			//	[arrayOfIndices addObject:nil];
			//NSLog(@"array before sorting = %@", arrayOfIndices);
			
			isSearched = YES;
			
			//			[filtered release];
			//			[predicate release];
		}
		else 
		{
			//NSLog(@"Search String not present in the catalog");
			isSearched = NO;
		}
	}
	NSArray *copy = [arrayOfIndices copy];
	NSInteger index = [copy count] - 1;
	for (id object in [copy reverseObjectEnumerator]) {
		if ([arrayOfIndices indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
			[arrayOfIndices removeObjectAtIndex:index];
		}
		index--;
	}
	[copy release];
  //  mySearchBar.placeholder = NSLocalizedString(@"Search Text", @"Search Text");

	
	[arrayOfIndices sortUsingSelector: @selector(compare:)];
	
	if (![arrayOfIndices count]) 
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Warning")
                               
														 message:NSLocalizedString(@"Result Not Found", @"No Result Found")
														delegate:self
											   cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
											   otherButtonTitles:nil];
		[alert show];
		sectionSearchButton.enabled = NO;
		isSearched = NO;
		[alert release];
		alert = nil;
	}
	else 
	{
		sectionSearchButton.enabled = YES;
		isSearched = YES;
	}
    
    
	//	arrayOfIndices = [arrayOfIndices sortedArrayUsingFunction:fileSyncObjectSort context:NULL];
	//NSLog(@"array after sorting = %@", arrayOfIndices);
	//	[testArray release];
	sectionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pages Found in catalog", @"Pages Found in catalog"), [arrayOfIndices count]];
	
	
	[self reloadGridView];	
	
	
	//	if (isSectionSearched)
	//	{
	//		[self currentSelectedSectionPage:sectionPageNumber withRange:sectionRange andTitle:appDelegate.lastSectionString];
	//	}
	
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)mysearchBar                     // called when keyboard search button pressed
{
	//	isSectionSearched = NO;
	if (searchElement)
	{
		[searchElement release];
		searchElement = nil;
	}
	searchElement = [[mysearchBar text] retain];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setValue:fileName forKey:@"lastSavedSearchFileName"];
	[userDefaults setValue:searchElement forKey:@"lastSavedSearchString"];
	[userDefaults synchronize];
	
	[mysearchBar resignFirstResponder];
	
	[self makeSearch];
}

#pragma mark -

#pragma mark PopOverDelegate
//- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
//{
//	//NSLog(@"popover should be dismissed");
//	return YES;
//	
//}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	//NSLog(@"popover dismissed");
	isPopOverPresented = NO;
}

#pragma mark -

#pragma mark -

-(void)currentSelectedSectionPage:(int)pageNumber withRange:(int)range andTitle: (NSString *)sectionTitle
{
	[arrayOfSectionIndices removeAllObjects];
	isSectionSearched = YES;
	sectionPageNumber = pageNumber;
	sectionRange = range;
	lastSectionTitle = sectionTitle;
	sectionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pages Found", @"Pages Found"), range, lastSectionTitle];
	int i;
	for (i=0; i<[arrayOfIndices count]; i++)
	{
		if (pageNumber<=[[arrayOfIndices objectAtIndex:i] integerValue]) 
			break;
	}
	//NSLog(@"object %@ found at index %d", [arrayOfIndices objectAtIndex:i], i);
	for (int j=0; j<range; j++, i++)
		[arrayOfSectionIndices addObject:[arrayOfIndices objectAtIndex:i]];
	//NSLog(@"New Array is %@", arrayOfSectionIndices);
	[myPopoverForSectionSearch dismissPopoverAnimated:YES];
	[self reloadGridView];	
	
//	[rootViewController showSectionpage:sectionPageNumber];
//	[self.view.superview removeFromSuperview];
	

}

-(void)undoFilterButtonClickedInPopOver
{
	isSectionSearched = NO;
	sectionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pages Found in catalog", @"Pages Found in catalog"), [arrayOfIndices count]];
	
	[self reloadGridView];	
}


-(void)reloadGridView
{
	if (previewgridview)
	{
//		[previewgridview removeFromSuperview];
		[previewgridview release];
		previewgridview = nil;
	}
	
	previewgridview = [[DTGridView alloc] init ];//WithFrame:CGRectMake(0,objtoolbar.frame.size.height,1024,220)];
	
	if (isLandscape)
		previewgridview.frame =CGRectMake(0,objtoolbar.frame.size.height,1024,220);
	else 
		previewgridview.frame =CGRectMake(0,objtoolbar.frame.size.height,768,220);
	
	previewgridview.backgroundColor = [UIColor clearColor];//RGBCOLOR(205, 130, 54);
	previewgridview.delegate = self;
	previewgridview.dataSource = self;
	[self.view addSubview:previewgridview];
	
	
	

}

#pragma mark DictionaryMethods
-(void)readSearchIndexFile
{
//	NSArray *array = [currentCatalog.url componentsSeparatedByString:@"/"];
//	NSString *plistName= fileName;
	
	
	
//	NSString *str_Name = [currentCatalog.name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	
	NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.plist",fileName, fileName]] ;
	
	
	//	NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat: @"%@/%@.plist", str_Name, plistName]];
	//NSLog(@"path = %@", path);
	NSData* theData = [NSData dataWithContentsOfFile:path];
	
	//	if(!theData){
	//		return FALSE;
	//	}
	NSString *err = nil;
	NSMutableDictionary * indexInfoDictionary = [NSPropertyListSerialization propertyListFromData:(NSData *)theData
																				 mutabilityOption:NSPropertyListImmutable
																						   format:NULL
																				 errorDescription:&err];	
	if(!indexInfoDictionary){
		return FALSE;
	}
	if (currentDictionary)
	{
		[currentDictionary release];
		currentDictionary = nil;
	}
	currentDictionary = [indexInfoDictionary retain] ;
	//[currentCatalogDictionary retain];
	//	//NSLog(@"%@", currentCatalogDictionary);
	
	//	return TRUE;
	
}

#pragma mark -
@end
