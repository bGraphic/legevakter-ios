//
//  TESMapDelegate.m
//  Legevakt
//
//  Created by Benedicte Raae on 11.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESMapDelegate.h"
#import "TESDetailViewController.h"
#import "TESMapAnnotation.h"
#import "TESMapAnnotationView.h"

@implementation TESMapDelegate

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
    
    if(self.navigationController && detailView)
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
            
            mapAnnotationView.canShowCallout = self.showCallOut;
            
            if(self.navigationController)
            {
                UIButton *disclosureButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
                mapAnnotationView.rightCalloutAccessoryView = disclosureButton;
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
