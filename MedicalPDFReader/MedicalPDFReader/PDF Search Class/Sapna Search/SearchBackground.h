//
//  SearchBackground.h
//  CostaCrociere
//
//  Created by Alexander 2 on 03/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#define SFOGLIA_HEIGHT 265
@interface SearchBackground : UIViewController {
	SearchViewController * searchgridview;
	id delegate;
	NSString *fileName;

}


@property(nonatomic,retain) id delegate;
@property(nonatomic, retain) NSString *fileName;

@end
