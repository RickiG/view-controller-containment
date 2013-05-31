//
//  RGViewController.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/22/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGContainerViewController.h"
#import "RGMapViewController.h"
#import "RGGeoInfoViewController.h"

#import "CLLocation+Utilities.h"
#import "UIView+FLKAutoLayout.h"

#import <QuartzCore/QuartzCore.h>

@interface RGContainerViewController () {
    
//    NSLayoutConstraint *topMapYConstrain, *bottomMapYConstrain;
    RGMapStateModel *locationMapModel, *targetMapModel;
    BOOL isDisplayingMapView;
    UIView *topContainer;
    UIView *bottomContainer;
}

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property RGMapViewController *startMapViewController;
@property RGMapViewController *targetMapViewController;

@property RGGeoInfoViewController *startGeoViewController;
@property RGGeoInfoViewController *targetGeoViewController;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation RGContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    topContainer = [UIView new];
    bottomContainer = [UIView new];
    
    //View specific setup for locationMapController
    _startMapViewController = [RGMapViewController new];
    [_startMapViewController setAnnotationImagePath:@"man"];
    [self addChildViewController:_startMapViewController];
    [self.view addSubview:_startMapViewController.view];
    
    //Notify child controller that he has a parent
    [_startMapViewController didMoveToParentViewController:self];

    //Add view constraints
    [_startMapViewController.view constrainWidthToView:self.view predicate:nil];
    [_startMapViewController.view constrainHeightToView:self.view predicate:@"*.4"];
    [_startMapViewController.view alignTopEdgeWithView:self.view predicate:nil];
    
    //Observe properties
    [_startMapViewController addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:NULL];

    _startGeoViewController = [RGGeoInfoViewController new];
    //Add view constraints
//    [self addChildViewController:_startGeoViewController];
//    [self.view addSubview:_startGeoViewController.view];
    
    [_startGeoViewController.view constrainWidthToView:self.view predicate:nil];
    [_startGeoViewController.view constrainHeightToView:self.view predicate:@"*.4"];
    [_startGeoViewController.view alignTopEdgeWithView:self.view predicate:nil];
    
    
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
    [_targetMapViewController.view alignBottomEdgeWithView:self.view predicate:nil];

    //Observe properties
    [_targetMapViewController addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:NULL];
    [_targetMapViewController addObserver:self forKeyPath:@"locationString" options:NSKeyValueObservingOptionNew context:NULL];
    
    _startMapViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _startMapViewController.view.layer.shadowRadius = 4.0f;
    _startMapViewController.view.layer.shadowOpacity = 0.5f;
    _startMapViewController.view.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    
    _targetMapViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _targetMapViewController.view.layer.shadowRadius = 4.0f;
    _targetMapViewController.view.layer.shadowOpacity = 0.5f;
    _targetMapViewController.view.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
    
    isDisplayingMapView = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CLLocation *initialLocation = [[CLLocation alloc] initWithLatitude:56.55 longitude:8.316667];
    [_startMapViewController updateAnnotationLocation:initialLocation];
    [_targetMapViewController updateAnnotationLocation:[initialLocation antipode]];
}

- (void) viewWillDisappear:(BOOL)animated
{
}

- (IBAction)infoButtonDownHandler:(id)sender {
    
//    topMapYConstrain.constant = CGRectGetHeight(_startMapViewController.view.frame) - 20.0f;
//    bottomMapYConstrain.constant = -CGRectGetHeight(_targetMapViewController.view.frame) + 60;
//    [self updateViewLayout:YES];
}

- (IBAction)infoButtonUpHandler:(id)sender
{
    [self flipFromViewController:_startMapViewController toViewController:_startGeoViewController];
}


- (void) flipFromViewController:(UIViewController*) fromController toViewController:(UIViewController*) toController
{
    [self addChildViewController:toController];
    [fromController willMoveToParentViewController:nil];
    [toController.view layoutIfNeeded];
//    [toController.view setFrame:toController.view.frame];
    
    [self transitionFromViewController:_startMapViewController
                      toViewController:_startGeoViewController
                              duration:0.9
                               options:UIViewAnimationOptionTransitionCurlDown
                            animations:nil
                            completion:^(BOOL finished) {
                                                                
                                [toController didMoveToParentViewController:self];
                                [fromController.view removeFromSuperview];
                                [fromController removeFromParentViewController];
                            }];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentLocation"]) {
        
        RGMapViewController *oppositeController = nil;
        
        if ([object isEqual:_startMapViewController])
            oppositeController = _targetMapViewController;
        else
            oppositeController = _startMapViewController;
        
        CLLocation *newLocation = [change objectForKey:@"new"];
        [oppositeController updateAnnotationLocation:[newLocation antipode]];
        
    } else if ([keyPath isEqualToString:@"locationString"]) {
        
        UILabel *locationLabel = nil;
        
        if ([object isEqual:_startMapViewController])
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
