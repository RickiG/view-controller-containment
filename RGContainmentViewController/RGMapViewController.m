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

#import <MapKit/MapKit.h>

@interface RGMapViewController ()<MKMapViewDelegate> {
    
    MKMapView *mapView;
    RGMapAnnotation *mapAnnotation;
}

@end

@implementation RGMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [mapView setDelegate:self];
    [mapView setMapType:MKMapTypeHybrid];
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:mapView];
    
    

    mapAnnotation = [RGMapAnnotation new];
    [mapView addAnnotation:mapAnnotation];
}

- (void) setAnnotationImagePath:(NSString *)annotationImagePath
{
    _annotationImagePath = annotationImagePath;
}

- (void) updateAnnotationLocation:(CLLocation *)location
{
    [mapAnnotation setCoordinate:location.coordinate];
    [self snapToLocation:location];
    //Avoid self.currentLocation here as it will cause the KVO observer to repeatedly try and update the
    _currentLocation = location;
    [self reverseGeoCodeLocation:_currentLocation];
}

- (void) snapToLocation:(CLLocation*) location
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000000.0, 1000000.0);
    [mapView setRegion:region animated:YES];
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *) theMapView viewForAnnotation:(id)annotation{
    
    NSString *annotationIdentifier = _annotationImagePath;
    
    if([annotation isKindOfClass:[RGMapAnnotation class]]) {
        
        RGAnnotationView *annotationView = (RGAnnotationView*)[theMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if(!annotationView){
            annotationView=[[RGAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            annotationView.image=[UIImage imageNamed:annotationIdentifier];
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
        CLLocation *newLocation = [[CLLocation alloc] initWithCoordinate:droppedAt altitude:0.0f horizontalAccuracy:5.0f verticalAccuracy:5.0f timestamp:[NSDate date]];
        
        [self snapToLocation:newLocation];
        self.currentLocation = newLocation;
        [self reverseGeoCodeLocation:self.currentLocation];   
    }
}

#pragma mark - Reverse geolocation
- (void) reverseGeoCodeLocation:(CLLocation*) location
{
    [[[CLGeocoder alloc] init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (!error) {
            
            NSMutableString  *placeStr = [NSMutableString string];
            
            for (CLPlacemark *p in placemarks) {
                
                NSLog(@"%@", p.description);
                
                if (p.name != NULL)
                    [placeStr appendFormat:@"%@ ", p.name];
                if (p.locality != NULL)
                    [placeStr appendFormat:@"%@ ", p.locality];
                if (p.country != NULL)
                    [placeStr appendFormat:@"%@ ", p.country];
                
                self.locationString = (NSString*)placeStr;
            }
        }
    }];
}

#pragma mark Antipode calculation

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
