//
//  MADataStore.m
//  Map
//
//  Created by App on 2011/10/17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MADataStore.h"


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

	//	Create managed object context
	
	//	Open SQLite Database
	
	//	Iterate thru rows and create managed objects in the context
	
	//	Save the context
	
	return;
	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMADataStore_hasPerformedInitialImport];
	[[NSUserDefaults standardUserDefaults] synchronize];

}

@end
