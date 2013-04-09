//
//  TESMapViewController.m
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESMapViewController.h"
#import "TESMapAnnotation.h"
#import "TESDetailViewController.h"

@interface TESMapViewController ()

@property (nonatomic, strong) HealthService *selectedHealthService;

@end

@implementation TESMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

- (void) setMyLocation:(CLLocation *)myLocation
{
    if(!_myLocation)
    {
        self.mapView.centerCoordinate = myLocation.coordinate;
    }
    
    _myLocation = myLocation;
}

- (void) setHealthServices:(NSArray *)newHealthServiceList
{
    if (_healthServices != newHealthServiceList) {
        _healthServices = newHealthServiceList;
        
        // Update the view.
        [self configureView];
    }
}

- (void)setHealthService:(id)newHealthService
{
    if (_healthService != newHealthService) {
        _healthService = newHealthService;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.healthService) {
        [self.mapView addAnnotation:[TESMapAnnotation mapAnnotationForHealthService:self.healthService]];
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.healthService.location.coordinate, 2000.f, 2000.f)];
    }
    
    if(self.healthServices)
    {
        int i = 0;
        for(HealthService *healthService in self.healthServices)
        {
            [self.mapView addAnnotation:[TESMapAnnotation mapAnnotationForHealthService:healthService]];
            
            if(i == 0)
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(healthService.location.coordinate, 2000.f, 2000.f)];
            i++;
        }
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showDetail"])
    {
        [[segue destinationViewController] setHealthService:self.selectedHealthService];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.selectedHealthService = [(TESMapAnnotation *) view.annotation healthService];
    
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *mapPin = nil;
    if(annotation != map.userLocation)
    {
        static NSString *defaultPinID = @"defaultPin";
        mapPin = (MKPinAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (mapPin == nil )
        {
            mapPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                     reuseIdentifier:defaultPinID];
            
            if(self.healthServices)
            {
                mapPin.canShowCallout = YES;
                UIButton *disclosureButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure]; 
                mapPin.rightCalloutAccessoryView = disclosureButton;
            }

            
        }
        else
            mapPin.annotation = annotation;
        
    }
    return mapPin;
}


@end
