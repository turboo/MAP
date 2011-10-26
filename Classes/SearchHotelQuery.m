//
//  SearchHotelQuery.m
//  Map
//
//  Created by App on 2011/10/24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "SearchHotelQuery.h"
#import "Hotel.h"
#import "MADataStore.h"




@implementation SearchHotelQuery


@synthesize managedObjectContext, fetchedResultsController;


+ (NSFetchRequest *) fetchRequestInContext:(NSManagedObjectContext *)aContext forPredicateString:(NSString *)PredicateString forSortColumn:(NSString *)SortColumn {

	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:aContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:PredicateString];
	fetchRequest.sortDescriptors = [NSArray arrayWithObjects:
	[NSSortDescriptor sortDescriptorWithKey:SortColumn ascending:YES],nil];
	//找出的資料筆數
	//NSUInteger numberOfApartments = [aContext countForFetchRequest:fetchRequest error:nil];
	return fetchRequest;

}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (!self)
		return nil;
	
	self.managedObjectContext = [[MADataStore defaultStore] disposableMOC];
	self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:((^ {
		return [[self class] fetchRequestInContext:self.managedObjectContext forPredicateString:@"" forSortColumn:@"" ];
	})()) managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil] autorelease];
	
	self.fetchedResultsController.delegate = self;
	
	NSError *fetchingError = nil;
	if (![self.fetchedResultsController performFetch:&fetchingError])
		NSLog(@"Error fetching: %@", fetchingError);
			
	return self;

}

- (void) dealloc {

//	[persistentStoreCoordinator release];
//	[managedObjectModel release];
	[super dealloc];

}

//- (NSManagedObjectModel *) managedObjectModel {
//
//	if (managedObjectModel)
//		return managedObjectModel;
//		
//	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OKHotel" withExtension:@"momd"];
//		
//	managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] autorelease];
//	
//	return managedObjectModel;
//
//}



- (id)init
{
NSLog(@"init");
    self = [super init];

    if (self) {
//        dataArray = [[NSMutableArray alloc]init];
//        Hotel = [[[Hotel alloc]init]autorelease];
		NSLog(@"disposableMOC");
		managedObjectContext = [[[MADataStore defaultStore] disposableMOC] retain];
		
    }
	
	
    return self;
}


//用旅館ID修改[useDate]欄位(日期)
-(id)inputHotelIDAndModifyuseDate:(NSString*)HotelID
{


    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *hotelEntity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	 
    [request setEntity:[NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"odIdentifier == %@",HotelID]];
    
    NSArray  *searchDataArray= [self.managedObjectContext executeFetchRequest:request error:nil];
    NSManagedObject *hotelDataEntity = [searchDataArray objectAtIndex:0];
    
    Hotel *hotelList = [[[Hotel alloc]init]autorelease];
	hotelList.favorites			= [hotelDataEntity valueForKey:@"favorites"];
	
//
//NSMutableSet *useDate = [person mutableSetValueForKey:@"children"]; //查询，可修改
//[children addObject:child];
//[children removeObject:childToBeRemoved];
//[[children managedObjectContext] deleteObject:childToBeRemoved]; //真正的删除
//NSSet *children = [person valueForKey:@"children"]; //查询，不可修改
//for (NSManagedObject *oneChild in children) {
//// do something
//
//	
    return hotelList;
    
}

//用旅館ID刪除[useDate]欄位(日期)
-(BOOL)inputHotelIDAndDeleteuseDate:(NSString*)HotelID
{
	


	//[[self managedObjectContext] deleteObject:Shop];

	return [self save];


}



