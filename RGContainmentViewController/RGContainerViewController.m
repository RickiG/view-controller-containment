//
//  RGViewController.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/22/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGContainerViewController.h"
#import "RGMapViewController.h"

@interface RGContainerViewController ()

@property RGMapViewController *targetMapViewController;

@end

@implementation RGContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _targetMapViewController = [RGMapViewController new];
    [self addChildViewController:_targetMapViewController];
    [self.view addSubview:_targetMapViewController.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
