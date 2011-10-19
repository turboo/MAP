//
//  MADataStore.m
//  Map
//
//  Created by App on 2011/10/17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MADataStore.h"
#import <sqlite3.h>


@interface MADataStore ()

@property (nonatomic, readonly, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly, retain) NSManagedObjectModel *managedObjectModel;

@end


@implementation MADataStore
@synthesize persistentStoreCoordinator, managedObjectModel;

+ (id) defaultStore {

	static id returnedObject = nil;
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^{
		returnedObject = [[self alloc] init];
	});

	return returnedObject;

}

- (void) dealloc {

	[persistentStoreCoordinator release];
	[managedObjectModel release];
	[super dealloc];

}

- (NSManagedObjectModel *) managedObjectModel {

	if (managedObjectModel)
		return managedObjectModel;
		
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OKHotel" withExtension:@"momd"];
		
	managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] autorelease];
	
	return managedObjectModel;

}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {

	if (persistentStoreCoordinator)
		return persistentStoreCoordinator;
	
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	
	NSString *storeName = @"Map.sqlite";
	NSString *storePath = [documentsDirectory stringByAppendingPathComponent:storeName];
	
	NSError *storeAddingError = nil;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:storePath] options:[NSDictionary dictionaryWithObjectsAndKeys:
	
		(id)kCFBooleanTrue, NSMigratePersistentStoresAutomaticallyOption,
		(id)kCFBooleanTrue, NSInferMappingModelAutomaticallyOption,
	
	nil] error:&storeAddingError]) {
	
		NSLog(@"error adding store: %@", storeAddingError);
	
	};
	
	return persistentStoreCoordinator;

}

- (NSManagedObjectContext *) disposableMOC {

	NSManagedObjectContext *returnedContext = [[[NSManagedObjectContext alloc] init] autorelease];
	
	returnedContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
	
	return returnedContext;

}

+ (BOOL) hasPerformedInitialImport {

	return [[NSUserDefaults standardUserDefaults] boolForKey:kMADataStore_hasPerformedInitialImport];

}

- (void) importData {

	NSManagedObjectContext *context = [self disposableMOC];
	
	NSURL *importedDatabaseURL = [[NSBundle mainBundle] URLForResource:@"OKHotel" withExtension:@"db"];	
	sqlite3 *importedDatabase = nil;
	const char *importedDatabasePathUTF8String = [[importedDatabaseURL path] UTF8String];
	
	if (SQLITE_OK != sqlite3_open(importedDatabasePathUTF8String, &importedDatabase))
		return;
	
	void (^cleanup)(BOOL) = ^ (BOOL shouldSave) {

		sqlite3_close(importedDatabase);
		
		NSError *savingError = nil;
		if (![context save:&savingError])
			NSLog(@"Error saving: %@", savingError);
	
	};
	
	
	const char *query = "SELECT * FROM HotelList";
	__block sqlite3_stmt *statement =nil;

	if (SQLITE_OK != sqlite3_prepare_v2(importedDatabase, query, -1, &statement, NULL)) {
		cleanup(NO);
		return;
	}
		
	NSEntityDescription *hotelEntity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:context];

	NSNumber * (^fromBool)(int) = ^ (int aColumn) {
		return [NSNumber numberWithInt:sqlite3_column_bytes(statement, aColumn)];
	};	
	NSNumber * (^fromInt)(int) = ^ (int aColumn) {
		return [NSNumber numberWithInt:sqlite3_column_int(statement, aColumn)];
	};
	NSNumber * (^fromDouble)(int) = ^ (int aColumn) {
		return [NSNumber numberWithDouble:sqlite3_column_double(statement, aColumn)];
	};
	NSString * (^fromText)(int) = ^ (int aColumn) {
		return (NSString *)[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, aColumn)];
	};
	NSDate * (^fromDate)(int) = ^ (int aColumn) {
		static NSString * const kDateFormatter = @"MADataStoreImportingDateFormatter";		
		NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
		NSDateFormatter *modificationDateFormatter = [threadDictionary objectForKey:kDateFormatter];
		if (!modificationDateFormatter) {
			modificationDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[modificationDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			[threadDictionary setObject:modificationDateFormatter forKey:kDateFormatter];
		}
		return [modificationDateFormatter dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, aColumn)]];
	};

	while (SQLITE_ROW == sqlite3_step(statement)) {
		
		Hotel *insertedHotel = [[[Hotel alloc] initWithEntity:hotelEntity insertIntoManagedObjectContext:context] autorelease];
		
		insertedHotel.odIdentifier		= fromInt(0);	
		insertedHotel.displayName		= fromText(1);
		insertedHotel.fax				= fromText(2);
		insertedHotel.tel				= fromText(3);
		insertedHotel.address			= fromText(4);
		insertedHotel.longitude			= fromDouble(5);
		insertedHotel.latitude			= fromDouble(6);
		insertedHotel.ttIdentifier		= fromText(7);
		insertedHotel.descriptionHTML	= fromText(8);
		insertedHotel.areaCode			= fromInt(9);
		insertedHotel.areaName			= fromText(10);
		insertedHotel.modificationDate	= fromDate(11);
		insertedHotel.email				= fromText(12);

/*		insertedHotel.hotelType			= fromInt(13);
		insertedHotel.xmlUpdateDate		= fromDate(14);
		insertedHotel.imagesArray		= fromText(15);
		insertedHotel.favorites			= fromBool(16);
		insertedHotel.costStay			= fromInt(17);				
		insertedHotel.costRest			= fromInt(18);		
*/
//		NSLog(@"costStay:%d , costRest:%d " ,fromInt(17),fromInt(18) );
		

	}
	
	BOOL didFinalize = (SQLITE_OK == sqlite3_finalize(statement));
	cleanup(didFinalize);
	
	if (didFinalize) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMADataStore_hasPerformedInitialImport];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}

}


- (void) test {

	NSLog(@"start select Hotel Data "); 
	Hotel *thisHotel=(Hotel *)[NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:[self managedObjectContext]]; 
	thisHotel.displayName=@"康華大飯店";

	NSError *error;

	if (![[self managedObjectContext] save:&error]) { 
		NSLog(@"error!"); 
	}else { 
		NSLog(@"save data ok."); 
	}

	NSFetchRequest *request=[[NSFetchRequest alloc] init]; 
	NSEntityDescription *entity=[NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:[self managedObjectContext]]; 
	[request setEntity:entity];

	NSArray *results=[[[self managedObjectContext] executeFetchRequest:request error:&error] copy];

	for (Hotel *p in results) { 
		NSLog(@">> p.odIdentifier: %i p.displayName: %@",p.odIdentifier,p.displayName); 
	}	

}

@end
