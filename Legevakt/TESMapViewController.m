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
    
    [self configureView];
}

- (void) setHealthService:(HealthService *)healthService
{
    if(_healthService != healthService)
    {
        _healthService = healthService;
     
        self.mapDelegate.showCallOut = NO;
        self.mapDelegate.navigationController = nil;
    }
}

- (void)setTableDataSource:(TESTableDataSource *)tableDataSource
{
    if(_tableDataSource != tableDataSource)
    {
        _tableDataSource = tableDataSource;
        
        self.mapDelegate.showCallOut = YES;
        self.mapDelegate.navigationController = self.navigationController;
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

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.healthService) {
        [self.mapView addAnnotation:[TESMapAnnotation mapAnnotationForHealthService:self.healthService]];
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.healthService.location.coordinate, 2000.f, 2000.f)];
    }
    
    if(self.tableDataSource.healthServicesFiltered)
    {
        int i = 0;
        for(HealthService *healthService in self.tableDataSource.healthServicesFiltered)
        {
            [self.mapView addAnnotation:[TESMapAnnotation mapAnnotationForHealthService:healthService]];
            
            if(i == 0)
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(healthService.location.coordinate, 2000.f, 2000.f)];
            i++;
        }
    }
    else
    {
        int i = 0;
        for(HealthService *healthService in self.tableDataSource.healthServices)
        {
            [self.mapView addAnnotation:[TESMapAnnotation mapAnnotationForHealthService:healthService]];
            
            if(i == 0)
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(healthService.location.coordinate, 2000.f, 2000.f)];
            i++;
        }

    }
}

@end
