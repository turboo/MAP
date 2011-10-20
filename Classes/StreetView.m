//
//  StreetView.m
//  Map
//
//  Created by App on 2011/10/20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "StreetView.h"

@implementation StreetView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
//	UIWebView *streetView = [[UIWebView alloc]init];
//	streetView.frame = CGRectMake(0,0, 400, 400);
//	NSString *htmlString = [NSString stringWithFormat:@"<html>\
//							<head>\
//							<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\">\
//							<script src='http://maps.google.com/maps/api/js?sensor=false' type='text/javascript'></script>\
//							</head>\
//							<body onload=\"new google.maps.StreetViewPanorama(document.getElementById('p'),{position:new google.maps.LatLng(%f, %f)});\" style='padding:0px;margin:0px;'>\
//							<div id='p' style='height:460;width:320;'></div>\
//							</body>\
//							</html>",];
//	[streetView loadHTMLString:htmlString baseURL:nil];
//	[self.view addSubview:streetView];
//	[streetView release];
@end
