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
        
        double northSouthDirection = -90.0;
        double eastWestDirection = -180.0;
        
        if (location.coordinate.latitude < 0.0)
            northSouthDirection *= -1.0;
        
        if (location.coordinate.longitude < 0.0)
            eastWestDirection *= -1.0;
            
        newLatitude = location.coordinate.latitude + northSouthDirection;
        newLongitude = location.coordinate.longitude + eastWestDirection;
        
        CLLocation *antipodeLocation = [[CLLocation alloc] initWithLatitude:newLatitude longitude:newLongitude];
        
        return antipodeLocation;
    }
    
    return nil;
}

#pragma mark - Reverse geolocation

- (void) reverseGeoCodeLocation:(CLLocation*) location withCompletionBlock:(GeoCompletionHandler) geoCompletionHandler
{
    self.geoCompletionHandler = geoCompletionHandler;
    
    [[[CLGeocoder alloc] init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (!error) {
            
            NSMutableString  *placeStr = [NSMutableString string];
            
            for (CLPlacemark *p in placemarks) {
                
                NSLog(@"%@", p.description);
                
                if (p.name != NULL)
                    [placeStr appendFormat:@"%@ ", p.name];
                if (p.locality != NULL)
                    [placeStr appendFormat:@"%@ ", p.locality];
                if (p.country != NULL)
                    [placeStr appendFormat:@"%@ ", p.country];
                
                _geoCompletionHandler((NSString*)placeStr);
            }
        }
    }];
}

@end
