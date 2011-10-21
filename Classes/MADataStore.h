//
//  MADataStore.h
//  Map
//
//  Created by App on 2011/10/17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MapDefines.h"
#import "Hotel.h"

@interface MADataStore : NSObject
{

}


+ (id) defaultStore;
- (NSManagedObjectContext *) disposableMOC;

+ (BOOL) hasPerformedInitialImport;
- (void) importData;

@end
