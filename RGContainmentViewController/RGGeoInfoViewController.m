//
//  RGGeoInfoViewController.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/31/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGGeoInfoViewController.h"

@interface RGGeoInfoViewController () {
    
    UILabel *infoLabel;
}

@end

@implementation RGGeoInfoViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    infoLabel = [UILabel new];
//    infoLabel.autoresizesSubviews
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
