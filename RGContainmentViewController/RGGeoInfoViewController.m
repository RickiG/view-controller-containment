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
    CLLocation *currentLocation;
}

@end

@implementation RGGeoInfoViewController

- (void) loadView
{
    UIView *view = [UIView new];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    infoLabel = [UILabel new];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.numberOfLines = 0;
    infoLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    infoLabel.shadowColor = [UIColor darkGrayColor];
    infoLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    infoLabel.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    infoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:infoLabel];
    
    self.view = view;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void) updateLocation:(CLLocation*) location
{
    if (location) {
        
        if (!currentLocation || [location distanceFromLocation:currentLocation] > 100) {
         
            infoLabel.text = NSLocalizedString(@"Thinking...", @"");
            [self reverseGeoCodeLocation:location];
        }
    }
}

#pragma mark - Reverse geolocation
- (void) reverseGeoCodeLocation:(CLLocation*) location
{
    currentLocation = location;
    
    [[[CLGeocoder alloc] init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (!error) {
            
            NSMutableString  *placeStr = [NSMutableString string];
            
            for (CLPlacemark *p in placemarks) {
                
                if (p.name != NULL)
                    [placeStr appendFormat:@"%@ ", p.name];
                if (p.locality != NULL)
                    [placeStr appendFormat:@"%@ ", p.locality];
                if (p.country != NULL)
                    [placeStr appendFormat:@"%@ ", p.country];
                
                infoLabel.text = (NSString*)placeStr;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
