//
//  MyAnnotation.h
//  Map
//
//  Created by Lawrence on 16/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#ifndef __MyAnnotation__
#define __MyAnnotation__

enum {
    
    AnnotationUnknownType = 0,
    AnnotationOneStarType,
    AnnotationTwoStarsType,
    AnnotationThreeStarsType,
    AnnotationFourStarsType,
    AnnotationFiveStarsType

}; typedef int MyAnnotationType;

#endif

@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *subtitle;
@property (nonatomic, readwrite, assign) MyAnnotationType type;

@end
