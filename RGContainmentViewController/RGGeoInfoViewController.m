//
//  RGGeoInfoViewController.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/31/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGGeoInfoViewController.h"
#import "UIView+FLKAutoLayout.h"

@interface RGGeoInfoViewController () {
    
    UILabel *infoLabel;
}

@end

@implementation RGGeoInfoViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    infoLabel = [UILabel new];
    infoLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:infoLabel];

//    [self.view setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 500.0f)];
    
    [infoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [infoLabel constrainWidthToView:self.view predicate:nil];
    [infoLabel constrainHeightToView:self.view predicate:nil];
    [infoLabel alignTopEdgeWithView:self.view predicate:nil];
    
    [self.view setBackgroundColor:[UIColor redColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
