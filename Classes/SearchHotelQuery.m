//
//  SearchHotelQuery.m
//  Map
//
//  Created by App on 2011/10/24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import "SearchHotelQuery.h"





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


-(id)resultSearchInSearch:(NSArray *)arrayContent arrayFilter:(NSArray *)arrayFilter{
//arrayContent過濾arrayFilter中的所有item。
//NSArray *arrayFilter = [NSArray arrayWithObjects:@"abc1", @"abc2", nil];
//NSArray *arrayContent = [NSArray arrayWithObjects:@"a1", @"abc1", @"abc4", @"abc2", nil];
//NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"SELF in %@", arrayFilter];
NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", arrayFilter];
NSMutableArray *resultArray =[[[NSMutableArray alloc]init ]autorelease];
[resultArray filterUsingPredicate:thePredicate];
return resultArray;
}

//列出歷程
-(id)showHistoryList
{
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"useDate != null"];
	fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"useDate" ascending:NO],nil];
  
	NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
	//資料筆數>0
	if ([self.managedObjectContext countForFetchRequest:fetchRequest error:nil] > 0)
	{
		NSUInteger numberOfApartments = [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
		NSLog(@"找出的資料筆數= %d",numberOfApartments);
		//移到第一筆
		NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];
			
	}else{
		NSLog(@"沒有資料");
	}
	return fetchRequestDataArray;
}
//列出我的最愛


//-(id)showFavoritesList:(CLLocationCoordinate2D *)userLocation
-(id)showFavoritesList
{

	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"favorites == 1"];
  
	NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
	NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];

	//找出的資料筆數
	NSUInteger numberOfApartments = [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
	NSLog(@"找出的資料筆數= %d",numberOfApartments);

	//return YES;
	return [self arrayToHotelClass:resultDataEntity];

}
//轉成HotelClass
-(id)arrayToHotelClass:(NSManagedObject *)inputArray{
	NSLog(@"arrayToHotelClass");
	Hotel *hotelList = [[[Hotel alloc] init] autorelease];
	hotelList.address			= [inputArray valueForKey:@"address"];
	hotelList.areaCode			= [inputArray valueForKey:@"areaCode"];
	hotelList.areaName			= [inputArray valueForKey:@"areaName"];
	hotelList.descriptionHTML	= [inputArray valueForKey:@"descriptionHTML"];
	hotelList.displayName		= [inputArray valueForKey:@"displayName"];
	hotelList.email				= [inputArray valueForKey:@"email"];
	hotelList.fax				= [inputArray valueForKey:@"fax"];
	hotelList.tel				= [inputArray valueForKey:@"tel"];
	hotelList.latitude			= [inputArray valueForKey:@"latitude"];
	hotelList.longitude			= [inputArray valueForKey:@"longitude"];
	hotelList.modificationDate	= [inputArray valueForKey:@"modificationDate"];
	hotelList.odIdentifier		= [inputArray valueForKey:@"odIdentifier"];
	hotelList.ttIdentifier		= [inputArray valueForKey:@"ttIdentifier"];
	hotelList.hotelType			= [inputArray valueForKey:@"hotelType"];
	hotelList.xmlUpdateDate		= [inputArray valueForKey:@"xmlUpdateDate"];
	hotelList.imagesArray		= [inputArray valueForKey:@"imagesArray"];
	hotelList.favorites			= [inputArray valueForKey:@"favorites"];
	hotelList.costStay			= [inputArray valueForKey:@"costStay"];
	hotelList.costRest			= [inputArray valueForKey:@"costRest"];
	hotelList.useDate			= [inputArray valueForKey:@"useDate"];
	hotelList.xurl				= [inputArray valueForKey:@"xurl"];	
	NSLog(@"hotelList.favorites = %@",hotelList.favorites);
	NSLog(@"hotelList.displayName = %@",hotelList.displayName);	
	return hotelList;
}


