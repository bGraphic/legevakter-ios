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
    // Return the number of sections.
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
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *MapCellIdentifier = @"MapViewCell";
        
        UITableViewCell *cell = (TESHealthServiceCell *)[tableView dequeueReusableCellWithIdentifier:MapCellIdentifier];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MapCellIdentifier];
            
            cell.textLabel.text = @"Se legevaktene i kart";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
            
        
        return cell;
    }
    
    
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
