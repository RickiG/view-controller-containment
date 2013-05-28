//
//  RGMapStateModel.h
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/24/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface RGMapStateModel : NSObject

@property CLLocation *location;
@property NSString *annotationImagePath;


+ (CLLocation*) antipodeFromLocation:(CLLocation*) location;

@end
