//
//  RGMapAnnotation.h
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/24/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RGMapAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;

- (void) updateCoordinate:(CLLocationCoordinate2D) newCoordinate;
- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
