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
#import "TESMapAnnotationView.h"
#import "TESMapDelegate.h"

@interface TESMapViewController ()

@property (nonatomic, strong) HealthService *selectedHealthService;

@property (nonatomic, strong) TESMapDelegate *mapDelegate;

@end

@implementation TESMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.mapDelegate = [[TESMapDelegate alloc] init];
    self.mapView.delegate = self.mapDelegate;
    
    [self initilizeMapRegion];
    
    [self configureView];
}

- (void) setHealthService:(HealthService *)healthService
{
    _healthServices = nil;
    
    if(_healthService != healthService)
    {
        _healthService = healthService;
        
        [self configureView];
    }
}

- (void) setHealthServices:(NSArray *)healthServices
{
    _healthService = nil;
    
    if(_healthServices != healthServices)
    {
        _healthServices = healthServices;
        
        [self configureView];
    }
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

- (void) initilizeMapRegion
{
    if (self.healthService) {
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.healthService.location.coordinate, 2000.f, 2000.f)];
    }
    else
    {
        HealthService *healthService = (HealthService *)[self.healthServices objectAtIndex:0];
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(healthService.location.coordinate, 2000.f, 2000.f)];
    }
}

- (void) configureView
{
    // Update the user interface for the detail item.
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (self.healthService)
    {
        [self.mapView addAnnotation:[TESMapAnnotation mapAnnotationForHealthService:self.healthService]];
        self.title = NSLocalizedString(@"detail_view_controller_title", nil);
        
        self.mapDelegate.showCallOut = YES;
    }
    else
    {
        self.title = NSLocalizedString(@"main_view_controller_title", nil);
        
        self.mapDelegate.showCallOut = YES;
        self.mapDelegate.navigationController = self.navigationController;
    
        for(HealthService *healthService in self.healthServices)
        {
            if(healthService.location)
                [self.mapView addAnnotation:[TESMapAnnotation mapAnnotationForHealthService:healthService]];
        }
        
        NSSet *visibleAnnotationSet = [self.mapView annotationsInMapRect:self.mapView.visibleMapRect];
        
        if(visibleAnnotationSet.count == 0)
        {
            HealthService *healthService = (HealthService *)[self.healthServices objectAtIndex:0];
            [self.mapView setCenterCoordinate:healthService.location.coordinate animated:YES];
        }

    }
}

@end
