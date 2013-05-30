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
    CGAffineTransform transform;
    
    if (newDragState == MKAnnotationViewDragStateStarting) {
        transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    } else if (newDragState == MKAnnotationViewDragStateEnding) {
        transform = CGAffineTransformIdentity;
    }
    
    float duration = (animated ? 0.2f : 0.0f);

    [UIView animateWithDuration:duration animations:^{
       
        self.transform = transform;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
