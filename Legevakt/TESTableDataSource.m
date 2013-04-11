//
//  TESHealthServiceDataSource.m
//  Legevakt
//
//  Created by Benedicte Raae on 11.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESTableDataSource.h"
#import "TESHealthServiceCell.h"

@interface TESTableDataSource ()

@property (strong, nonatomic) NSMutableArray *healthServicesFiltered;

@end

@implementation TESTableDataSource

- (HealthService *) healthServiceAtIndexPath:(NSIndexPath *) indexPath
{
    if(self.healthServicesFiltered)
        return [self.healthServicesFiltered objectAtIndex:indexPath.row];
    else
        return [self.healthServices objectAtIndex:indexPath.row];
}
#pragma mark - filter

- (void) filterContentForSearchText:(NSString*)searchText
{
    if(!self.healthServicesFiltered)
        self.healthServicesFiltered = [NSMutableArray arrayWithCapacity:self.healthServices.count];
    else
        [self.healthServicesFiltered removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.displayName contains[c] %@)", searchText, searchText];
    
    self.healthServicesFiltered = [NSMutableArray arrayWithArray:[self.healthServices filteredArrayUsingPredicate:predicate]];
}

- (void) resetFilter
{
    self.healthServicesFiltered = nil;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.healthServicesFiltered)
        return self.healthServicesFiltered.count;
    else
        return self.healthServices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HealthServiceCell";
    TESHealthServiceCell *cell = (TESHealthServiceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        UINib *nib = [UINib nibWithNibName:@"TESHealthServiceCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"HealthServiceCell"];
        
        cell = (TESHealthServiceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    cell.myLocation = self.myLocation;
    cell.healthService = [self healthServiceAtIndexPath:indexPath];
    
    return cell;
}

@end
