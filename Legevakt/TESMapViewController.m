//
//  TESMapViewController.m
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESMapViewController.h"
#import "TESMapAnnotation.h"

@interface TESMapViewController ()

@end

@implementation TESMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
        [self.mapView setCenterCoordinate:self.healthService.location.coordinate];
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.healthService.location.coordinate, 2000.f, 2000.f)];
    }
}


@end