//用旅館ID修改我的最愛欄位(true/false)
-(BOOL)inputHotelIDAndModifyFavorites:(NSNumber *)HotelID
{
NSLog(@"HotelID = %d" , HotelID);
	NSLog(@"1");
	//	self.managedObjectContext
	NSLog(@"2");
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	//NSEntityDescription *hotelEntity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	NSLog(@"3");
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"odIdentifier == %d",HotelID];
	//fetchRequest.predicate = [NSPredicate predicateWithFormat:@"favorites == 0"];
	NSLog(@"4");    
    NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    NSManagedObject *ResultDataEntity = [fetchRequestDataArray objectAtIndex:0];
	
	  
	//找出的資料筆數
	NSUInteger numberOfApartments = [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
	NSLog(@"找出的資料筆數= %d",numberOfApartments);
	
	 //[hotelEntity setValue:[NSNumber numberWithBool:YES] forKey:@"Favorites"];
	NSLog(@"5");
	NSLog(@"1 this Valus = %@" , [ResultDataEntity valueForKey:@"favorites"]);
	//[ResultDataEntity setValue:[NSNumber numberWithBool:[ResultDataEntity valueForKey:@"Favorites"]?NO:YES] forKey:@"Favorites"];
	
	if ([ResultDataEntity valueForKey:@"Favorites"] == YES)
		[ResultDataEntity setValue:[NSNumber numberWithBool:NO] forKey:@"Favorites"];
	else
		[ResultDataEntity setValue:[NSNumber numberWithBool:YES] forKey:@"Favorites"];
		
	NSLog(@"2 this Valus = %@" , [ResultDataEntity valueForKey:@"favorites"]);
	NSLog(@"6");
	//[self.managedObjectContext save];  
	
	NSError *savingError = nil;
	if (![self.managedObjectContext save:&savingError])
		NSLog(@"Error saving: %@", savingError);
	NSLog(@"3 this Valus = %@" , [ResultDataEntity valueForKey:@"favorites"]);
	NSLog(@"7"); 
	return YES;
	NSLog(@"8"); 
//	//return NO;

}

//用旅館ID列出所有欄位(true/false)
-(id)inputHotelIDAndListData:(NSString*)HotelID
{
	NSManagedObjectContext *context = [self disposableMOC];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *hotelEntity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:context];
	 
    [request setEntity:[NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"odIdentifier == %@",HotelID]];
    
    NSArray  *searchDataArray= [self.managedObjectContext executeFetchRequest:request error:nil];
    NSManagedObject *hotelDataEntity = [searchDataArray objectAtIndex:0];
    
    Hotel *hotelList = [[[Hotel alloc]init]autorelease];    

	hotelList.address			= [hotelDataEntity valueForKey:@"address"];
	hotelList.areaCode			= [hotelDataEntity valueForKey:@"areaCode"];
	hotelList.areaName			= [hotelDataEntity valueForKey:@"areaName"];
	hotelList.descriptionHTML	= [hotelDataEntity valueForKey:@"descriptionHTML"];
	hotelList.displayName		= [hotelDataEntity valueForKey:@"displayName"];
	hotelList.email				= [hotelDataEntity valueForKey:@"email"];
	hotelList.fax				= [hotelDataEntity valueForKey:@"fax"];
	hotelList.tel				= [hotelDataEntity valueForKey:@"tel"];
	hotelList.latitude			= [hotelDataEntity valueForKey:@"latitude"];
	hotelList.longitude			= [hotelDataEntity valueForKey:@"longitude"];
	hotelList.modificationDate	= [hotelDataEntity valueForKey:@"modificationDate"];
	hotelList.odIdentifier		= [hotelDataEntity valueForKey:@"odIdentifier"];
	hotelList.ttIdentifier		= [hotelDataEntity valueForKey:@"ttIdentifier"];
	hotelList.hotelType			= [hotelDataEntity valueForKey:@"hotelType"];
	hotelList.xmlUpdateDate		= [hotelDataEntity valueForKey:@"xmlUpdateDate"];
	hotelList.imagesArray		= [hotelDataEntity valueForKey:@"imagesArray"];
	hotelList.favorites			= [hotelDataEntity valueForKey:@"favorites"];
	hotelList.costStay			= [hotelDataEntity valueForKey:@"costStay"];
	hotelList.costRest			= [hotelDataEntity valueForKey:@"costRest"];
	hotelList.useDate			= [hotelDataEntity valueForKey:@"useDate"];

    return hotelList;
    
}


@end

