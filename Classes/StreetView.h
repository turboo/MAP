//
//  StreetView.h
//  Map
//
//  Created by App on 2011/10/20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StreetView : NSObject{
	//CLLocationCoordinate2D *myLOC;
	UIWebView *myWebView;
}


//@property (nonatomic , retain) CLLocationCoordinate2D *myLOC;
@property (nonatomic , retain) UIWebView *myWebView;

//-(UIWebView *)showStreetViewfromWebView:(CLLocationCoordinate2D  *)coordinate;
-(UIWebView *)showStreetViewfromWebView;
@end
