//
//  TESHealthServiceDataSource.m
//  Legevakt
//
//  Created by Benedicte Raae on 11.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESTableDataSource.h"
#import "TESHealthServiceCell.h"
#import "TESViewInMapCell.h"
#import "TESLoadAllCell.h"

static NSString * const kTESHealthServiceCellIdentifier = @"HealthServiceCell";
static NSString * const kTESLoadAllCellIdentifier = @"LoadMoreCell";
static NSString * const kTESViewInMapCellIdentifier = @"ViewInMapCell";

@interface TESTableDataSource ()

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


#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.healthServices.count == kTESInitialHealthServicesLimit && !self.healthServicesFiltered)
        return 3;
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 0;
    
    if(self.healthServicesFiltered)
        count = self.healthServicesFiltered.count;
    else
        count = self.healthServices.count;
    
    if(section == 0)
    {
        if (count == 0)
            return 0;
        else
            return 1;
    }
    
    if(section == 2)
    {
        return 1;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        TESViewInMapCell *cell = (TESViewInMapCell *)[tableView dequeueReusableCellWithIdentifier:kTESViewInMapCellIdentifier];
        
        if(!cell) {
            UINib *nib = [UINib nibWithNibName:@"TESViewInMapCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:kTESViewInMapCellIdentifier];
            
            cell = (TESViewInMapCell *)[tableView dequeueReusableCellWithIdentifier:kTESViewInMapCellIdentifier];
        }
        
        [cell configureCellIsSearchResult:self.healthServicesFiltered?YES:NO];
        
        return cell;
    }
    
    if(indexPath.section == 2)
    {
        TESLoadAllCell *cell = (TESLoadAllCell *)[tableView dequeueReusableCellWithIdentifier:kTESLoadAllCellIdentifier];
        
        if(!cell) {
            UINib *nib = [UINib nibWithNibName:@"TESLoadAllCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:kTESLoadAllCellIdentifier];
            
            cell = (TESLoadAllCell *)[tableView dequeueReusableCellWithIdentifier:kTESLoadAllCellIdentifier];
        }
        
        return cell;
    }
    
    
    TESHealthServiceCell *cell = (TESHealthServiceCell *)[tableView dequeueReusableCellWithIdentifier:kTESHealthServiceCellIdentifier];
    
    if(!cell) {
        UINib *nib = [UINib nibWithNibName:@"TESHealthServiceCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:kTESHealthServiceCellIdentifier];
        
        cell = (TESHealthServiceCell *)[tableView dequeueReusableCellWithIdentifier:kTESHealthServiceCellIdentifier];
    }
    
    [cell configureViewWithHealthService:[self healthServiceAtIndexPath:indexPath] andLocation:self.myLocation];
    
    return cell;
}

@end
