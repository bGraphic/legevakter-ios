//
//  TESTableViewController.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/26/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESTableViewController.h"
#import "HealthService.h"
#import "TESDetailViewController.h"
#import "TESLegevaktCell.h"

@interface TESTableViewController()

@property (strong,nonatomic) NSArray *healthServices;
@property (retain) CLLocation *myLocation;
@property (strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation TESTableViewController

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
    [HealthServiceManager findHealthServicesNearLocation:self.myLocation withDelegate:self];
    [manager stopUpdatingLocation];
}

#pragma mark HealthServiceManagerDelegate

- (void)manager:(id)manager foundHealthServicesNearby:(NSArray *)healthServices
{
    self.healthServices = healthServices;
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.healthServices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LegevaktCell";
    TESLegevaktCell *cell = (TESLegevaktCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(TESLegevaktCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.myLocation = self.myLocation;
    cell.healthService = (HealthService *)[self.healthServices objectAtIndex:indexPath.row];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HealthService *healthService = [self.healthServices objectAtIndex:indexPath.row];
        
        [[segue destinationViewController] setHealthService:healthService];
    }
}

@end
