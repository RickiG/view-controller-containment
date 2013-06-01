//
//  RGMapViewController.h
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/23/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGMapStateModel.h"

@interface RGMapViewController : UIViewController

@property(nonatomic, strong) NSString *annotationImagePath;
@property(nonatomic, strong) NSString *locationString;
@property(nonatomic, strong) CLLocation *currentLocation;

- (void) updateAnnotationLocation:(CLLocation*) location;

@end
