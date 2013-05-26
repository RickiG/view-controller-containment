//
//  RGViewController.m
//  RGContainmentViewController
//
//  Created by Ricki Gregersen on 5/22/13.
//  Copyright (c) 2013 Ricki Gregersen. All rights reserved.
//

#import "RGContainerViewController.h"
#import "RGMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface RGContainerViewController ()<CLLocationManagerDelegate> {
    
    CGPoint targetViewOrigin;
    CGPoint locationViewOrigin;
}

@property (weak, nonatomic) IBOutlet UIView *targetMapView;
@property (weak, nonatomic) IBOutlet UIView *locationMapView;

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) CLLocationManager *locationManager;

//to remove these implement a mapViewProtocol and use that as a reference instead
@property RGMapViewController *targetMapViewController;
@property RGMapViewController *locationMapViewController;

//Idea move calculation of antipode to class method in mapStateModel

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation RGContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", self.childViewControllers.description);
    for (RGMapViewController *mapVC in self.childViewControllers) {
        NSString *restorationID = mapVC.restorationIdentifier;
        if ([restorationID isEqualToString:@"map_controller_target"]) {
            
            _targetMapViewController = mapVC;
            
        } else if ([restorationID isEqualToString:@"map_controller_location"]) {
            
            _locationMapViewController = mapVC;
        }
    }
    
    _targetMapView.layer.cornerRadius = 10.0f;
    _locationMapView.layer.cornerRadius = 10.0f;
    
    [_infoButton setBackgroundImage:[UIImage imageNamed:@"radar_enabled.png"] forState:UIControlStateSelected];
    
    _targetLabel.text = @"Target";
    _locationLabel.text = @"Location";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    targetViewOrigin = _targetMapView.frame.origin;
    locationViewOrigin = _locationMapView.frame.origin;
    
    [self.locationManager startUpdatingLocation];

}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
    _locationManager = nil;
}

- (CLLocationManager*) locationManager
{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = 10.0f;
        _locationManager.delegate = self;
    }
    
    return _locationManager;
}

- (void)animateMapViews:(id)sender
{
    CGPoint locationOrigin = CGPointZero;
    CGPoint targetOrigin = CGPointZero;
    
    if (CGPointEqualToPoint(_targetMapView.frame.origin, targetViewOrigin) && CGPointEqualToPoint(_locationMapView.frame.origin, locationViewOrigin)) {

        targetOrigin = _targetMapView.frame.origin;
        targetOrigin.y -= CGRectGetHeight(_targetMapView.frame) - 30.0f;
        
        locationOrigin = _locationMapView.frame.origin;
        locationOrigin.y += CGRectGetHeight(_locationMapView.frame) - 30.0f;
        _infoButton.selected = YES;
        
    } else {

        targetOrigin = targetViewOrigin;
        locationOrigin = locationViewOrigin;
        
        _infoButton.selected = NO;
    }
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _targetMapView.frameOrigin = targetOrigin;
                         _locationMapView.frameOrigin = locationOrigin;
                         
                     } completion:nil];
}

- (IBAction)infoButtonUpHandler:(id)sender {
    
    [self animateMapViews:sender];
}

- (IBAction)infoButtonDownHandler:(id)sender {
 
    [self animateMapViews:sender];
}

#pragma mark - Corelocation Delegate

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations objectAtIndex:0];
    
    RGMapStateModel *locationMapModel = [RGMapStateModel new];
    locationMapModel.location = location;
    locationMapModel.annotationImagePath = @"man.png";
    
    [_locationMapViewController updateWithMapModel:locationMapModel];
    
    [self updateLabel:_locationLabel withLocationInformation:location andBaseString:@"Start digging :\n"];
    
    /*
     ask locationMapController to display user pos
     calculate antipode
     ask targetLMapController to display antipode
     ask for placemark close by - assign to labels
     */

    CLLocation *antipodeLocation = [RGMapStateModel antipodeFromLocation:location];
    RGMapStateModel *targetMapModel = [RGMapStateModel new];
    targetMapModel.location = antipodeLocation;
    targetMapModel.annotationImagePath = @"sun.png";
    
    [_targetMapViewController updateWithMapModel:targetMapModel];
    
    [self updateLabel:_targetLabel withLocationInformation:antipodeLocation andBaseString:@"End up at :\n"];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"didFailWithError: %@", error);
}

- (void) updateLabel:(UILabel*) label withLocationInformation:(CLLocation*) location andBaseString:(NSString*) string
{
    __block NSMutableString *placeStr = [[NSMutableString alloc] initWithString:string];
    
    [[[CLGeocoder alloc] init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (!error) {
            for (CLPlacemark *p in placemarks) {
                
                NSLog(@"%@", p.description);
                
                [label setText:[NSString stringWithFormat:@"%@", p.country]];
                
                if (p.name != NULL)
                    [placeStr appendFormat:@"%@ ", p.name];
                if (p.locality != NULL)
                    [placeStr appendFormat:@"%@ ", p.locality];
                if (p.country != NULL)
                    [placeStr appendFormat:@"%@ ", p.country];
                
                [label setText:placeStr];
                
                //             p.country;                 //country
                //             p.locality;                //city
                //             p.name                     //placemark?
                //             p.region                   //area?
                //             p.subAdministrativeArea    //county
                //             p.subLocality              //neighbourhood
                //             p.thoroughfare             //street name
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
