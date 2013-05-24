//
//  RGMapStateModel.h
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/24/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RGMapStateModel : NSObject

//@property BOOL showUserLocation;
@property CLLocation *location;
@property UIImage *annotationImage;

@end