//用旅館ID修改[useDate]欄位(日期)
-(id)inputHotelIDAndModifyuseDate:(NSString*)inputHotelID
{
  int randomNumber = 1+ arc4random() %(100);
  NSLog(@"inputHotelID = %d" , randomNumber);
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
  
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"odIdentifier == %d",randomNumber];
  
  NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];
  
	//找出的資料筆數
	NSUInteger numberOfApartments = [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
	NSLog(@"找出的資料筆數= %d",numberOfApartments);
  NSLog(@"now:%@", [NSDate date]);
	NSLog(@"CoreData:%@",[resultDataEntity valueForKey:@"displayName"]);
  NSLog(@"原先資料:%@",[resultDataEntity valueForKey:@"useDate"]);
  //if ([resultDataEntity valueForKey:@"useDate"] == nil)
  //{
    
    [resultDataEntity setValue:[NSDate date] forKey:@"useDate"];
    NSLog(@"取出資料:%@",[resultDataEntity valueForKey:@"useDate"]);
    NSError *savingError = nil;
    if (![self.managedObjectContext save:&savingError])
      NSLog(@"Error saving: %@", savingError);
  //}else{
  //  NSLog(@"資料不改變");
  //}  
	return YES;
}

//用旅館ID刪除[useDate]欄位(日期)
-(BOOL)inputHotelIDAndDeleteuseDate:(NSString*)inputHotelID
{

	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
  
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"odIdentifier == %d",inputHotelID];
  
  NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];
  
	//找出的資料筆數
	NSUInteger numberOfApartments = [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
	NSLog(@"找出的資料筆數= %d",numberOfApartments);
	NSLog(@"CoreData:%@",[resultDataEntity valueForKey:@"displayName"]);
  NSLog(@"原先資料:%@",[resultDataEntity valueForKey:@"useDate"]);
  if ([resultDataEntity valueForKey:@"useDate"] != nil)
  {

    [resultDataEntity setValue:nil forKey:@"useDate"];
    NSLog(@"取出資料:%@",[resultDataEntity valueForKey:@"useDate"]);
    NSError *savingError = nil;
    if (![self.managedObjectContext save:&savingError])
      NSLog(@"Error saving: %@", savingError);
  }else{
        NSLog(@"資料不改變");
  }  
	return YES;
}



//用旅館ID修改我的最愛欄位(true/false)
-(BOOL)inputHotelIDAndModifyFavorites:(NSNumber *)inputHotelID
{

	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"odIdentifier == %d",inputHotelID];
  
  NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];

	//找出的資料筆數
	NSUInteger numberOfApartments = [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
	NSLog(@"找出的資料筆數= %d",numberOfApartments);
	NSLog(@"CoreData:%@",[resultDataEntity valueForKey:@"displayName"]);
	[resultDataEntity setValue:[NSNumber numberWithBool:([[resultDataEntity valueForKey:@"favorites"]boolValue] == YES)?NO:YES] forKey:@"favorites"];
  
//[self.managedObjectContext save];  
	
	NSError *savingError = nil;
	if (![self.managedObjectContext save:&savingError])
		NSLog(@"Error saving: %@", savingError);

	return YES;
	//return NO;

}

