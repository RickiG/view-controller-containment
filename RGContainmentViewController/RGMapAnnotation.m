//
//  RGMapAnnotation.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/24/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGMapAnnotation.h"

@implementation RGMapAnnotation

- (void) updateCoordinate:(CLLocationCoordinate2D) newCoordinate
{
    _coordinate = newCoordinate;
}

- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

@end
