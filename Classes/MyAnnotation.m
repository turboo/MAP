//
//  MyAnnotation.m
//  Map
//
//  Created by Lawrence on 16/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize coordinate, title, subtitle, type, representedObject;

- (void) dealloc {
    
    [title release];
    [subtitle release];
	
	[representedObject release];
    
    [super dealloc];
    
}

@end
