//
//  TESHealthServiceDataSource.m
//  Legevakt
//
//  Created by Benedicte Raae on 11.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESHealthServicesDataSource.h"
#import "TESHealthServiceCell.h"

@implementation TESHealthServicesDataSource

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
    static NSString *CellIdentifier = @"HealthServiceCell";
    TESHealthServiceCell *cell = (TESHealthServiceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(TESHealthServiceCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.myLocation = self.myLocation;
    cell.healthService = (HealthService *)[self.healthServices objectAtIndex:indexPath.row];
}

+ (TESHealthServicesDataSource *) healthServiceDataSourceWithHealthservices:(NSArray *) healthServices andLocation:(CLLocation *) myLocation
{
    TESHealthServicesDataSource *healthServiceDataSource = [[self alloc] init];
    healthServiceDataSource.healthServices = healthServices;
    healthServiceDataSource.myLocation = myLocation;
    
    return healthServiceDataSource;
}

@end