//用旅館ID列出所有欄位(true/false)
-(Hotel *)inputHotelIDAndListData:(NSString*)inputHotelID
{
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"odIdentifier == %d",inputHotelID];   
  NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];
  
	//找出的資料筆數
	//NSUInteger numberOfApartments = [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];

  Hotel *hotelList = [[[Hotel alloc] initWithEntity:fetchRequest.entity insertIntoManagedObjectContext:self.managedObjectContext] autorelease];

	hotelList.address			= [resultDataEntity valueForKey:@"address"];
	hotelList.areaCode			= [resultDataEntity valueForKey:@"areaCode"];
	hotelList.areaName			= [resultDataEntity valueForKey:@"areaName"];
	hotelList.descriptionHTML	= [resultDataEntity valueForKey:@"descriptionHTML"];
	hotelList.displayName		= [resultDataEntity valueForKey:@"displayName"];
	hotelList.email				= [resultDataEntity valueForKey:@"email"];
	hotelList.fax				= [resultDataEntity valueForKey:@"fax"];
	hotelList.tel				= [resultDataEntity valueForKey:@"tel"];
	hotelList.latitude			= [resultDataEntity valueForKey:@"latitude"];
	hotelList.longitude			= [resultDataEntity valueForKey:@"longitude"];
	hotelList.modificationDate	= [resultDataEntity valueForKey:@"modificationDate"];
	hotelList.odIdentifier		= [resultDataEntity valueForKey:@"odIdentifier"];
	hotelList.ttIdentifier		= [resultDataEntity valueForKey:@"ttIdentifier"];
	hotelList.hotelType			= [resultDataEntity valueForKey:@"hotelType"];
	hotelList.xmlUpdateDate		= [resultDataEntity valueForKey:@"xmlUpdateDate"];
	hotelList.imagesArray		= [resultDataEntity valueForKey:@"imagesArray"];
	hotelList.favorites			= [resultDataEntity valueForKey:@"favorites"];
	hotelList.costStay			= [resultDataEntity valueForKey:@"costStay"];
	hotelList.costRest			= [resultDataEntity valueForKey:@"costRest"];
	hotelList.useDate			= [resultDataEntity valueForKey:@"useDate"];
	hotelList.xurl				= [resultDataEntity valueForKey:@"xurl"];
  NSLog(@"hotelList.favorites = %@",hotelList.favorites);
  return hotelList;
    
}

//用旅館ID列出所有欄位(true/false)然後更新歷程欄位
-(id)inputHotelIDAndListDataAndChange:(NSString*)inputHotelID
{
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"odIdentifier == %d",inputHotelID];   
  NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];
  
	//找出的資料筆數
	NSUInteger numberOfApartments = [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
  
  NSLog(@"原先資料:%@",[resultDataEntity valueForKey:@"useDate"]);
  //更新為現在時間
  [resultDataEntity setValue:[NSDate date] forKey:@"useDate"];
  NSLog(@"取出資料:%@",[resultDataEntity valueForKey:@"useDate"]);
  NSError *savingError = nil;
	if (![self.managedObjectContext save:&savingError])
		NSLog(@"Error saving: %@", savingError);
  
  Hotel *hotelList = [[[Hotel alloc] initWithEntity:fetchRequest.entity insertIntoManagedObjectContext:self.managedObjectContext] autorelease];
  
	hotelList.address			= [resultDataEntity valueForKey:@"address"];
	hotelList.areaCode			= [resultDataEntity valueForKey:@"areaCode"];
	hotelList.areaName			= [resultDataEntity valueForKey:@"areaName"];
	hotelList.descriptionHTML	= [resultDataEntity valueForKey:@"descriptionHTML"];
	hotelList.displayName		= [resultDataEntity valueForKey:@"displayName"];
	hotelList.email				= [resultDataEntity valueForKey:@"email"];
	hotelList.fax				= [resultDataEntity valueForKey:@"fax"];
	hotelList.tel				= [resultDataEntity valueForKey:@"tel"];
	hotelList.latitude			= [resultDataEntity valueForKey:@"latitude"];
	hotelList.longitude			= [resultDataEntity valueForKey:@"longitude"];
	hotelList.modificationDate	= [resultDataEntity valueForKey:@"modificationDate"];
	hotelList.odIdentifier		= [resultDataEntity valueForKey:@"odIdentifier"];
	hotelList.ttIdentifier		= [resultDataEntity valueForKey:@"ttIdentifier"];
	hotelList.hotelType			= [resultDataEntity valueForKey:@"hotelType"];
	hotelList.xmlUpdateDate		= [resultDataEntity valueForKey:@"xmlUpdateDate"];
	hotelList.imagesArray		= [resultDataEntity valueForKey:@"imagesArray"];
	hotelList.favorites			= [resultDataEntity valueForKey:@"favorites"];
	hotelList.costStay			= [resultDataEntity valueForKey:@"costStay"];
	hotelList.costRest			= [resultDataEntity valueForKey:@"costRest"];
	hotelList.useDate			= [resultDataEntity valueForKey:@"useDate"];
	//hotelList.xurl				= [resultDataEntity valueForKey:@"xurl"];
  NSLog(@"hotelList.favorites = %@",hotelList.favorites);
  return hotelList;
  
  //return [self arrayToHotelClass:resultDataEntity];
  
}


