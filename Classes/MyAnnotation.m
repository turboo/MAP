//
//  MyAnnotation.m
//  Map
//
//  Created by Lawrence on 16/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize odIdentifier;
@synthesize coordinate, title, subtitle, type, representedObject;
@synthesize costRest,costStay;

- (void) dealloc {

    [odIdentifier release];
    [title release];
    [subtitle release];
	[costRest release];
	[costStay release];
	[representedObject release];
    
    [super dealloc];
    
}

@end
