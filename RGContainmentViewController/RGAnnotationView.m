//
//  RGAnnotationView.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/29/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGAnnotationView.h"

@implementation RGAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setDragState:(MKAnnotationViewDragState)newDragState animated:(BOOL)animated
{
    float duration = (animated ? 0.2f : 0.0f);
    
    if (newDragState == MKAnnotationViewDragStateStarting) {
        
        CGPoint dropPoint = CGPointMake(self.center.x,self.center.y-10);
        
        [UIView animateWithDuration:duration animations:^{
            
            self.center = dropPoint;
            
        } completion:^(BOOL finished) {
            
            self.dragState = MKAnnotationViewDragStateDragging;
        }];
        
    } else if (newDragState == MKAnnotationViewDragStateEnding) {
        
        CGPoint dropPoint = CGPointMake(self.center.x,self.center.y+10);
        
        [UIView animateWithDuration:duration animations:^{
            
            self.center = dropPoint;
            
        } completion:^(BOOL finished) {

            self.dragState = MKAnnotationViewDragStateEnding;
            self.dragState = MKAnnotationViewDragStateNone;
        }];
        
    } else if (newDragState == MKAnnotationViewDragStateCanceling) {
        
        CGPoint dropPoint = CGPointMake(self.center.x,self.center.y+10);
        
        [UIView animateWithDuration:duration animations:^{
            
            self.center = dropPoint;
            
        } completion:^(BOOL finished) {
            
            self.dragState = MKAnnotationViewDragStateNone;
        }];
    }
}

@end
