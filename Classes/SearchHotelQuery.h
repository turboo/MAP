//
//  SearchHotelQuery.h
//  Map
//
//  Created by App on 2011/10/24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Hotel.h"
#import "MADataStore.h"

@interface SearchHotelQuery : NSObject



@property (nonatomic, readwrite, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite, retain) NSFetchedResultsController *fetchedResultsController;


+ (NSFetchRequest *) fetchRequestInContext:(NSManagedObjectContext *)aContext forPredicateString:(NSString *)PredicateString forSortColumn:(NSString *)SortColumn;
//轉成HotelClass
-(id)arrayToHotelClass:(NSManagedObject *)inputArray;
//列出歷程
-(id)showHistoryList;
//列出我的最愛
-(id)showFavoritesList;
//用旅館ID修改[useDate]欄位(日期)
-(id)inputHotelIDAndModifyuseDate:(NSString*)HotelID;
//用旅館ID刪除[useDate]欄位(日期)
-(BOOL)inputHotelIDAndDeleteuseDate:(NSString*)HotelID;
//用旅館ID修改我的最愛欄位(true/false)
-(BOOL)inputHotelIDAndModifyFavorites:(NSNumber *)HotelID;
//用旅館ID列出所有欄位(true/false)
-(id)inputHotelIDAndListData:(NSString*)HotelID;
//用旅館ID列出所有欄位(true/false)然後更新歷程欄位
-(id)inputHotelIDAndListDataAndChange:(NSString*)inputHotelID;
@end


