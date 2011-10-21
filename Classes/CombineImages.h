//
//  CombineImages.h
//  Map
//
//  Created by App on 2011/10/19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(MapAdditions)

- (UIImage *) compositeImageWithOverlayText:(NSString *)theText;
- (UIImage *) compositeImageWithOverlayImage:(UIImage *)image2;
- (UIImage *) scaledImageWithSize:(CGSize)reSize;

@end