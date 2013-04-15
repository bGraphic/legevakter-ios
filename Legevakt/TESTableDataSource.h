//
//  TESHealthServiceDataSource.h
//  Legevakt
//
//  Created by Benedicte Raae on 11.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "HealthService.h"

static int const kTESInitialHealthServicesLimit = 3;

static NSString * const kTESLocationName = @"locationName";
static NSString * const kTESLocationType = @"locationType";
static NSString * const kTESLocationTypeMunicipality = @"municipality";
static NSString * const kTESLocationTypeCounty = @"county";
static NSString * const kTESLocationTypePlace = @"place";

@interface TESTableDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSArray *healthServices;
@property (strong, nonatomic) NSArray *healthServicesFiltered;
@property (strong, nonatomic) NSArray *healthServicesSearched;

@property (strong, nonatomic) CLLocation *myLocation;

@property (strong, nonatomic) NSString *searchString;

- (HealthService *) healthServiceAtIndexPath:(NSIndexPath *) indexPath;

- (void) filterContentForSearchText:(NSString*)searchText;
- (void) resetFilter;

- (void)updateTableView:(UITableView *) tableView withHealthServices:(NSArray *)healthServices;
- (void)updateTableView:(UITableView *) tableView withFilteredHealthServices:(NSArray *)healthServices;
- (void)updateTableView:(UITableView *) tableView withSearchedHealthServices:(NSArray *)healthServices;

- (void) startAnimatingLoadMoreCellForTableView:(UITableView *) tableView;

@end
