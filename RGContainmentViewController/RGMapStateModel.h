//
//  RGMapStateModel.h
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/24/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^GeoCompletionHandler)(NSString *string);

@interface RGMapStateModel : NSObject

@property CLLocation *location;
@property NSString *annotationImagePath;
@property(nonatomic, copy) GeoCompletionHandler geoCompletionHandler;

+ (CLLocation*) antipodeFromLocation:(CLLocation*) location;
- (void) reverseGeoCodeLocation:(CLLocation*) location withCompletionBlock:(GeoCompletionHandler) geoCompletionHandler;

@end
