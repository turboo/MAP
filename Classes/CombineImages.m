//
//  CombineImages.m
//  Map
//
//  Created by App on 2011/10/19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CombineImages.h"

@implementation CombineImages

@synthesize theImage,theText;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (UIImage *)addText2Image:(UIImage *)theImage addText:(NSString *)theText{

	NSLog(@"theText:%@" , theText);
	

    int w = theImage.size.width;
    int h = theImage.size.height; 
    //lon = h - lon;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), theImage.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1, 1);
	
    //char* text	= (char *)[theText cStringUsingEncoding:NSASCIIStringEncoding];// "05/05/09";
	char* text	= (char *)[theText cStringUsingEncoding:NSUTF8StringEncoding];
	
	//Arial
    CGContextSelectFont(context, "Arial", 12, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context,  kCGTextFill );
    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
	

 
    //rotate text
    //CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
	
    CGContextShowTextAtPoint(context, 3, 13, text, strlen(text));
	
	
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	
    return [UIImage imageWithCGImage:imageMasked];
}

- (UIImage *)addText2Image2:(UIImage *)theImage addText:(NSString *)theText{


}
@end
