//
//  RGMapControllerProtocol.h
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/27/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RGMapStateModel.h"

@protocol RGMapControllerProtocol <NSObject>

- (void) updateWithMapModel:(RGMapStateModel*) model;
- (NSString*) identifier;

@end
