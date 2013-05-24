//
//  RGMapViewController.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/23/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGMapViewController.h"
#import "RGMapAnnotation.h"
#import <MapKit/MapKit.h>

@interface RGMapViewController ()<MKMapViewDelegate> {
    
    RGMapStateModel *mapModel;
}
//@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation RGMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
}

- (void) updateWithMapModel:(RGMapStateModel*) model
{
    mapModel = model;
    RGMapAnnotation *annotation = [RGMapAnnotation new];
    [annotation updateCoordinate:model.location.coordinate];
    
    MKMapView *map = (MKMapView*)self.view;
    [map removeAnnotations:map.annotations];
    
    [map addAnnotation:annotation];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
