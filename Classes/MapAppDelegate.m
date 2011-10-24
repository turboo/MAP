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

- (void)reachabilityChanged:(NSNotification *)note {
  Reachability* curReach = [note object];
  NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
  NetworkStatus status = [curReach currentReachabilityStatus];
  
  if (status == NotReachable) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"睏豆"
                                                    message:@"請檢查網路是否正常連線！"
                                                   delegate:nil
                                          cancelButtonTitle:@"YES" otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  // ...
  
  // 監測網路狀況 （因為用到google地圖 所以用 maps.google.com）
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reachabilityChanged:)
                                               name: kReachabilityChangedNotification
                                             object: nil];
  hostReach = [[Reachability reachabilityWithHostName:@"maps.google.com"] retain];
  [hostReach startNotifer];
  // ...
}

@end
