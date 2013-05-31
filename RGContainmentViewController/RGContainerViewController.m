//
//  RGViewController.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/22/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGContainerViewController.h"
#import "RGMapViewController.h"

#import "CLLocation+Utilities.h"
#import "UIView+FLKAutoLayout.h"

#import <QuartzCore/QuartzCore.h>

@interface RGContainerViewController () {
    
    NSLayoutConstraint *topMapYConstrain, *bottomMapYConstrain;
    RGMapStateModel *locationMapModel, *targetMapModel;
}

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property RGMapViewController *targetMapViewController;
@property RGMapViewController *locationMapViewController;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation RGContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //View specific setup for locationMapController
    _locationMapViewController = [RGMapViewController new];
    [_locationMapViewController setAnnotationImagePath:@"man"];
    [self addChildViewController:_locationMapViewController];
    [self.view addSubview:_locationMapViewController.view];
    
    //Notify child controller that he has a parent
    [_locationMapViewController didMoveToParentViewController:self];

    //Add view constraints
    [_locationMapViewController.view constrainWidthToView:self.view predicate:nil];
    [_locationMapViewController.view constrainHeightToView:self.view predicate:@"*.4"];
    topMapYConstrain = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_locationMapViewController.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:20.0f];
    [self.view addConstraint:topMapYConstrain];
    
    //Observe properties
    [_locationMapViewController addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:NULL];
    [_locationMapViewController addObserver:self forKeyPath:@"locationString" options:NSKeyValueObservingOptionNew context:NULL];
    
    //View specific setup for targetMapController
    _targetMapViewController = [RGMapViewController new];
    [_targetMapViewController setAnnotationImagePath:@"hole"];
    [self addChildViewController:_targetMapViewController];
    [self.view addSubview:_targetMapViewController.view];

    //Notify child controller that he has a parent
    [_targetMapViewController didMoveToParentViewController:self];
    
    //Add view constraints    
    [_targetMapViewController.view constrainWidthToView:self.view predicate:nil];
    [_targetMapViewController.view constrainHeightToView:self.view predicate:@"*.4"];
    bottomMapYConstrain = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_targetMapViewController.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:20.0f];
    [self.view addConstraint:bottomMapYConstrain];

    //Observe properties
    [_targetMapViewController addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:NULL];
    [_targetMapViewController addObserver:self forKeyPath:@"locationString" options:NSKeyValueObservingOptionNew context:NULL];
    
    _locationMapViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _locationMapViewController.view.layer.shadowRadius = 4.0f;
    _locationMapViewController.view.layer.shadowOpacity = 0.5f;
    _locationMapViewController.view.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    
    _targetMapViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _targetMapViewController.view.layer.shadowRadius = 4.0f;
    _targetMapViewController.view.layer.shadowOpacity = 0.5f;
    _targetMapViewController.view.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CLLocation *initialLocation = [[CLLocation alloc] initWithLatitude:56.55 longitude:8.316667];
    [_locationMapViewController updateAnnotationLocation:initialLocation];
    [_targetMapViewController updateAnnotationLocation:[initialLocation antipode]];
}

- (void) viewWillDisappear:(BOOL)animated
{
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

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentLocation"]) {
        
        RGMapViewController *oppositeController = nil;
        
        if ([object isEqual:_locationMapViewController])
            oppositeController = _targetMapViewController;
        else
            oppositeController = _locationMapViewController;
        
        CLLocation *newLocation = [change objectForKey:@"new"];
        [oppositeController updateAnnotationLocation:[newLocation antipode]];
        
    } else if ([keyPath isEqualToString:@"locationString"]) {
        
        UILabel *locationLabel = nil;
        
        if ([object isEqual:_locationMapViewController])
            locationLabel = self.locationLabel;
        else
            locationLabel = self.targetLabel;
        
        locationLabel.text = [change objectForKey:@"new"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
