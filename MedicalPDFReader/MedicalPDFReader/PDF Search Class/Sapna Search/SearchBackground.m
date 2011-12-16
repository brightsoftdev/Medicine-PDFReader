    //
//  SearchBackground.m
//  CostaCrociere
//
//  Created by Alexander 2 on 03/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchBackground.h"


@implementation SearchBackground
@synthesize delegate;
@synthesize fileName;

- (void)loadView {
	[super loadView];
	self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
	
	searchgridview = [[SearchViewController alloc] init];
	searchgridview.rootViewController = self.delegate;
	searchgridview.fileName = self.fileName;
	[self.view addSubview:searchgridview.view];
	searchgridview.view.frame = CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width, SFOGLIA_HEIGHT);
	
//	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}


-(void) detectOrientation {
	//printf("\n orientation changed");
	if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || 
		([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)) {
		//printf("\n orientation changed to landscape");
        //load view 2
		self.view.frame=CGRectMake(0,0 ,1024,768 );
		searchgridview.view.frame=CGRectMake(0, 768-SFOGLIA_HEIGHT,1024, SFOGLIA_HEIGHT);
		
    } 
	
	else if ([[UIDevice currentDevice] orientation]== UIDeviceOrientationPortrait||[[UIDevice currentDevice] orientation]== UIDeviceOrientationPortraitUpsideDown){
		//	printf("\n orientation changed to portrait");
        // load view 1
		self.view.frame=CGRectMake(0,0 ,768,1024 );
		searchgridview.view.frame=CGRectMake(0, 1024-SFOGLIA_HEIGHT,768, SFOGLIA_HEIGHT);
	}
}

-(void)loadgridview{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	searchgridview.view.frame=CGRectMake(0, self.view.frame.size.height-SFOGLIA_HEIGHT,self.view.frame.size.width, SFOGLIA_HEIGHT);
	//searchgridview.view.center=CGPointMake(searchgridview.view.center.x,searchgridview.view.center.y-150);
	[UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	//NSLog(@"probably messing up the views in root detectOrientation ");

	if (interfaceOrientation== UIDeviceOrientationLandscapeRight||interfaceOrientation== UIDeviceOrientationLandscapeLeft) 
	{
		self.view.frame=CGRectMake(0,0 ,1024,768 );
		searchgridview.view.frame=CGRectMake(0, self.view.frame.size.height-SFOGLIA_HEIGHT,self.view.frame.size.width, SFOGLIA_HEIGHT);//CGRectMake(0, 768-300,1024, 300);
		
	}
	else if (interfaceOrientation== UIDeviceOrientationPortrait||interfaceOrientation== UIDeviceOrientationPortraitUpsideDown)
	{
		self.view.frame=CGRectMake(0,0 ,768,1024 );
		searchgridview.view.frame=CGRectMake(0, self.view.frame.size.height-SFOGLIA_HEIGHT,self.view.frame.size.width, SFOGLIA_HEIGHT);//CGRectMake(0, 1024-300,768, 300);
	}
	[self loadgridview];
    return YES;
}

-(void)scrollgridview:(int)index
{
	[searchgridview scrollGridview:index];
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
	
	[delegate release];
	[searchgridview release];
    [super dealloc];
}

@end