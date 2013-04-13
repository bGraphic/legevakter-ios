//
//  TESMainViewController.m
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESMainViewController.h"
#import "TESMapViewController.h"
#import "BGInfoNavigationControllerDelegate.h"
#import "TESTableDataSource.h"
#import "HealthServiceManager.h"

@interface TESMainViewController ()

@property (nonatomic, strong) TESMapViewController *mapViewController;

@property (strong, nonatomic) TESTableDataSource *tableDataSource;
@property (strong, nonatomic) TESTableDelegate *tableDelegate;

@property (retain) CLLocation *myLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) BGInfoNavigationControllerDelegate *navDelegate;

@end

@implementation TESMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableDataSource = [[TESTableDataSource alloc] init];
    self.tableDelegate = [[TESTableDelegate alloc] initWithNavigationController:self.navigationController];

    self.tableView.dataSource = self.tableDataSource;
    self.tableView.delegate = self.tableDelegate;
    self.searchDisplayController.searchResultsDataSource = self.tableDataSource;
    self.searchDisplayController.searchResultsDelegate = self.tableDelegate;
    
    [self startUpdatingLocation];
    
    [self configureInfoButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableDataSource:nil];
    [self setTableDelegate:nil];
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

- (void)updateDataSourceWithHealthServices:(NSArray *)healthServices
{
    if(healthServices)
    {
        self.tableDataSource.healthServices = healthServices;
        [self.tableView reloadData];
    }
}

# pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.myLocation = [locations lastObject];
    self.tableDataSource.myLocation = self.myLocation;
    self.mapViewController.myLocation = self.myLocation;
    
    [HealthServiceManager findHealthServicesNearLocation:self.myLocation withLimit: kTESInitialHealthServicesLimit andBlock:^(NSArray *healthServices) {
        [self updateDataSourceWithHealthServices:healthServices];
    }];
    
    [manager stopUpdatingLocation];
}

#pragma mark UISearchControllerDelegate

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.tableDataSource resetFilter];
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.tableDataSource filterContentForSearchText:searchString];
    
    return YES;
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Search for: %@", searchBar.text);

    [HealthServiceManager searchWithString:searchBar.text andBlock:^(NSArray *healthServices) {
        NSLog(@"returned from search block with results: %d", healthServices.count);
        [self updateDataSourceWithHealthServices:healthServices];
    }];
}

#pragma mark - Info Button
- (void)configureInfoButton
{
    self.navDelegate = [[BGInfoNavigationControllerDelegate alloc] init];
    self.navigationController.delegate = self.navDelegate;
}

@end
