//
//  RGMapViewController.h
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/23/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGMapStateModel.h"

typedef void (^GeoCompletionHandler)(NSString *string);

@protocol RGMapControllerProtocol <NSObject>

- (void) mapController:(id) controller didUpdateLocation:(CLLocation*) location;

@end

@interface RGMapViewController : UIViewController<RGMapControllerProtocol>

@property(nonatomic, assign) BOOL annotationIsDraggable;
@property(nonatomic, weak) id<RGMapControllerProtocol> delegate;
@property(nonatomic, strong) NSString *annotationImagePath;
@property(nonatomic, copy) GeoCompletionHandler geoCompletionHandler;

//KVO Observable properties
@property(nonatomic, strong) NSString *placemarkString;

- (void) updateAnnotationLocation:(CLLocation*) location;
- (NSString*) identifier;
- (void) reverseGeoCodeLocation:(CLLocation*) location withCompletionBlock:(GeoCompletionHandler) geoCompletionHandler;

@end
