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
#import "BGInfoNavigationControllerDelegate.h"
#import "TESTableDataSource.h"

@interface TESMainViewController ()

@property (nonatomic, strong) TESTableViewController *tableViewController;
@property (nonatomic, strong) TESMapViewController *mapViewController;

@property (retain) CLLocation *myLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) BGInfoNavigationControllerDelegate *navDelegate;

@end

@implementation TESMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startUpdatingLocation];
    
    [self configureInfoButton];
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
    [self setSearchHelthServicesDataSource:nil];
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
    self.tableViewController.healthServiceDataSource.myLocation = self.myLocation;
    self.searchHelthServicesDataSource.myLocation = self.myLocation;
    self.mapViewController.myLocation = self.myLocation;
    
    [HealthServiceManager findHealthServicesNearLocation:self.myLocation withDelegate:self];
    [manager stopUpdatingLocation];
}

#pragma mark HealthServiceManagerDelegate

- (void)manager:(id)manager foundHealthServicesNearby:(NSArray *)healthServices
{
    self.tableViewController.healthServiceDataSource.healthServices = healthServices;
    [self.tableViewController.tableView reloadData];
    
    self.mapViewController.healthServices = healthServices;
}

- (void)manager:(id)manager foundHealthServicesFromSearch:(NSArray *)healthServices
{
    self.searchHelthServicesDataSource.healthServices = healthServices;
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark UISearchControllerDelegate
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.searchHelthServicesDataSource.unFilteredHealthServices = self.tableViewController.healthServiceDataSource.healthServices;
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.searchHelthServicesDataSource filterContentForSearchText:searchString];
    
    return YES;
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Search for: %@", searchBar.text);
    
    HealthServiceManager *manager = [[HealthServiceManager alloc] init];
    [manager searchWithString:searchBar.text delegate:self];
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

#pragma mark - Info Button
- (void)configureInfoButton
{
    self.navDelegate = [[BGInfoNavigationControllerDelegate alloc] init];
    self.navigationController.delegate = self.navDelegate;
}

@end
