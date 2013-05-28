//
//  RGLocationController.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/27/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGLocationManager.h"

@interface RGLocationManager ()

@property(nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation RGLocationManager

- (void) startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void) stopUpdatingLocation
{
    if (_locationManager) {
        
        [_locationManager stopUpdatingLocation];
        _locationManager = nil;
    }
}

- (CLLocationManager*) locationManager
{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = 10.0f;
        _locationManager.delegate = self;
    }
    
    return _locationManager;
}

#pragma mark - Corelocation Delegate

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations objectAtIndex:0];
    
    [self.delegate locationController:self didUpdateLocation:location];
    
//
//    [self updateLabel:_locationLabel withLocationInformation:location andBaseString:@"Start digging :\n"];
//    
//
//    [self updateLabel:_targetLabel withLocationInformation:antipodeLocation andBaseString:@"End up at :\n"];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"didFailWithError: %@", error);
}

@end
