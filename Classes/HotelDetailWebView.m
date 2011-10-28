//
//  HotelDetailWebView.m
//  Map
//
//  Created by App on 2011/10/27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "HotelDetailWebView.h"

@interface HotelDetailWebViewController()

@property (nonatomic, readwrite, retain) UIWebView *detailWebView;
@property (nonatomic, readwrite, assign) NSNumber *hotelID;
@end

@implementation HotelDetailWebViewController
@synthesize detailWebView, hotelID;



- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

	return [self initWithHotelID:nil];

}
- (id) initWithHotelID:(NSNumber *)hotelID
{

	self = [super initWithNibName:nil bundle:nil];
	if (!self)
		return nil;
	
	self.hotelID = hotelID;
	
	return self;

}

- (void) loadView {
	CGRect webViewFrame = CGRectMake(0, 200, 320, 260);
	//UIWebView *detailWebView = [[UIWebView alloc] initWithFrame:webViewFrame];
	self.detailWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 200, 320, 260)] autorelease];
	self.detailWebView.scalesPageToFit = YES;  
	self.view = detailWebView;
}

- (void) viewDidLoad {

	[super viewDidLoad];
	
  SearchHotelQuery *HotelQuery=[[SearchHotelQuery alloc] init];
  Hotel *hotelDetails =[[Hotel alloc] init];
  hotelDetails = [HotelQuery inputHotelIDAndListDataAndChange:self.hotelID];
  NSString *loadedString = [NSString stringWithFormat:
                            @"<html>"
                            @"<head>"
                            @"<BASE href='http://taipeitravel.net/'>"
//                            @"<link href='/frontsite/tw/css/scene.css' rel='stylesheet' type='text/css'>"
//                            @"<link href='/frontsite/tw/css/tips.css' rel='stylesheet' type='text/css'>"
//                            @"<link href='/frontsite/tw/css/intro.css' rel='stylesheet' type='text/css'>"
//                            @"<link href='/frontsite/js/thickbox.css' rel='stylesheet' type='text/css'>"
                            
                            @"</head><body>"
                            @"%@"
                            @"</body></html>",hotelDetails.descriptionHTML];

	[self.detailWebView loadHTMLString:loadedString baseURL:nil];

}

@end
