//
//  MapViewController.m
//  Map
//
//  Created by Lawrence on 16/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapDefines.h"
#import "MapViewController.h"
#import "Hotel.h"
#import "MADataStore.h"
#import "CombineImages.h"

@interface MapViewController () <NSFetchedResultsControllerDelegate>

+ (NSString *) imageNameForAnnotationType:(MyAnnotationType)aType;
+ (NSFetchRequest *) fetchRequestInContext:(NSManagedObjectContext *)aContext forCoordinateRegion:(MKCoordinateRegion)region;

- (void) refreshAnnotations;

@property (nonatomic, readwrite, retain) MKMapView *mapView;
@property (nonatomic, readwrite, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite, retain) NSFetchedResultsController *fetchedResultsController;

@end


@implementation MapViewController
@synthesize managedObjectContext, fetchedResultsController;
@synthesize mapView;

+ (NSFetchRequest *) fetchRequestInContext:(NSManagedObjectContext *)aContext forCoordinateRegion:(MKCoordinateRegion)region {

	CLLocationDegrees minLat, maxLat, minLng, maxLng;
	
	minLat = region.center.latitude - region.span.latitudeDelta;
	maxLat = region.center.latitude + region.span.latitudeDelta;
	minLng = region.center.longitude - region.span.longitudeDelta;
	maxLng = region.center.longitude + region.span.longitudeDelta;
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:aContext];
	
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(latitude >= %f) AND (latitude <= %f) AND (longitude >= %f) AND longitude <= %f", minLat, maxLat, minLng, maxLng];
		
	fetchRequest.sortDescriptors = [NSArray arrayWithObjects:
		
		[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:YES],
		
	nil];
	
	return fetchRequest;

}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (!self)
		return nil;
	
    self.title = @"Hotel Map";
	
	self.managedObjectContext = [[MADataStore defaultStore] disposableMOC];
	self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:((^ {
		return [[self class] fetchRequestInContext:self.managedObjectContext forCoordinateRegion:(MKCoordinateRegion){
			(CLLocationCoordinate2D){ 0, 0 },
			(MKCoordinateSpan){ 180, 360 }
		}];
	})()) managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil] autorelease];
	
	self.fetchedResultsController.delegate = self;
	
	NSError *fetchingError = nil;
	if (![self.fetchedResultsController performFetch:&fetchingError])
		NSLog(@"Error fetching: %@", fetchingError);
			
	return self;

}

- (void) viewDidUnload {

    [super viewDidUnload];
	[mapView release];
	
}

- (void) loadView {

	[super loadView];

    mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    
    [self.view addSubview:mapView];

}

- (void) dealloc {
	//[newImage release];
	[managedObjectContext release];
	[fetchedResultsController release];
	[mapView release];
    [super dealloc];

}


