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

@interface TESTableDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSArray *healthServices;
@property (strong, nonatomic) NSMutableArray *healthServicesFiltered;

@property (strong, nonatomic) CLLocation *myLocation;

- (HealthService *) healthServiceAtIndexPath:(NSIndexPath *) indexPath;

- (void) filterContentForSearchText:(NSString*)searchText;
- (void) resetFilter;

@end
