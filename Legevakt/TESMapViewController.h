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
#import "TESTableDataSource.h"

@interface TESMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) HealthService *healthService;
@property (strong, nonatomic) TESTableDataSource *tableDataSource;
@property (strong, nonatomic) CLLocation *myLocation;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
