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
	
	void (^cleanup)() = ^ {

		sqlite3_close(importedDatabase);
		
		NSError *savingError = nil;
		if (![context save:&savingError])
			NSLog(@"Error saving: %@", savingError);
	
	};
	
	
	const char *query = "SELECT * FROM HotelList";
	sqlite3_stmt *statement =nil;

	if (SQLITE_OK != sqlite3_prepare_v2(importedDatabase, query, -1, &statement, NULL)) {
		cleanup();
		return;
	}
	
	NSEntityDescription *hotelEntity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:context];

	while (SQLITE_ROW == sqlite3_step(statement)) {
		
		Hotel *insertedHotel = [[[Hotel alloc] initWithEntity:hotelEntity insertIntoManagedObjectContext:context] autorelease];
		
		//sqlite3_bind_double(statement, index, [dateObject timeIntervalSince1970]);
		//where dateObject is an NSDate*. Then, when getting the data out of the DB, use
		//[NSDate dateWithTimeIntervalSince1970:doubleValueFromDatabase];			
		//NSLog(@"Date (double) : %@" , [NSNumber numberWithDouble:(double)sqlite3_column_double(statement,11)]);
		//NSLog(@"Date (string) : %@" , [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)]);
		
		NSString *updateDate = [NSString stringWithFormat:@"%@ +0800",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)]];
		
		NSLog(@"Date (updateDate) : %@" , updateDate);

		// Convert string to date object
		NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init]autorelease];
		//[dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
		
		//[dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss zzzz"];
		NSDate *DateFromSQLite = [dateFormat dateFromString:updateDate];  
		[NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
		NSLog(@"Date (date) : %@",DateFromSQLite);


    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mma"];
    NSString *dateStr = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];


		insertedHotel.odIdentifier		= [NSNumber numberWithInt:(int )sqlite3_column_bytes16(statement, 0)];	
		insertedHotel.displayName		= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];		
		insertedHotel.fax				= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
		insertedHotel.tel				= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
		insertedHotel.address			= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
		insertedHotel.latitude			= [NSNumber numberWithDouble:(double )sqlite3_column_double(statement, 5)];
		insertedHotel.longitude			= [NSNumber numberWithDouble:(double )sqlite3_column_double(statement, 6)];
		insertedHotel.ttIdentifier		= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
		insertedHotel.descriptionHTML	= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
		insertedHotel.areaCode			= [NSNumber numberWithInt:(int )sqlite3_column_bytes16(statement, 9)];
		insertedHotel.areaName			= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,10)];
		insertedHotel.modificationDate	= [NSDate dateWithTimeIntervalSince1970:(double )sqlite3_column_double(statement,11)];
		insertedHotel.modificationDate	= DateFromSQLite;
		insertedHotel.email				= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12)];

	}

	sqlite3_finalize(statement);
	cleanup();
	
	return;
	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMADataStore_hasPerformedInitialImport];
	[[NSUserDefaults standardUserDefaults] synchronize];

}

@end
