    //
//  SearchTablePopup.m
//  CostaCrociere
//
//  Created by Alexander 2 on 02/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchTablePopup.h"
//#import "SapnaReaderAppDelegate.h"

@implementation SearchTablePopup


@synthesize myArrayOfIndices;
@synthesize rootDelegate;




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UILabel *searchLabel = [[UILabel alloc] init];
	searchLabel.frame = CGRectMake(0, 0, 320, 50);
	searchLabel.backgroundColor = [UIColor blueColor];
	searchLabel.text = @"Search for a term";
	searchLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:searchLabel];
	
	tableForThisView = [[UITableView alloc] initWithFrame:CGRectMake(0,40,320,250) style:UITableViewStylePlain];//WithFrame:CGRectMake(0, firstButton.frame.origin.y+firstButton.frame.size.height  + kDifferenceBetnViews, self.frame.size.width, self.frame.size.height-(firstButton.frame.origin.y+firstButton.frame.size.height  + kDifferenceBetnViews)) style:style];
//	tableForThisView.frame = CGRectMake(0,40,320,250);
	
	[tableForThisView setBackgroundView:nil];
	[tableForThisView setBackgroundView:[[[UIView alloc] init] autorelease]];
	tableForThisView.backgroundView.backgroundColor = [UIColor whiteColor];
	tableForThisView.dataSource = self;
	tableForThisView.delegate = self; //rootDelegate; //
	tableForThisView.backgroundColor = [UIColor clearColor];
//	tableForThisView.bounces = NO;

	checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SelectOn.png"]];

	UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableForThisView.frame.size.width, 50)];
	UILabel *tableHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableForThisView.frame.size.width, 50)];
	tableHeader.text =@"Tutto il catalogo";
	tableHeader.textAlignment = UITextAlignmentCenter;
	tableHeader.font = [UIFont boldSystemFontOfSize:20.f];
    tableHeader.backgroundColor = [UIColor lightGrayColor];
	
	undoFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
	undoFilterButton.frame = tableHeader.frame;
	[undoFilterButton addTarget:self action:@selector(undoFilterAction) forControlEvents:UIControlEventTouchUpInside];
	
	[tableHeaderView addSubview:tableHeader];
	[tableHeaderView addSubview:undoFilterButton];
	tableForThisView.tableHeaderView = tableHeaderView;
	
	[self.view addSubview:tableForThisView];

	
	
	
	[self generateResults];
	[tableForThisView reloadData];
}




- (void)generateResults
{
//	NSMutableArray *master = [[NSMutableArray alloc] init];
	
}


#pragma mark TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.

    return [resultInfo count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}



//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section    // fixed font style. use custom view (UILabel) if you want something different
//{
//	mySection = [sections objectAtIndex:section];
//	NSString *returnString = [NSString stringWithFormat:@"  %@ (%d)", mySection.title, section];
//	return returnString;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *headerView = [[UIView alloc] init];
	
	UILabel *headerLabel = [[[UILabel alloc] init] autorelease];
	headerLabel.frame = CGRectMake(5, 0, 275, 44);
//	headerLabel.backgroundColor = [UIColor lightGrayColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:19.f];
	
	NSDictionary *sectionObj = [resultInfo objectAtIndex:section];
	headerLabel.text = [[sectionObj objectForKey:@"title"] stringByAppendingFormat:@" (%d)", [[sectionObj objectForKey:@"pages"] integerValue]];
	[headerView addSubview:headerLabel];
	
	UIImageView *checkImageForHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SelectOn.png"]];
//	if (([appDelegate.lastSectionString isEqualToString:  [sectionObj objectForKey:@"title"]]) && (appDelegate.sectionPageNumber == [[sectionObj objectForKey:@"page"] integerValue]))
//	{
//		checkImageForHeader.frame = CGRectMake(280, 7, 30, 30);
//		[headerView addSubview:checkImageForHeader];
//		[checkImageForHeader release];
//	}
//	else 
//		[checkImageForHeader release];
	
	UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	headerButton.tag = section;
	[headerButton addTarget:self action:@selector(headerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	headerButton.frame = headerLabel.frame;
	
	[headerView addSubview:headerButton];
	
	return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int counter=0;
	
	NSDictionary *sectionObj = [resultInfo objectAtIndex:section];
	counter = [[sectionObj objectForKey:@"subsections"] count];
	
	return counter;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	static NSString *CellIdentifier = @"SectionSearch";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
		

	NSDictionary *section = [resultInfo objectAtIndex:indexPath.section];
	NSDictionary *subSection = [[section objectForKey:@"subsections"] objectAtIndex:indexPath.row];
	cell.indentationLevel = 1;
	cell.textLabel.text = [[subSection objectForKey:@"title"] stringByAppendingFormat:@" (%d)", [[subSection objectForKey:@"pages"] integerValue]];
	
//	if (([currentSelectedTitle isEqualToString:[subSection objectForKey:@"title"]]) && ([currentStartPage isEqualToString:[subSection objectForKey:@"page"]]))
		cell.accessoryView = nil;
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    return cell;
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *section = [resultInfo objectAtIndex:indexPath.section];
	NSDictionary *subSection = [[section objectForKey:@"subsections"] objectAtIndex:indexPath.row];

	//NSLog(@"page = %@", [subSection objectForKey:@"page"]);
//	//NSLog(@"didSelect For search Table Called for Row %d in section %d", indexPath.row, indexPath.section);
//	Section * section = [sections objectAtIndex:indexPath.section];
//	//NSLog(@"%d",[section.page integerValue]);
	int range = [[subSection objectForKey:@"pages"] integerValue];
//	currentSelectedTitle = [subSection objectForKey:@"title"];
//	currentStartPage = [subSection objectForKey:@"page"];
	[rootDelegate currentSelectedSectionPage:[[subSection objectForKey:@"page"] integerValue] withRange:range andTitle:[subSection objectForKey:@"title"]];
}


#pragma mark -

-(void)headerButtonAction: (id) sender
{
	NSDictionary *section = [resultInfo objectAtIndex:[sender tag]];
//	NSDictionary *subSection = [[section objectForKey:@"subsections"] objectAtIndex:indexPath.row];
	
	//NSLog(@"page = %@", [section objectForKey:@"page"]);
	int range = [[section objectForKey:@"pages"] integerValue];
	currentSelectedTitle = [section objectForKey:@"title"];
	currentStartPage = [section objectForKey:@"page"];
	[rootDelegate currentSelectedSectionPage:[[section objectForKey:@"page"] integerValue] withRange:range andTitle:[section objectForKey:@"title"]];
	
	
}

-(void)undoFilterAction
{
	//NSLog(@"Button Clicked");
	
	[rootDelegate undoFilterButtonClickedInPopOver];
	[tableForThisView reloadData];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[tableForThisView release];
	[checkImageView release];
	
    [super dealloc];
}


@end
