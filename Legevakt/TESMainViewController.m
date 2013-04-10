//
//  TESMainViewController.m
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESMainViewController.h"
#import "TESTableViewController.h"
#import "TESMapViewController.h"

@interface TESMainViewController ()

@property (nonatomic, strong) TESTableViewController *tableViewController;
@property (nonatomic, strong) TESMapViewController *mapViewController;

@property (retain) CLLocation *myLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation TESMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mainViewChanged:(id)sender
{
    self.tableView.hidden = !self.tableView.hidden;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    return _locationManager;
}

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

# pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.myLocation = [locations lastObject];
    self.tableViewController.myLocation = self.myLocation;
    self.mapViewController.myLocation = self.myLocation;
    
    [HealthServiceManager findHealthServicesNearLocation:self.myLocation withDelegate:self];
    [manager stopUpdatingLocation];
}

#pragma mark HealthServiceManagerDelegate

- (void)manager:(id)manager foundHealthServicesNearby:(NSArray *)healthServices
{
    self.tableViewController.healthServices = healthServices;
    self.mapViewController.healthServices = healthServices;
}


#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    
    if([segueName isEqualToString:@"embedTableViewController"])
    {
        self.tableViewController = (TESTableViewController *) segue.destinationViewController;
    }
    
    if([segueName isEqualToString:@"embedMapViewController"])
    {
        self.mapViewController = (TESMapViewController *) segue.destinationViewController;
    }
}

@end