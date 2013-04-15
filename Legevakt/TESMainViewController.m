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

#ifdef DEBUG
static NSTimeInterval const kBPForceUpdaterAfterInterval = 5.0f; //5 sec
#else
static NSTimeInterval const kBPForceUpdaterAfterInterval = 360.0f; //1hour
#endif

@interface TESMainViewController ()

@property (nonatomic, strong) TESMapViewController *mapViewController;

@property (strong, nonatomic) TESTableDataSource *tableDataSource;
@property (strong, nonatomic) TESTableDelegate *tableDelegate;

@property (retain) CLLocation *myLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) BGInfoNavigationControllerDelegate *navDelegate;

@property (nonatomic, strong) NSDate *appDidEnterBackgroundDate;

@property (nonatomic, strong) MBProgressHUD *hud;

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
    
    [self configureInfoButton];
    
    BGSearchBar *bgSearchBar = (BGSearchBar *) self.searchDisplayController.searchBar;
    bgSearchBar.borderColor = self.tableView.separatorColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void) applicationDidEnterBackground:(NSNotification *)note
{
    self.appDidEnterBackgroundDate = [NSDate date];
}

- (void) applicationDidBecomeActive:(NSNotification *)note
{
    NSTimeInterval timeInterval = abs([self.appDidEnterBackgroundDate timeIntervalSinceNow]);
    
    if(!self.tableDataSource.healthServices || timeInterval > kBPForceUpdaterAfterInterval)
    {
        [self startUpdatingLocation];
    }
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.locationManager startUpdatingLocation];
}

# pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    
    [HealthServiceManager findAllHealthServicesAlphabeticalWithBlock:^(NSArray *healthServices) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableDataSource updateTableView:self.tableView withHealthServices:healthServices];
    }];
    
    NSLog(@"Location Error: %@", [error description]);

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    self.myLocation = [locations lastObject];
    self.tableDataSource.myLocation = self.myLocation;
    self.mapViewController.myLocation = self.myLocation;
    
    [HealthServiceManager findHealthServicesNearLocation:self.myLocation withLimit: kTESInitialHealthServicesLimit andBlock:^(NSArray *healthServices) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableDataSource updateTableView:self.tableView withHealthServices:healthServices];
    }];
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
    [self.tableDataSource startAnimatingLoadMoreCellForTableView:self.searchDisplayController.searchResultsTableView];

    [HealthServiceManager searchWithString:searchBar.text andBlock:^(NSArray *searchStringInNameHealthServices, NSArray *searchStringInLocationNameHealthServices)
    {
        [self.tableDataSource updateTableView:self.searchDisplayController.searchResultsTableView withFilteredHealthServices:searchStringInNameHealthServices];
        [self.tableDataSource updateTableView:self.searchDisplayController.searchResultsTableView withSearchedHealthServices:searchStringInLocationNameHealthServices];
    }];
}

#pragma mark - Info Button
- (void)configureInfoButton
{
    self.navDelegate = [[BGInfoNavigationControllerDelegate alloc] init];
    self.navigationController.delegate = self.navDelegate;
}

@end
