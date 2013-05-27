//
//  RGViewController.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/22/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGContainerViewController.h"
#import "RGLocationManager.h"
#import "RGMapControllerProtocol.h"
#import <QuartzCore/QuartzCore.h>

@interface RGContainerViewController ()<RGlocationProtocol> {
    
    CGPoint targetViewOrigin;
    CGPoint locationViewOrigin;
}

@property (weak, nonatomic) IBOutlet UIView *targetMapView;
@property (weak, nonatomic) IBOutlet UIView *locationMapView;

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) RGLocationManager *locationManager;

//to remove these implement a mapViewProtocol and use that as a reference instead
@property id<RGMapControllerProtocol> targetMapViewController;
@property id<RGMapControllerProtocol> locationMapViewController;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation RGContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", self.childViewControllers.description);
    
    for (id<RGMapControllerProtocol>mapVC in self.childViewControllers) {
        
        NSString *restorationID = [mapVC identifier];
        
        if ([restorationID isEqualToString:@"map_controller_target"]) {
            _targetMapViewController = mapVC;
            
        } else if ([restorationID isEqualToString:@"map_controller_location"]) {
            _locationMapViewController = mapVC;
        }
    }
    
    _locationManager = [RGLocationManager new];
    _locationManager.delegate = self;
    
    _targetMapView.layer.shadowColor = [UIColor blackColor].CGColor;
    _targetMapView.layer.shadowRadius = 4.0f;
    _targetMapView.layer.shadowOpacity = 0.5f;
    _targetMapView.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
    _targetMapView.clipsToBounds = NO;
    
    _locationMapView.layer.shadowColor = [UIColor blackColor].CGColor;
    _locationMapView.layer.shadowRadius = 4.0f;
    _locationMapView.layer.shadowOpacity = 0.5f;
    _locationMapView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    _locationMapView.clipsToBounds = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Capture the default position of the maps for later animation
    targetViewOrigin = _targetMapView.frame.origin;
    locationViewOrigin = _locationMapView.frame.origin;
    
    [_locationManager startUpdatingLocation];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [_locationManager stopUpdatingLocation];
}

- (void)animateMapViews:(id)sender
{
    CGPoint locationOrigin = CGPointZero;
    CGPoint targetOrigin = CGPointZero;
    
    if (CGPointEqualToPoint(_targetMapView.frame.origin, targetViewOrigin) && CGPointEqualToPoint(_locationMapView.frame.origin, locationViewOrigin)) {

        targetOrigin = _targetMapView.frame.origin;
        targetOrigin.y += CGRectGetHeight(_targetMapView.frame) - 30.0f;
        
        locationOrigin = _locationMapView.frame.origin;
        locationOrigin.y -= CGRectGetHeight(_locationMapView.frame) - 30.0f;
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

- (IBAction)infoButtonUpHandler:(id)sender {
    
    [self animateMapViews:sender];
}

- (IBAction)infoButtonDownHandler:(id)sender {
 
    [self animateMapViews:sender];
}

#pragma mark RGlocationProtocol

- (void) locationController:(id) controller didUpDateLocation:(CLLocation*) location
{
    //Construct a new model object to update the map
    RGMapStateModel *locationMapModel = [RGMapStateModel new];
    locationMapModel.location = location;
    locationMapModel.annotationImagePath = @"man.png";
    [_locationMapViewController updateWithMapModel:locationMapModel];

    //Reverse geocode the location
    [locationMapModel reverseGeoCodeLocation:location withCompletionBlock:^(NSString *string) {
        _locationLabel.text = [NSString stringWithFormat:@"Start Digging at :\n%@", string];
    }];
    
    //Construct the antipode from the location
    CLLocation *antipodeLocation = [RGMapStateModel antipodeFromLocation:location];
    RGMapStateModel *targetMapModel = [RGMapStateModel new];
    targetMapModel.location = antipodeLocation;
    targetMapModel.annotationImagePath = @"hole.png";
    
    [_targetMapViewController updateWithMapModel:targetMapModel];
    
    //Reverse geocode the antipode
    [targetMapModel reverseGeoCodeLocation:antipodeLocation withCompletionBlock:^(NSString *string) {
       _targetLabel.text = [NSString stringWithFormat:@"End up at :\n%@", string];
    }];
}

- (void) locationController:(id) controller didFailWithError:(NSError*) error
{
    NSLog(@"%@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
