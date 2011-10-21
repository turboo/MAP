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
#import "StreetView.h"
#import "testViewController.h"

#define BTN_MAP_TITLE @"MAP"
#define BTN_StreetView_TITLE @"StreetView"

static const int kMapViewController_Accessory_StreetView = 1;
static const int kMapViewController_Accessory_Disclose = 2;

@interface MapViewController () <NSFetchedResultsControllerDelegate>

- (void) showDetailsViewFromAnnotation:(id<MKAnnotation>)anAnnotation;
- (void) showStreetViewFromAnnotation:(id<MKAnnotation>)anAnnotation;

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
  
	MKPinAnnotationView *pinView = (MKPinAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	
	if (!pinView) {
		
		pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
		pinView.canShowCallout = YES;
		pinView.calloutOffset = CGPointZero;
		
		UIButton *leftCalloutButton = [UIButton buttonWithType:UIButtonTypeCustom];
		leftCalloutButton.tag = kMapViewController_Accessory_StreetView;
		[leftCalloutButton setImage:[UIImage imageNamed:@"StreetView"] forState:UIControlStateNormal];
		[leftCalloutButton sizeToFit];
		leftCalloutButton.frame = (CGRect){ 0, 0, 25, 25 };
		pinView.leftCalloutAccessoryView = leftCalloutButton;
		
		UIButton *rightCalloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		rightCalloutButton.tag = kMapViewController_Accessory_Disclose;
		pinView.rightCalloutAccessoryView = rightCalloutButton;

	}

	NSUInteger price = [annotation.costStay unsignedIntValue];
	
	pinView.image = [[UIImage imageNamed:identifier] compositeImageWithOverlayText:
		[NSString stringWithFormat:!price ?
			@"(未提供價格)" :
			//[[annotation.costStay stringValue] stringByAppendingFormat:@" 起"]
			@"NT:%5i↑",[annotation.costStay intValue] 
		]
	];
	
	pinView.annotation = annotation;
	
	return pinView;

}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView calloutAccessoryControlTapped:(UIControl *)control{

	switch (control.tag) {	
		
		case kMapViewController_Accessory_StreetView: {
			[self showStreetViewFromAnnotation:annotationView.annotation];
			break;
		}
		
		case kMapViewController_Accessory_Disclose: {
			[self showDetailsViewFromAnnotation:annotationView.annotation];
			break;
		}
	
	}

}

- (void) showDetailsViewFromAnnotation:(id<MKAnnotation>)anAnnotation {

	TestViewController *testViewController = [[[TestViewController alloc] init] autorelease];
	[self.navigationController pushViewController:testViewController animated:NO];

}

- (void) showStreetViewFromAnnotation:(id<MKAnnotation>)anAnnotation {

	StreetViewController *streetViewController = [[[StreetViewController alloc] initWithCoordinate:[anAnnotation coordinate]] autorelease];
	[self.navigationController pushViewController:streetViewController animated:YES];
  
}

+ (NSString *) imageNameForAnnotationType:(MyAnnotationType)aType {

	return (((NSString *[]){
		[AnnotationOneStarType] = @"bubble02",
		[AnnotationTwoStarsType] = @"bubble05",
		[AnnotationThreeStarsType] = @"bubble07",
		[AnnotationFourStarsType] = @"bubble08",
		[AnnotationFiveStarsType] = @"bubble11",
		[AnnotationUnknownType] = @"bubble10",
		[6] = @"bubble10",
		[7] = @"bubble10",
		[8] = @"bubble10",
		[9] = @"bubble10",
		[10] = @"bubble10",
		[11] = @"bubble10",
		[12] = @"bubble10",
	})[aType]);

}


@end