//用旅館ID列出所有欄位(true/false)然後更新歷程欄位
-(id)inputKeyWordAndListData:(NSString*)inputHotelID
{
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"displayName like %d",inputHotelID];   
  NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];
  
	//找出的資料筆數
	NSUInteger numberOfApartments = [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
  
  NSLog(@"原先資料:%@",[resultDataEntity valueForKey:@"useDate"]);
  //更新為現在時間
  [resultDataEntity setValue:[NSDate date] forKey:@"useDate"];
  NSLog(@"取出資料:%@",[resultDataEntity valueForKey:@"useDate"]);
  NSError *savingError = nil;
	if (![self.managedObjectContext save:&savingError])
		NSLog(@"Error saving: %@", savingError);
  
  Hotel *hotelList = [[[Hotel alloc] initWithEntity:fetchRequest.entity insertIntoManagedObjectContext:self.managedObjectContext] autorelease];
  
	hotelList.address			= [resultDataEntity valueForKey:@"address"];
	hotelList.areaCode			= [resultDataEntity valueForKey:@"areaCode"];
	hotelList.areaName			= [resultDataEntity valueForKey:@"areaName"];
	hotelList.descriptionHTML	= [resultDataEntity valueForKey:@"descriptionHTML"];
	hotelList.displayName		= [resultDataEntity valueForKey:@"displayName"];
	hotelList.email				= [resultDataEntity valueForKey:@"email"];
	hotelList.fax				= [resultDataEntity valueForKey:@"fax"];
	hotelList.tel				= [resultDataEntity valueForKey:@"tel"];
	hotelList.latitude			= [resultDataEntity valueForKey:@"latitude"];
	hotelList.longitude			= [resultDataEntity valueForKey:@"longitude"];
	hotelList.modificationDate	= [resultDataEntity valueForKey:@"modificationDate"];
	hotelList.odIdentifier		= [resultDataEntity valueForKey:@"odIdentifier"];
	hotelList.ttIdentifier		= [resultDataEntity valueForKey:@"ttIdentifier"];
	hotelList.hotelType			= [resultDataEntity valueForKey:@"hotelType"];
	hotelList.xmlUpdateDate		= [resultDataEntity valueForKey:@"xmlUpdateDate"];
	hotelList.imagesArray		= [resultDataEntity valueForKey:@"imagesArray"];
	hotelList.favorites			= [resultDataEntity valueForKey:@"favorites"];
	hotelList.costStay			= [resultDataEntity valueForKey:@"costStay"];
	hotelList.costRest			= [resultDataEntity valueForKey:@"costRest"];
	hotelList.useDate			= [resultDataEntity valueForKey:@"useDate"];
  
  NSLog(@"hotelList.favorites = %@",hotelList.favorites);
  return hotelList;
  
}

-(void)test{
//  ，NSDictionary，NSValue，NSEnumerator基本操作
//  NSEnumerator *enumerator = [myMutableDict keyEnumerator];
//  id aKey = nil;
//  while ( (aKey = [enumerator nextObject]) != nil) {
//    id value = [myMutableDict objectForKey:anObject];
//    NSLog(@"%@: %@", aKey, value);
//  }
//  NSMutableDictionary *glossary = [NSMutableDictionary dictionary];
//  //Store three entries in the glossary
//  [glossary setObject: @"A class defined so other classes can inherit from it"
//               forkey: @"abstract class"];
//  [glossary setObject: @"To implement all the methods defined in a protocol"
//               forkey: @"adopt"];
//  [glossary setObject: @"Storing an object for later use"
//               forkey: @"archiving"];
//  for (NSString *key in glossary){
//    NSLog(@"%@:%@", key, [glossary objectForKey: key]);
//  }
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
}

@end

