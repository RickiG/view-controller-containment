//
//  RGLocationController.h
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/27/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol RGlocationProtocol <NSObject>

- (void) locationController:(id) controller didUpdateLocation:(CLLocation*) location;
- (void) locationController:(id) controller didFailWithError:(NSError*) error;

@end

@interface RGLocationManager : NSObject<CLLocationManagerDelegate>

@property(nonatomic, weak) id<RGlocationProtocol> delegate;


- (void) startUpdatingLocation;
- (void) stopUpdatingLocation;
                        
@end
