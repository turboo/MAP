//
//  Hotel.h
//  Map
//
//  Created by App on 2011/10/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Hotel : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * areaCode;
@property (nonatomic, retain) NSString * areaName;
@property (nonatomic, retain) NSString * descriptionHTML;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate   * modificationDate;
@property (nonatomic, retain) NSNumber * odIdentifier;
@property (nonatomic, retain) NSString * ttIdentifier;

@property (nonatomic, retain) NSNumber * hotelType;
@property (nonatomic, retain) NSDate   * xmlUpdateDate;
@property (nonatomic, retain) NSString * imagesArray;
@property (nonatomic, retain) NSNumber * favorites;
@property (nonatomic, retain) NSNumber * costStay;
@property (nonatomic, retain) NSNumber * costRest;
@property (nonatomic, retain) NSDate   * useDate;
@end
