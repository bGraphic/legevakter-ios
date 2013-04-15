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
#import "MBProgressHUD.h"
#import "BGSearchBar.h"

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
    
    self.title = NSLocalizedString(@"main_view_controller_title", nil);
    
    self.tableDataSource = [[TESTableDataSource alloc] init];
    self.tableDelegate = [[TESTableDelegate alloc] initWithNavigationController:self.navigationController];

    self.tableView.dataSource = self.tableDataSource;
    self.tableView.delegate = self.tableDelegate;
    self.searchDisplayController.searchResultsDataSource = self.tableDataSource;
    self.searchDisplayController.searchResultsDelegate = self.tableDelegate;
    
    [self.locationManager startUpdatingLocation];
    
    [self configureInfoButton];
    
    BGSearchBar *bgSearchBar = (BGSearchBar *) self.searchDisplayController.searchBar;
    bgSearchBar.borderColor = self.tableView.separatorColor;
}

- (void) viewDidAppear:(BOOL)animated
{
    if(!self.tableDataSource.healthServices)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

- (void)updateDataSourceWithFiltredHealthServices:(NSArray *)healthServices
{
    if(healthServices)
    {
        self.tableDataSource.healthServicesFiltered = healthServices;
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (void)updateDataSourceWithSearchedHealthServices:(NSArray *)healthServices
{
    if(healthServices)
    {
        self.tableDataSource.healthServicesSearched = healthServices;
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

# pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.myLocation = [locations lastObject];
    self.tableDataSource.myLocation = self.myLocation;
    self.mapViewController.myLocation = self.myLocation;
    
    [HealthServiceManager findHealthServicesNearLocation:self.myLocation withLimit: kTESInitialHealthServicesLimit andBlock:^(NSArray *healthServices) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self updateDataSourceWithHealthServices:healthServices];
    }];
    
    [manager stopUpdatingLocation];
}

#pragma mark UISearchControllerDelegate

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    BGSearchBar *bgSearchBar = (BGSearchBar *) controller.searchBar;
    [bgSearchBar setBorderHidden:YES];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    BGSearchBar *bgSearchBar = (BGSearchBar *) controller.searchBar;
    [bgSearchBar setBorderHidden:NO];
    
    [self.tableDataSource resetFilter];
    [self.tableView reloadData];
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.tableDataSource resetFilter];
    [self.tableDataSource filterContentForSearchText:searchString];
    
    return YES;
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    [HealthServiceManager searchWithString:searchBar.text andBlock:^(NSArray *searchStringInNameHealthServices, NSArray *searchStringInLocationNameHealthServices) {

        [self updateDataSourceWithSearchedHealthServices:searchStringInLocationNameHealthServices];
        [self updateDataSourceWithFiltredHealthServices:searchStringInNameHealthServices];
    }];
}

#pragma mark - Info Button
- (void)configureInfoButton
{
    self.navDelegate = [[BGInfoNavigationControllerDelegate alloc] init];
    self.navigationController.delegate = self.navDelegate;
}

@end
