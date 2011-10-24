//
//  MapAppDelegate.h
//  Map
//
//  Created by Lawrence on 16/07/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "Reachability.h"
@class Reachability;
@interface MapAppDelegate : NSObject <UIApplicationDelegate>{
  Reachability  *hostReach;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
//@property (nonatomic, retain) IBOutlet Reachability  *hostReach;
@end

