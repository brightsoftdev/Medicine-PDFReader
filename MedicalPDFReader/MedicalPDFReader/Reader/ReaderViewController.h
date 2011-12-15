//
//	ReaderViewController.h
//	Reader v2.5.1
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011 Julius Oklamcak. All rights reserved.
//
//	This work is being made available under a Creative Commons Attribution license:
//		«http://creativecommons.org/licenses/by/3.0/»
//	You are free to use this work and any derivatives of this work in personal and/or
//	commercial products and projects as long as the above copyright is maintained and
//	the original author is attributed.
//

#import <UIKit/UIKit.h>

#import "ReaderDocument.h"
#import "ReaderContentView.h"
#import "ReaderMainToolbar.h"


@class ReaderViewController;
@class ReaderMainToolbar;

@protocol ReaderViewControllerDelegate <NSObject>

@optional // Delegate protocols

- (void)dismissReaderViewController:(ReaderViewController *)viewController;

@end

@interface ReaderViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate,ReaderMainToolbarDelegate, ReaderContentViewDelegate>
{
@private // Instance variables
    
	ReaderDocument *document;
    
	UIScrollView *theScrollView;
    
	ReaderMainToolbar *mainToolbar;
    
	NSMutableDictionary *contentViews;
    
	UIPrintInteractionController *printInteraction;
    
	NSInteger currentPage;
    
	CGSize lastAppearSize;
    
	NSDate *lastHideTime;
    
	BOOL isVisible;
}

@property (nonatomic, assign, readwrite) id <ReaderViewControllerDelegate> delegate;

- (id)initWithReaderDocument:(ReaderDocument *)object;

@end