- (void) viewDidLoad {
    
	[super viewDidLoad];
        
	const MKCoordinateRegion hereIam = (MKCoordinateRegion){
		(CLLocationCoordinate2D) { 25.041349, 121.557802 },
		(MKCoordinateSpan) { 0.006, 0.006 }
	};
    
    mapView.showsUserLocation = YES;
    mapView.zoomEnabled = YES;
    mapView.multipleTouchEnabled = YES;
    [mapView setRegion:hereIam animated:YES];
    
//    MyAnnotation *annotation = [[[MyAnnotation alloc] init] autorelease];
//    annotation.coordinate = hereIam.center;
//    annotation.title = [NSString stringWithFormat:@"I AM Here %i", 0];
//    annotation.subtitle = @"Here!";
//    [mapView selectAnnotation:annotation animated:YES];

//    
//    NSMutableArray *annotations = [NSMutableArray array];
//    
//    for (int i = 1; i <= 30; i++){
//
//        MyAnnotation *annotation = [[MyAnnotation alloc] init];
//        CLLocationCoordinate2D coordinate;
//        
//        if (i % 4 == 0) {
//            
//			coordinate.latitude  = mapView.centerCoordinate.latitude  + (float)(arc4random() % 8) / 1000;
//            coordinate.longitude = mapView.centerCoordinate.longitude + (float)(arc4random() % 8) / 1000;
//            annotation.type = AnnotationOneStarType;
//			
//        annotation.coordinate = coordinate;
//        annotation.title = [NSString stringWithFormat:@"Title %i", i];
//        annotation.subtitle = [NSString stringWithFormat:@"距離： %0.0f m", MapDistanceBetweenCoordinates(hereIam.center, coordinate)];
//        [annotations addObject:annotation];
//		
//        [annotation release];
//
//    }
//
//	[mapView addAnnotations:annotations];
//
//
//	
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




- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {

	NSLog(@"controller did change content, to %@", self.fetchedResultsController.fetchedObjects);

}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {

}

- (void) mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated {

	NSFetchRequest *newFetchRequest = [[self class] fetchRequestInContext:self.managedObjectContext forCoordinateRegion:aMapView.region];
	
	if (self.fetchedResultsController.cacheName)
		[[self.fetchedResultsController class] deleteCacheWithName:self.fetchedResultsController.cacheName];

	self.fetchedResultsController.fetchRequest.predicate = newFetchRequest.predicate;
	
	NSError *fetchingError = nil;
	if (![self.fetchedResultsController performFetch:&fetchingError])
		NSLog(@"Error fetching: %@", fetchingError);
	
	[self refreshAnnotations];
	
}

- (void) refreshAnnotations {

	NSArray *shownHotels = self.fetchedResultsController.fetchedObjects;
	NSMutableArray *shownAnnotations = [NSMutableArray arrayWithCapacity:[shownHotels count]];
	for (unsigned int i = 0; i < [shownHotels count]; i++)
		[shownAnnotations addObject:[NSNull null]];

	NSArray *removedAnnotations = [self.mapView.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithBlock: ^ (MyAnnotation *anAnnotation, NSDictionary *bindings) {
		
		if (![anAnnotation isKindOfClass:[MyAnnotation class]])
			return (BOOL)NO;
		
		NSUInteger hotelIndex = [shownHotels indexOfObject:anAnnotation.representedObject];
		if (hotelIndex == NSNotFound)
			return (BOOL)YES;
		
		[shownAnnotations replaceObjectAtIndex:hotelIndex withObject:anAnnotation];
		return (BOOL)NO;
		
	}]];

	[self.mapView removeAnnotations:removedAnnotations];
	
	[shownHotels enumerateObjectsUsingBlock: ^ (Hotel *aHotel, NSUInteger idx, BOOL *stop) {
	
		MyAnnotation *annotation = [shownAnnotations objectAtIndex:idx];
		if (![annotation isKindOfClass:[MyAnnotation class]]) {
			annotation = [[[MyAnnotation alloc] init] autorelease];
			[shownAnnotations replaceObjectAtIndex:idx withObject:annotation];
		}
		
		annotation.coordinate = (CLLocationCoordinate2D) {
			[aHotel.latitude doubleValue],
			[aHotel.longitude doubleValue]
		};
		
		annotation.title = aHotel.displayName;
		annotation.type = aHotel.areaCode.integerValue;
		annotation.costStay = aHotel.costStay;
		annotation.costRest = aHotel.costRest;
		annotation.representedObject = aHotel;

	}];
	
	
	[self.mapView addAnnotations:shownAnnotations];
	
}


- (MKAnnotationView *) mapView:(MKMapView *)aMapView viewForAnnotation:(MyAnnotation *)annotation{

	if (![annotation isKindOfClass:[MyAnnotation class]]) {
	
		NSLog(@"%s: Handle user location annotation view", __PRETTY_FUNCTION__);
		return nil;
	
	}

	NSString * identifier = [[self class] imageNameForAnnotationType:annotation.type];
	

	CombineImages *temp=[[CombineImages alloc] init];


	//UIImage *newImage = [temp addText2Image:[UIImage imageNamed:identifier] addText:( annotation.costStay == 0 ) ?  [NSString stringWithFormat:@"(不提供)"]:[NSString stringWithFormat:@"%@起..",annotation.costStay] ];
	UIImage *newImage = [temp addText2Image:[UIImage imageNamed:identifier] addText:( annotation.costStay.integerValue == 0 ) ?  [NSString stringWithFormat:@"(?)"]:[NSString stringWithFormat:@"NT:%@",annotation.costStay] ];


	MKPinAnnotationView *pinView = (MKPinAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	
	if (!pinView) {
	
		pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
		pinView.canShowCallout = YES;
		pinView.image = newImage;
		//pinView.image = [UIImage imageNamed:identifier];
		pinView.calloutOffset = (CGPoint){ 0, 0 };

	}
	pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	pinView.LeftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeCustom];
	//pinView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image.png"]];
	pinView.annotation = annotation;
	newImage = nil;
    return pinView;

}


-(void)mapView:(MKMapView *)mapView annotationView:(MyAnnotation *)pinView calloutAccessoryControlTapped:(UIControl *)control{
	NSLog(@"switch to detail view%@",[pinView description]);
	//[pinView.coordinate.latitude ]
	NSLog(@"latitude : %@",pinView.description);
	
	
//    [[[[UIAlertView alloc] initWithTitle:pinView.title 
//                                 message:pinView.subtitle 
//                                delegate:nil
//                       cancelButtonTitle:@"OK"
//                       otherButtonTitles:nil, nil] 
//      autorelease];
//	
	
	
	


}

+ (NSString *) imageNameForAnnotationType:(MyAnnotationType)aType {

    switch (aType) {
		case AnnotationOneStarType: {
			return @"bubble02";
			break;
		}		
		case AnnotationTwoStarsType: {
			return @"bubble05";
			break;
		}
		
		case AnnotationThreeStarsType: {
			return @"bubble07";
			break;
		}
		case AnnotationFourStarsType: {
			return @"bubble08";
			break;
		}
		case AnnotationFiveStarsType: {
			return @"bubble11";
			break;
		}
		default:
		case AnnotationUnknownType: {
			return @"bubble10";
			break;
		}
    }
	
	return nil;

}


@end
