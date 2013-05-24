//
//  RGViewController.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/22/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGContainerViewController.h"
#import "RGMapViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RGContainerViewController () {
    
    CGPoint targetViewOrigin;
    CGPoint locationViewOrigin;
}

@property (weak, nonatomic) IBOutlet UIView *targetMapView;
@property (weak, nonatomic) IBOutlet UIView *locationMapView;

@property RGMapViewController *targetMapViewController;
@property RGMapViewController *locationMapViewController;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation RGContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", self.childViewControllers.description);
    for (RGMapViewController *mapVC in self.childViewControllers) {
        NSString *restorationID = mapVC.restorationIdentifier;
        if ([restorationID isEqualToString:@"map_controller_target"]) {
            
            _targetMapViewController = mapVC;
            
        } else if ([restorationID isEqualToString:@"map_controller_location"]) {
            
            _locationMapViewController = mapVC;
        }
    }
    
    _targetMapView.layer.cornerRadius = 10.0f;
    _locationMapView.layer.cornerRadius = 10.0f;
    
    [_infoButton setBackgroundImage:[UIImage imageNamed:@"radar_enabled.png"] forState:UIControlStateSelected];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    targetViewOrigin = _targetMapView.frame.origin;
    locationViewOrigin = _locationMapView.frame.origin;
}

- (void) slideOut
{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGPoint mapOrigin = _targetMapView.frame.origin;
                         mapOrigin.y -= CGRectGetHeight(_targetMapView.frame) - 30.0f;
                         _targetMapView.frameOrigin = mapOrigin;
                         
                         mapOrigin = _locationMapView.frame.origin;
                         mapOrigin.y += CGRectGetHeight(_locationMapView.frame) -30.0f;
                         _locationMapView.frameOrigin = mapOrigin;
                         
                     } completion:nil];
}

- (void) slideIn
{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _targetMapView.frameOrigin = targetViewOrigin;
                         _locationMapView.frameOrigin = locationViewOrigin;
                         
                     } completion:nil];
}

- (IBAction)infoButtonHandler:(id)sender
{
    if (CGPointEqualToPoint(_targetMapView.frame.origin, targetViewOrigin) && CGPointEqualToPoint(_locationMapView.frame.origin, locationViewOrigin)) {
        [self slideOut];
        _infoButton.selected = YES;
    } else {
        [self slideIn];
        _infoButton.selected = NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
