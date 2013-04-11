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

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.healthService) {
        [self.mapView addAnnotation:[TESMapAnnotation mapAnnotationForHealthService:self.healthService]];
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.healthService.location.coordinate, 2000.f, 2000.f)];
    }
    
    if(self.tableDataSource)
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showDetailFromMap"])
    {
        [[segue destinationViewController] setHealthService:self.selectedHealthService];
    }
}

#pragma mark - MapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKAnnotationView* annotationView = [mapView viewForAnnotation:userLocation];
    annotationView.canShowCallout = NO;
}


- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    HealthService *healthService = [(TESMapAnnotation *) view.annotation healthService];
 
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    TESDetailViewController *detailView = [sb instantiateViewControllerWithIdentifier:@"detailView"];
    detailView.healthService = healthService;
    
    [self.navigationController pushViewController:detailView animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    TESMapAnnotationView *mapAnnotationView;
    TESMapAnnotation *mapAnnotation;
    
    
    if(annotation != map.userLocation)
    {
        static NSString *defaultPinID = @"defaultPin";
        mapAnnotationView = (TESMapAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        mapAnnotation = (TESMapAnnotation *) annotation;
        
        if (mapAnnotationView == nil )
        {
            mapAnnotationView = [[TESMapAnnotationView alloc] initWithAnnotation:annotation
                                                     reuseIdentifier:defaultPinID];
            
            if(self.tableDataSource)
            {
                mapAnnotationView.canShowCallout = YES;
                UIButton *disclosureButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure]; 
                mapAnnotationView.rightCalloutAccessoryView = disclosureButton;
                
                if(self.tableDataSource.healthServicesFiltered && ![self.tableDataSource.healthServicesFiltered containsObject:mapAnnotation.healthService])
                {
                    mapAnnotationView.alpha = 0.4f;
                }
            }
        }
        else
        {
            mapAnnotationView.annotation = annotation;
        }
        
    }   
    
    return mapAnnotationView;
}


@end
