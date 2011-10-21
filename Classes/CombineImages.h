//
//  CombineImages.h
//  Map
//
//  Created by App on 2011/10/19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CombineImages : NSObject

@property(nonatomic,retain)UIImage *theImage;
@property(nonatomic,retain)NSString *theText;


- (UIImage *)addText2Image:(UIImage *)theImage addText:(NSString *)theText;
- (UIImage *)Combine2Images:(UIImage *)image1 toImage:(UIImage *)image2;
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
@end