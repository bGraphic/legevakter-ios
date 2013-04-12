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
    if(self.healthServices.count == kTESInitialHealthServicesLimit)
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
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
        if(self.healthServicesFiltered)
            cell.textLabel.text = NSLocalizedString(@"search_results_in_map", nil);
        else
            cell.textLabel.text = NSLocalizedString(@"health_services_in_map", nil);

        return cell;
    }
    
    if(indexPath.section == 2)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
            cell.textLabel.text = NSLocalizedString(@"load_all_health_services", nil);
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        return cell;
    }
    
    
    static NSString *CellIdentifier = @"HealthServiceCell";
    TESHealthServiceCell *cell = (TESHealthServiceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        UINib *nib = [UINib nibWithNibName:@"TESHealthServiceCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"HealthServiceCell"];
        
        cell = (TESHealthServiceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    [cell configureViewWithHealthService:[self healthServiceAtIndexPath:indexPath] andLocation:self.myLocation];
    
    return cell;
}

@end
