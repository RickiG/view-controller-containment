//
//  RGViewController.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/22/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGContainerViewController.h"
#import "RGLocationManager.h"
#import "RGMapViewController.h"
#import "UIView+FLKAutoLayout.h"
//#import "RGMapControllerProtocol.h"
#import <QuartzCore/QuartzCore.h>

@interface RGContainerViewController ()<RGlocationProtocol, RGMapControllerProtocol> {
    
    NSLayoutConstraint *topMapYConstrain, *bottomMapYConstrain;
    RGMapStateModel *locationMapModel, *targetMapModel;
}

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) RGLocationManager *locationManager;

//to remove these implement a mapViewProtocol and use that as a reference instead
@property RGMapViewController *targetMapViewController;
@property RGMapViewController *locationMapViewController;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation RGContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationMapViewController = [RGMapViewController new];
    [_locationMapViewController setAnnotationImagePath:@"man"];
    [_locationMapViewController setAnnotationIsDraggable:YES];
    [self addChildViewController:_locationMapViewController];
    [self.view addSubview:_locationMapViewController.view];

    [_locationMapViewController didMoveToParentViewController:self];
    [_locationMapViewController.view constrainWidthToView:self.view predicate:nil];
    [_locationMapViewController.view constrainHeightToView:self.view predicate:@"*.4"];
    
    topMapYConstrain = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_locationMapViewController.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:20.0f];
    [self.view addConstraint:topMapYConstrain];
    
    _targetMapViewController = [RGMapViewController new];
    [_targetMapViewController setAnnotationImagePath:@"hole"];
    [_targetMapViewController setAnnotationIsDraggable:NO];
    [self addChildViewController:_targetMapViewController];
    [self.view addSubview:_targetMapViewController.view];
    
    [_targetMapViewController didMoveToParentViewController:self];
    [_targetMapViewController.view constrainWidthToView:self.view predicate:nil];
    [_targetMapViewController.view constrainHeightToView:self.view predicate:@"*.4"];
    
    bottomMapYConstrain = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_targetMapViewController.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:20.0f];
    [self.view addConstraint:bottomMapYConstrain];

    _locationManager = [RGLocationManager new];
    _locationManager.delegate = self;
    _locationMapViewController.delegate = self;
    
    _locationMapViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _locationMapViewController.view.layer.shadowRadius = 4.0f;
    _locationMapViewController.view.layer.shadowOpacity = 0.5f;
    _locationMapViewController.view.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    
    _targetMapViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _targetMapViewController.view.layer.shadowRadius = 4.0f;
    _targetMapViewController.view.layer.shadowOpacity = 0.5f;
    _targetMapViewController.view.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_locationManager startUpdatingLocation];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [_locationManager stopUpdatingLocation];
}

- (IBAction)infoButtonDownHandler:(id)sender {
    
    topMapYConstrain.constant = CGRectGetHeight(_locationMapViewController.view.frame) - 20.0f;
    bottomMapYConstrain.constant = -CGRectGetHeight(_targetMapViewController.view.frame) + 60;
    [self updateViewLayout:YES];
}

- (IBAction)infoButtonUpHandler:(id)sender
{
    topMapYConstrain.constant = 20.0f;
    bottomMapYConstrain.constant = 20.0f;
    [self updateViewLayout:YES];
}

- (void) updateViewLayout:(BOOL) animated
{
    [_locationMapViewController.view setNeedsUpdateConstraints];
    [_targetMapViewController.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [_locationMapViewController.view layoutIfNeeded];
                         [_targetMapViewController.view layoutIfNeeded];
                         
                     } completion:nil];
}

#pragma mark RGMapControllerProtocol

- (void) mapController:(id)controller didUpdateLocation:(CLLocation *)location
{
    [self updateMapsWithLocation:location];
}

#pragma mark RGlocationProtocol

- (void) locationController:(id) controller didUpdateLocation:(CLLocation*) location
{
    [self updateMapsWithLocation:location];
}

- (void) updateMapsWithLocation:(CLLocation*) location
{
    [_locationMapViewController updateAnnotationLocation:location];
    
    //Reverse geocode the location
    [_locationMapViewController reverseGeoCodeLocation:location withCompletionBlock:^(NSString *string) {
        _locationLabel.text = [NSString stringWithFormat:@"Start Digging at :\n%@", string];
    }];
    
    //Construct the antipode from the location
    CLLocation *antipodeLocation = [RGMapStateModel antipodeFromLocation:location];
    [targetMapModel setLocation:antipodeLocation];
 
    [_targetMapViewController updateAnnotationLocation:antipodeLocation];
    
    //Reverse geocode the antipode
    [_targetMapViewController reverseGeoCodeLocation:antipodeLocation withCompletionBlock:^(NSString *string) {
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
