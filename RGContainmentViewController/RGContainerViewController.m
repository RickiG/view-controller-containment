//
//  RGViewController.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/22/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGContainerViewController.h"
#import "RGMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface RGContainerViewController ()<CLLocationManagerDelegate> {
    
    CGPoint targetViewOrigin;
    CGPoint locationViewOrigin;
}

@property (weak, nonatomic) IBOutlet UIView *targetMapView;
@property (weak, nonatomic) IBOutlet UIView *locationMapView;

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) CLLocationManager *locationManager;

//to remove these implement a mapViewProtocol and use that as a reference instead
@property RGMapViewController *targetMapViewController;
@property RGMapViewController *locationMapViewController;

//Idea move calculation of antipode to class method in mapStateModel

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
    
    _targetLabel.text = @"Target";
    _locationLabel.text = @"Location";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    targetViewOrigin = _targetMapView.frame.origin;
    locationViewOrigin = _locationMapView.frame.origin;
    
    [self.locationManager startUpdatingLocation];

}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
    _locationManager = nil;
}

- (CLLocationManager*) locationManager
{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = 10.0f;
        _locationManager.delegate = self;
    }
    
    return _locationManager;
}

- (void) slideOut
{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _targetMapView.frameOrigin = targetViewOrigin;
                         _locationMapView.frameOrigin = locationViewOrigin;
                         
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
    CGPoint locationOrigin = CGPointZero;
    CGPoint targetOrigin = CGPointZero;
    
    if (CGPointEqualToPoint(_targetMapView.frame.origin, targetViewOrigin) && CGPointEqualToPoint(_locationMapView.frame.origin, locationViewOrigin)) {

        targetOrigin = _targetMapView.frame.origin;
        targetOrigin.y -= CGRectGetHeight(_targetMapView.frame) - 30.0f;
        
        locationOrigin = _locationMapView.frame.origin;
        locationOrigin.y += CGRectGetHeight(_locationMapView.frame) - 30.0f;
        _infoButton.selected = YES;
        
    } else {

        targetOrigin = targetViewOrigin;
        locationOrigin = locationViewOrigin;
        
        _infoButton.selected = NO;
    }
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _targetMapView.frameOrigin = targetOrigin;
                         _locationMapView.frameOrigin = locationOrigin;
                         
                     } completion:nil];
}

#pragma mark - Corelocation Delegate

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations objectAtIndex:0];
    
    RGMapStateModel *mapModel = [RGMapStateModel new];
    mapModel.location = location;
    
    [_locationMapViewController updateWithMapModel:mapModel];
    
    /*
     ask locationMapController to display user pos
     calculate antipode
     ask targetLMapController to display antipode
     ask for placemark close by - assign to labels
     */
    
    NSLog(@"%@", location.description);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"didFailWithError: %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
