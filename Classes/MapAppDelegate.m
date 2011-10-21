//
//  MapAppDelegate.m
//  Map
//
//  Created by Lawrence on 16/07/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MapAppDelegate.h"
#import "MADataStore.h"

@implementation MapAppDelegate
@synthesize window;
- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	if (![MADataStore hasPerformedInitialImport])
		[[MADataStore defaultStore] importData];
	MapViewController *mapViewController = [[[MapViewController alloc] init] autorelease];
	UINavigationController *rootNavController = [[[UINavigationController alloc] initWithRootViewController:mapViewController] autorelease];
	[rootNavController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
	
	window.rootViewController = rootNavController;

	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
	[window makeKeyAndVisible];

	return YES;
}

- (void) dealloc {
	
	[window release];
	[super dealloc];
	
}


@end
