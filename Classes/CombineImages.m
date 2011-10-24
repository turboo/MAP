//
//  CombineImages.m
//  Map
//
//  Created by App on 2011/10/19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CombineImages.h"

@implementation UIImage (MapAdditions)

- (UIImage *) compositeImageWithOverlayText:(NSString *)incomingText {

	UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
	UIFont *usedFont = [UIFont systemFontOfSize:12];
	
	//CGRect imageRect = (CGRect){ CGPointZero, self.size };

	CGRect imageRect = (CGRect){ CGPointZero,{self.size.width-10,self.size.height-10} };
	

	CGSize textSize = [incomingText sizeWithFont:usedFont];
	CGRect textRect = (CGRect){
		(CGPoint){
			roundf(0.5f * (CGRectGetWidth(imageRect) - textSize.width)),
			roundf(0.4f * (CGRectGetHeight(imageRect) - textSize.height))
		},
		textSize
	};
	
	[self drawInRect:imageRect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
	
	[incomingText drawInRect:textRect withFont:usedFont];
	
	UIImage *returnedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    return returnedImage;
	
}


- (UIImage *) compositeImageWithOverlayImage:(UIImage *)image2 { 

	UIGraphicsBeginImageContext(self.size);
	[self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
	[image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resultingImage;
	
}


- (UIImage *) scaledImageWithSize:(CGSize)reSize {

	UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
	[self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
	UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return reSizeImage;
	
}

@end
