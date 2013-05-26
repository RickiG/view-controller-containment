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

@end

@implementation RGMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [(MKMapView*)self.view setDelegate:self];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) updateWithMapModel:(RGMapStateModel*) model
{
    mapModel = model;
    RGMapAnnotation *annotation = [RGMapAnnotation new];
    [annotation updateCoordinate:model.location.coordinate];
    
    MKMapView *map = (MKMapView*)self.view;
    [map removeAnnotations:map.annotations];
    
    [map addAnnotation:annotation];
    
    [self snapToLocation:model.location];
}

- (void) snapToLocation:(CLLocation*) location
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000000.0, 1000000.0);
    [(MKMapView*)self.view setRegion:region animated:YES];
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation{
    
    NSString *annotationIdentifier = mapModel.annotationImagePath;
    
    if([annotation isKindOfClass:[RGMapAnnotation class]]) {
        
        MKAnnotationView *annotationView=[(MKMapView*)self.view dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if(!annotationView){
            annotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            annotationView.image=[UIImage imageNamed:annotationIdentifier];
        }
        return annotationView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
