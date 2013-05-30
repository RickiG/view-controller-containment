//
//  CLLocation+Utilities.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/30/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "CLLocation+Utilities.h"

@implementation CLLocation (Utilities)

- (CLLocation*) antipode
{
    CLLocationDegrees newLatitude;
    CLLocationDegrees newLongitude;
    
    double longitudeCorrection = -180.0;
    
    if (self.coordinate.longitude < 0.0)
        longitudeCorrection *= -1.0;
    
    newLatitude = self.coordinate.latitude * -1.0f;
    newLongitude = self.coordinate.longitude + longitudeCorrection;
    
    CLLocation *antipodeLocation = [[CLLocation alloc] initWithLatitude:newLatitude longitude:newLongitude];
    
    return antipodeLocation;
}

@end
