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
    
    //Containers to hold the controller views, this gives us less layout and more control over transitions
    UIView *topContainer;
    UIView *bottomContainer;
    
    UIButton *infoButton;
}

//The four child controllers we will be switching between
@property RGMapViewController *startMapViewController;
@property RGGeoInfoViewController *startGeoViewController;

@property RGMapViewController *targetMapViewController;
@property RGGeoInfoViewController *targetGeoViewController;

@end

@implementation RGContainerViewController

- (void) loadView
{
    UIView *view = [UIView new];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	view.backgroundColor = [UIColor darkGrayColor];
    
    //Set up containers and their constraints
    topContainer = [UIView new];
    [topContainer setTranslatesAutoresizingMaskIntoConstraints:NO];    
    [view addSubview:topContainer];
    
    [topContainer constrainWidthToView:view predicate:nil];
    [topContainer constrainHeightToView:view predicate:@"*.42"];
    [topContainer alignTopEdgeWithView:view predicate:nil];
    [topContainer alignCenterXWithView:view predicate:nil];
    
    bottomContainer = [UIView new];
    [bottomContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addSubview:bottomContainer];
    
    [bottomContainer constrainWidthToView:view predicate:nil];
    [bottomContainer constrainHeightToView:view predicate:@"*.42"];
    [bottomContainer alignBottomEdgeWithView:view predicate:nil];
    [bottomContainer alignCenterXWithView:view predicate:nil];    

    //Add a button to transition between controller views
    infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton setBackgroundImage:[UIImage imageNamed:@"radar"] forState:UIControlStateNormal];
    [view addSubview:infoButton];
    
    [infoButton alignCenterXWithView:view predicate:nil];
    [infoButton alignCenterYWithView:view predicate:nil];
    
    [infoButton addTarget:self action:@selector(infoButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Setup controllers
    _startMapViewController = [RGMapViewController new];
    [_startMapViewController setAnnotationImagePath:@"man"];
    [self addChildViewController:_startMapViewController];          //  1
    [topContainer addSubview:_startMapViewController.view];         //  2
    [_startMapViewController didMoveToParentViewController:self];   //  3
    [_startMapViewController addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
    _startGeoViewController = [RGGeoInfoViewController new];        //  4
    
    
    _targetMapViewController = [RGMapViewController new];
    [_targetMapViewController setAnnotationImagePath:@"x"];
    [self addChildViewController:_targetMapViewController];
    [bottomContainer addSubview:_targetMapViewController.view];
    [_targetMapViewController didMoveToParentViewController:self];
    [_targetMapViewController addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
    _targetGeoViewController = [RGGeoInfoViewController new];
    
    //Initialize controllers with a default location
    CLLocation *initialLocation = [[CLLocation alloc] initWithLatitude:56.55 longitude:8.316667];
    [_startMapViewController updateAnnotationLocation:initialLocation];
    [_targetMapViewController updateAnnotationLocation:[initialLocation antipode]];
    
    //Add shadows to the containers
    topContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    topContainer.layer.shadowRadius = 4.0f;
    topContainer.layer.shadowOpacity = 0.5f;
    topContainer.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    
    bottomContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    bottomContainer.layer.shadowRadius = 4.0f;
    bottomContainer.layer.shadowOpacity = 0.5f;
    bottomContainer.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)infoButtonHandler:(id)sender
{
    [infoButton setEnabled:NO];

    double delay = 0.2;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * 2 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [infoButton setEnabled:YES];
    });

    UIViewAnimationOptions direction = UIViewAnimationOptionTransitionFlipFromTop;
    if (_startMapViewController.parentViewController == self) {
        
        [_startGeoViewController setLocation:_startMapViewController.currentLocation];
        [_targetGeoViewController setLocation:_targetMapViewController.currentLocation];
        
        [self flipFromViewController:_startMapViewController toViewController:_startGeoViewController withDirection:direction andDelay:0.0];
        [self flipFromViewController:_targetMapViewController toViewController:_targetGeoViewController withDirection:direction andDelay:delay];
        
    } else {
        
        direction = UIViewAnimationOptionTransitionFlipFromBottom;
        
        [self flipFromViewController:_startGeoViewController toViewController:_startMapViewController withDirection:direction andDelay:0.0];
        
        [self flipFromViewController:_targetGeoViewController toViewController:_targetMapViewController withDirection:direction andDelay:delay];
    }
}

- (void) flipFromViewController:(UIViewController*) fromController toViewController:(UIViewController*) toController  withDirection:(UIViewAnimationOptions) direction andDelay:(double) delay
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);

    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        toController.view.frame = fromController.view.bounds;                           //  1
        [self addChildViewController:toController];                                     //  2
        [fromController willMoveToParentViewController:nil];                            //  3
        
        [self transitionFromViewController:fromController
                          toViewController:toController
                                  duration:0.2
                                   options:direction | UIViewAnimationOptionCurveEaseIn
                                animations:nil
                                completion:^(BOOL finished) {
                                    
                                    [toController didMoveToParentViewController:self];  //  4
                                    [fromController removeFromParentViewController];    //  5
                                    [infoButton setEnabled:YES];
                                }];
    });
}

#pragma mark KVO observer

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
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
