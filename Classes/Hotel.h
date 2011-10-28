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
@property (nonatomic, retain) NSString * displayName;			//旅館顯示名稱
@property (nonatomic, retain) NSNumber * latitude;				//旅館經緯度
@property (nonatomic, retain) NSNumber * longitude;				//旅館經緯度
@property (nonatomic, retain) NSNumber * costStay;				//旅館住宿價格
@property (nonatomic, retain) NSNumber * costRest;				//旅館休息價格

@property (nonatomic, retain) NSString * address;				//旅館地址
@property (nonatomic, retain) NSNumber * areaCode;				//行政區號碼
@property (nonatomic, retain) NSString * areaName;				//行政區名稱
@property (nonatomic, retain) NSString * descriptionHTML;		//旅館簡介HTML

@property (nonatomic, retain) NSString * email;					//旅館電子郵件
@property (nonatomic, retain) NSString * fax;					//旅館傳真號碼
@property (nonatomic, retain) NSString * tel;					//旅館聯絡電話

@property (nonatomic, retain) NSNumber * odIdentifier;			//旅館編號（PK）
@property (nonatomic, retain) NSString * ttIdentifier;			//旅館編號（對應台北旅遊網）

@property (nonatomic, retain) NSNumber * hotelType;				//旅館種類（決定顯示圖片）

@property (nonatomic, retain) NSDate   * xmlUpdateDate;			//旅館XML更新日期
@property (nonatomic, retain) NSDate   * modificationDate;		//旅館資料更新時間
@property (nonatomic, retain) NSString * imagesArray;			//旅館影像陣列

@property (nonatomic, retain) NSString * xurl;					//旅館定房網址

@property (nonatomic, retain) NSNumber * favorites;				//加入我的最愛
@property (nonatomic, retain) NSDate   * useDate;				//旅館歷程紀錄
@end
