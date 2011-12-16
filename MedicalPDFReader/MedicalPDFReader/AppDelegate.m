//
//  AppDelegate.m
//  MedicalPDFReader
//
//  Created by Shwet on 15/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

//#import "ViewController.h"
#import "ReaderViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
	NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    
	NSString *documentName = [[pdfs lastObject] lastPathComponent]; assert(documentName != nil);
    
	ReaderDocument *document = [ReaderDocument unarchiveFromFileName:documentName password:phrase];
    
	if (document == nil) // We need to create a brand new ReaderDocument object the first time we run
	{
		NSString *filePath = [[NSBundle mainBundle] pathForResource:documentName ofType:nil]; // Path
        
		document = [[ReaderDocument alloc] initWithFilePath:filePath password:phrase];
	}
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document andPDFName:[[pdfs lastObject] lastPathComponent]];
        self.window.rootViewController = readerViewController;
		//readerViewController.delegate = self; // Set the ReaderViewController delegate to self
	}
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


@end
