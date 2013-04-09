//
//  TESMapViewController.h
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HealthService.h"

@interface TESMapViewController : UIViewController

@property (strong, nonatomic) HealthService *healthService;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
