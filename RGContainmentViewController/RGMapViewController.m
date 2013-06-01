//
//  RGMapViewController.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/23/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGMapViewController.h"
#import "RGMapAnnotation.h"
#import "RGAnnotationView.h"
#import "UIView+FLKAutoLayout.h"
#import <MapKit/MapKit.h>

@interface RGMapViewController ()<MKMapViewDelegate> {
    
    MKMapView *mapView;
}

@end

@implementation RGMapViewController

- (void) loadView
{
    mapView = [MKMapView new];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [mapView setDelegate:self];
    [mapView setMapType:MKMapTypeHybrid];
    
    self.view = mapView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RGMapAnnotation *mapAnnotation = [RGMapAnnotation new];
    [mapView addAnnotation:mapAnnotation];
}

- (void) updateAnnotationLocation:(CLLocation *)location
{
    RGMapAnnotation *annotation = [mapView.annotations lastObject];
    
    [annotation setCoordinate:location.coordinate];
    [self snapToLocation:location];
    //Avoid self.currentLocation here as it will cause the KVO observer to repeatedly try and update
    _currentLocation = location;
}

- (void) snapToLocation:(CLLocation*) location
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000000.0, 1000000.0);
    [mapView setRegion:region animated:YES];
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *) theMapView viewForAnnotation:(id)annotation{
    
    NSString *annotationIdentifier = self.annotationImagePath;
    
    if([annotation isKindOfClass:[RGMapAnnotation class]]) {
        
        RGAnnotationView *annotationView = (RGAnnotationView*)[theMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if(!annotationView){
            annotationView=[[RGAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            annotationView.image=[UIImage imageNamed:annotationIdentifier];
            
            if (self.annotationImagePath)
                annotationView.image = [UIImage imageNamed:self.annotationImagePath];

            annotationView.draggable = YES;
            
        } else {
            
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
        
        [self snapToLocation:newLocation];
        self.currentLocation = newLocation;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
