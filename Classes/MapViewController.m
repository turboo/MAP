//
//  MapViewController.m
//  Map
//
//  Created by Lawrence on 16/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapDefines.h"
#import "MapViewController.h"


@interface MapViewController ()

+ (NSString *) imageNameForAnnotationType:(MyAnnotationType)aType;

@end


@implementation MapViewController

- (void) viewDidLoad {
    
	[super viewDidLoad];
    
    [self.view setFrame: [[UIScreen mainScreen] bounds]];
    self.title = @"Google Map";
    
    mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
	const MKCoordinateRegion hereIam = (MKCoordinateRegion){
		(CLLocationCoordinate2D) { 24.985649, 121.467486 },
		(MKCoordinateSpan) { 0.008, 0.008 }
	};
    
    mapView.showsUserLocation = YES;
    mapView.zoomEnabled = YES;
    mapView.multipleTouchEnabled = YES;
    [mapView setRegion:hereIam animated:YES];
    
    MyAnnotation *annotation = [[[MyAnnotation alloc] init] autorelease];
    annotation.coordinate = hereIam.center;
    annotation.title = [NSString stringWithFormat:@"I AM Here %i", 0];
    annotation.subtitle = @"Here!";
    [mapView selectAnnotation:annotation animated:YES];

    
    NSMutableArray *annotations = [NSMutableArray array];
    
    for (int i = 1; i <= 30; i++){

        MyAnnotation *annotation = [[MyAnnotation alloc] init];
        CLLocationCoordinate2D coordinate;
        
        if (i % 4 == 0) {
            
			coordinate.latitude  = mapView.centerCoordinate.latitude  + (float)(arc4random() % 8) / 1000;
            coordinate.longitude = mapView.centerCoordinate.longitude + (float)(arc4random() % 8) / 1000;
            annotation.type = AnnotationOneStarType;
			
        } else if (i % 4 == 1) {
            
			coordinate.latitude  = mapView.centerCoordinate.latitude  - (float)(arc4random() % 8) / 1000;
            coordinate.longitude = mapView.centerCoordinate.longitude - (float)(arc4random() % 8) / 1000;
            annotation.type = AnnotationTwoStarsType;
			
        } else if (i % 4 == 2) {
            
			coordinate.latitude  = mapView.centerCoordinate.latitude  + (float)(arc4random() % 8) / 1000;
            coordinate.longitude = mapView.centerCoordinate.longitude - (float)(arc4random() % 8) / 1000;
            annotation.type = AnnotationThreeStarsType;
			
        } else {
            
			coordinate.latitude  = mapView.centerCoordinate.latitude  - (float)(arc4random() % 8) / 1000;
            coordinate.longitude = mapView.centerCoordinate.longitude + (float)(arc4random() % 8) / 1000;
            annotation.type = AnnotationFourStarsType;
			
        }
        
        annotation.coordinate = coordinate;
        annotation.title = [NSString stringWithFormat:@"Title %i", i];
        annotation.subtitle = [NSString stringWithFormat:@"距離： %0.0f m", MapDistanceBetweenCoordinates(hereIam.center, coordinate)];
        [annotations addObject:annotation];
		
        [annotation release];

    }

	[mapView addAnnotations:annotations];


	
}

//-(MKAnnotationView *)mapView:(MKMapView *)amapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];   
//    newAnnotation.pinColor = MKPinAnnotationColorPurple;   
//    newAnnotation.animatesDrop = YES;    
//    //canShowCallout: to display the callout view by touch the pin   
//    newAnnotation.canShowCallout=YES;   
//       
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];   
//    [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];   
//    newAnnotation.rightCalloutAccessoryView=button;    
//  
//    return newAnnotation;   
//
//}



- (MKAnnotationView *) mapView:(MKMapView *)aMapView viewForAnnotation:(MyAnnotation *)annotation{

	if (![annotation isKindOfClass:[MyAnnotation class]]) {
	
		NSLog(@"%s: Handle user location annotation view", __PRETTY_FUNCTION__);
		return nil;
	
	}

	NSString * identifier = [[self class] imageNameForAnnotationType:annotation.type];
	
	MKPinAnnotationView *pinView = (MKPinAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	
	if (!pinView) {
	
		pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
	 
		pinView.canShowCallout = YES;
		pinView.image = [UIImage imageNamed:identifier];
		pinView.calloutOffset = (CGPoint){ 0, 0 };

	}
	
	pinView.annotation = annotation;
	    
    return pinView;

}

+ (NSString *) imageNameForAnnotationType:(MyAnnotationType)aType {

    switch (aType) {
		
		case AnnotationOneStarType: {
			return @"myPin1";
			break;
		}
		
		case AnnotationTwoStarsType: {
			return @"myPin2";
			break;
		}
		
		case AnnotationThreeStarsType: {
			return @"myPin3";
			break;
		}

		default:
		case AnnotationUnknownType: {
			return @"myPin0";
			break;
		}
    }
	
	return nil;

}

- (void) viewDidUnload {

    [super viewDidUnload];
	[mapView release];
	
}


- (void) dealloc {

	[mapView release];
    [super dealloc];

}


@end
