//
//  SearchHotelQuery.h
//  Map
//
//  Created by App on 2011/10/24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SearchHotelQuery : NSObject



@property (nonatomic, readwrite, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite, retain) NSFetchedResultsController *fetchedResultsController;


+ (NSFetchRequest *) fetchRequestInContext:(NSManagedObjectContext *)aContext forPredicateString:(NSString *)PredicateString forSortColumn:(NSString *)SortColumn;

-(id)inputHotelIDAndListData:(NSString*)HotelID;
-(id)inputHotelIDAndModifyFavorites:(NSString*)HotelID;
-(id)inputHotelIDAndModifyuseDate:(NSString*)HotelID;

@end


