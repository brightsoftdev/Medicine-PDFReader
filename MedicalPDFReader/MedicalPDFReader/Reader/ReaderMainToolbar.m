//
//	ReaderMainToolbar.m
//	Reader v2.5.3
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

#import "ReaderConstants.h"
#import "ReaderMainToolbar.h"
#import "ReaderDocument.h"

#import <MessageUI/MessageUI.h>

@implementation ReaderMainToolbar

#pragma mark Constants

#define BUTTON_X 8.0f
#define BUTTON_Y 8.0f
#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 30.0f

#define DONE_BUTTON_WIDTH 56.0f
#define THUMBS_BUTTON_WIDTH 40.0f
#define PRINT_BUTTON_WIDTH 40.0f
#define SEARCH_BUTTON_WIDTH 40.0f
#define MARK_BUTTON_WIDTH 40.0f

#define SEARCH_TEXTFIELD_WIDTH 250.0f
#define SEARCH_TEXTFIELD_HEIGHT 25.0f

#define TITLE_HEIGHT 28.0f

#pragma mark Properties

@synthesize delegate;

#pragma mark ReaderMainToolbar instance methods

- (id)initWithFrame:(CGRect)frame
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	return [self initWithFrame:frame document:nil];
}

- (id)initWithFrame:(CGRect)frame document:(ReaderDocument *)object
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	assert(object != nil); // Check

	if ((self = [super initWithFrame:frame]))
	{
		CGFloat viewWidth = self.bounds.size.width;

		UIImage *imageH = [UIImage imageNamed:@"Reader-Button-H.png"];
		UIImage *imageN = [UIImage imageNamed:@"Reader-Button-N.png"];

		UIImage *buttonH = [imageH stretchableImageWithLeftCapWidth:5 topCapHeight:0];
		UIImage *buttonN = [imageN stretchableImageWithLeftCapWidth:5 topCapHeight:0];

		CGFloat titleX = BUTTON_X; CGFloat titleWidth = (viewWidth - (titleX + titleX));

		CGFloat leftButtonX = BUTTON_X; // Left button start X position

#if (READER_STANDALONE == FALSE) // Option

		UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];

		doneButton.frame = CGRectMake(leftButtonX, BUTTON_Y, DONE_BUTTON_WIDTH, BUTTON_HEIGHT);
		[doneButton setTitle:NSLocalizedString(@"Done", @"button") forState:UIControlStateNormal];
		[doneButton setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateNormal];
		[doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
		[doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[doneButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
		[doneButton setBackgroundImage:buttonN forState:UIControlStateNormal];
		doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
		doneButton.autoresizingMask = UIViewAutoresizingNone;

		[self addSubview:doneButton]; leftButtonX += (DONE_BUTTON_WIDTH + BUTTON_SPACE);

		titleX += (DONE_BUTTON_WIDTH + BUTTON_SPACE); titleWidth -= (DONE_BUTTON_WIDTH + BUTTON_SPACE);

#endif // end of READER_STANDALONE Option

		CGFloat rightButtonX = viewWidth; // Right button start X position

#if (READER_BOOKMARKS == TRUE) // Option

		rightButtonX -= (MARK_BUTTON_WIDTH + BUTTON_SPACE);

		UIButton *flagButton = [UIButton buttonWithType:UIButtonTypeCustom];

		flagButton.frame = CGRectMake(rightButtonX, BUTTON_Y, MARK_BUTTON_WIDTH, BUTTON_HEIGHT);
		//[flagButton setImage:[UIImage imageNamed:@"Reader-Mark-N.png"] forState:UIControlStateNormal];
		[flagButton addTarget:self action:@selector(markButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[flagButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
		[flagButton setBackgroundImage:buttonN forState:UIControlStateNormal];
		flagButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

		[self addSubview:flagButton]; titleWidth -= (MARK_BUTTON_WIDTH + BUTTON_SPACE);

		markButton = [flagButton retain]; markButton.enabled = NO; markButton.tag = NSIntegerMin;

		markImageN = [[UIImage imageNamed:@"Reader-Mark-N.png"] retain]; // N image
		markImageY = [[UIImage imageNamed:@"Reader-Mark-Y.png"] retain]; // Y image

#endif // end of READER_BOOKMARKS Option
//        rightButtonX -= (SEARCH_BUTTON_WIDTH + BUTTON_SPACE);
//        
//        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        searchButton.frame = CGRectMake(rightButtonX, BUTTON_Y, SEARCH_BUTTON_WIDTH, BUTTON_HEIGHT);
//        [searchButton setImage:[UIImage imageNamed:@"search_phone.png"] forState:UIControlStateNormal];
//        [searchButton addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//        [searchButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
//        [searchButton setBackgroundImage:buttonN forState:UIControlStateNormal];
//        searchButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//        
//        [self addSubview:searchButton]; titleWidth -= (SEARCH_BUTTON_WIDTH + BUTTON_SPACE);
        
        rightButtonX -= (SEARCH_TEXTFIELD_WIDTH + BUTTON_SPACE);
        
        UISearchBar * searchBar = [[UISearchBar alloc] init];
        
        searchBar.frame = CGRectMake(rightButtonX,BUTTON_Y + 3, SEARCH_TEXTFIELD_WIDTH,SEARCH_TEXTFIELD_HEIGHT - 2);
        searchBar.delegate = self;
        [searchBar setTintColor:[UIColor clearColor]];
        searchBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        searchBar.backgroundColor = [UIColor clearColor];
        [[searchBar.subviews objectAtIndex:0] removeFromSuperview];
        [self addSubview:searchBar]; titleWidth -= (SEARCH_TEXTFIELD_WIDTH + BUTTON_SPACE);
	}

	return self;
}

- (void)dealloc
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	[markButton release], markButton = nil;

	[markImageN release], markImageN = nil;
	[markImageY release], markImageY = nil;

	[super dealloc];
}

- (void)setBookmarkState:(BOOL)state
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

#if (READER_BOOKMARKS == TRUE) // Option

	if (state != markButton.tag) // Only if different state
	{
		if (self.hidden == NO) // Only if toolbar is visible
		{
			UIImage *image = (state ? markImageY : markImageN);

			[markButton setImage:image forState:UIControlStateNormal];
		}

		markButton.tag = state; // Update bookmarked state tag
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of READER_BOOKMARKS Option
}

- (void)updateBookmarkImage
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

#if (READER_BOOKMARKS == TRUE) // Option

	if (markButton.tag != NSIntegerMin) // Valid tag
	{
		BOOL state = markButton.tag; // Bookmarked state

		UIImage *image = (state ? markImageY : markImageN);

		[markButton setImage:image forState:UIControlStateNormal];
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of READER_BOOKMARKS Option
}

- (void)hideToolbar
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	if (self.hidden == NO)
	{
		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.alpha = 0.0f;
			}
			completion:^(BOOL finished)
			{
				self.hidden = YES;
			}
		];
	}
}

- (void)showToolbar
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	if (self.hidden == YES)
	{
		[self updateBookmarkImage]; // First

		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.hidden = NO;
				self.alpha = 1.0f;
			}
			completion:NULL
		];
	}
}

#pragma mark UIButton action methods

- (void)doneButtonTapped:(UIButton *)button
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	[delegate tappedInToolbar:self doneButton:button];
}

- (void)markButtonTapped:(UIButton *)button
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	[delegate tappedInToolbar:self markButton:button];
}

- (void)searchButtonTapped:(UIButton *)button
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
    
	[delegate tappedInToolbar:self searchButton:button];
}

#pragma mark SearchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Search Clicked");
}

@end
