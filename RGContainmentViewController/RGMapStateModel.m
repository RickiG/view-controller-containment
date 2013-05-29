//
//  RGMapStateModel.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/24/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGMapStateModel.h"

@implementation RGMapStateModel

+ (CLLocation*) antipodeFromLocation:(CLLocation*) location
{
    if (location) {
        
        CLLocationDegrees newLatitude;
        CLLocationDegrees newLongitude;
        
        double longitudeCorrection = -180.0;
        
        if (location.coordinate.longitude < 0.0)
            longitudeCorrection *= -1.0;
            
        newLatitude = location.coordinate.latitude * -1.0f;
        newLongitude = location.coordinate.longitude + longitudeCorrection;
        
        CLLocation *antipodeLocation = [[CLLocation alloc] initWithLatitude:newLatitude longitude:newLongitude];
        
        return antipodeLocation;
    }
    
    return nil;
}



@end
