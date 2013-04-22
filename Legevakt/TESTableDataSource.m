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

@property (readonly) BOOL showMapCell;
@property (readonly) BOOL showLoadMoreCell;

@end

@implementation TESTableDataSource

- (BOOL) showLoadMoreCell
{
    if(self.healthServicesSearched)
        return NO;
    else if(self.healthServicesFiltered)
        return YES;
    else if(self.healthServices)
        return self.healthServices.count > kTESInitialHealthServicesLimit ? NO : YES;
    else
        return NO;
}

- (BOOL) showMapCell
{
    if(self.healthServicesSearched)
        return NO;
    else if(self.healthServicesFiltered)
        return self.healthServicesFiltered.count == 0 ? NO : YES;
    else if(self.healthServices)
        return self.healthServices.count == 0 ? NO : YES;
    else
        return NO;
}

- (NSInteger) numberOfHealthServicesSections
{
    if(self.healthServicesSearched)
        return self.healthServicesSearched.count+1; //+1 for filtered search
    if (self.healthServicesFiltered)
        return 1;
    else if (self.healthServices)
        return 1;
    else
        return 0;
}

- (NSString *) titleOfHealthServicesSection:(NSInteger) section
{
    section = section-1; // compensate for map section
    
    if(self.healthServicesSearched && section != 0)
    {
        section = section-1; // compensate for filtered health services
        
        NSDictionary *healthServicesSection = [self.healthServicesSearched objectAtIndex:section];
        
        NSString *locationName = [healthServicesSection valueForKey:kTESLocationName];
    
        return locationName;
    }
    else
        return nil;
}

- (NSInteger) numberOfHealthServicesInHealthServiceSection:(NSInteger) section
{
    section = section-1; // compensate for map section
    
    if(self.healthServicesSearched && section != 0) // if 0 it will go to filtered health services
        return [[[self.healthServicesSearched objectAtIndex:section-1] valueForKey:@"healthServices"] count];
    else if(self.healthServicesFiltered)
        return self.healthServicesFiltered.count;
    else if(self.healthServices)
        return self.healthServices.count;
    else
        return 0;
}

- (HealthService *) healthServiceAtIndexPath:(NSIndexPath *) indexPath
{
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1]; // compensate for map section
    
    if(self.healthServicesSearched && indexPath.section != 0) // if 0 it will go to filtered health services
        return [[[self.healthServicesSearched objectAtIndex:indexPath.section-1] valueForKey:@"healthServices"] objectAtIndex:indexPath.row];
    else if(self.healthServicesFiltered)
        return [self.healthServicesFiltered objectAtIndex:indexPath.row];
    else if (self.healthServices)
        return [self.healthServices objectAtIndex:indexPath.row];
    else
        return nil;
}

#pragma mark - update data source

- (void) startAnimatingLoadMoreCellForTableView:(UITableView *) tableView
{
    NSInteger moreCellSection = [self numberOfSectionsInTableView:tableView];
    moreCellSection = moreCellSection-1;
    
    if([self tableView:tableView numberOfRowsInSection:moreCellSection] > 0)
    {
        TESLoadAllCell *cell = (TESLoadAllCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:moreCellSection]];
        
        [cell startActivity];
    }
}

- (void) stopAnimatingLoadMoreCellForTableView:(UITableView *) tableView
{
    NSInteger moreCellSection = [self numberOfSectionsInTableView:tableView];
    moreCellSection = moreCellSection-1;
    
    if([self tableView:tableView numberOfRowsInSection:moreCellSection] > 0)
    {
        TESLoadAllCell *cell = (TESLoadAllCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:moreCellSection]];
        
        [cell stopActivity];
    }
}

- (void)updateTableView:(UITableView *) tableView withHealthServices:(NSArray *)healthServices
{
    
    [self stopAnimatingLoadMoreCellForTableView:tableView];
    
    if(healthServices)
    {
        self.healthServices = healthServices;
        [tableView reloadData];
    }
}

- (void)updateTableView:(UITableView *) tableView withFilteredHealthServices:(NSArray *)healthServices
{
    [self stopAnimatingLoadMoreCellForTableView:tableView];
    
    if(healthServices)
    {
        self.healthServicesFiltered = healthServices;
        [tableView reloadData];
    }
}

- (void)updateTableView:(UITableView *) tableView withSearchedHealthServices:(NSArray *)healthServices
{
    if(healthServices)
    {
        self.healthServicesSearched = healthServices;
        [tableView reloadData];
    }
}

#pragma mark - filter
- (void) filterContentForSearchText:(NSString*)searchText
{
    self.searchString = searchText;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.displayName contains[c] %@)", searchText, searchText];
    
    self.healthServicesFiltered = [self.healthServices filteredArrayUsingPredicate:predicate];
}

- (void) resetFilter
{
    self.healthServicesFiltered = nil;
    self.healthServicesSearched = nil;
}


#pragma mark - Table View Data Source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfHealthServicesSections] + 2; //+1 for map section, +1 for load more section
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{    
    if(section == 0)
        return nil;
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return nil;
    }
    
    return [self titleOfHealthServicesSection:section]; 
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return self.showMapCell ? 1 : 0;
    else if (section == [self numberOfSectionsInTableView:tableView] - 1)
        return self.showLoadMoreCell ? 1 : 0;

    return [self numberOfHealthServicesInHealthServiceSection:section];
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
    
    if(indexPath.section == [self numberOfSectionsInTableView:tableView] - 1)
    {
        TESLoadAllCell *cell = (TESLoadAllCell *)[tableView dequeueReusableCellWithIdentifier:kTESLoadAllCellIdentifier];
        
        if(!cell) {
            UINib *nib = [UINib nibWithNibName:@"TESLoadAllCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:kTESLoadAllCellIdentifier];
            
            cell = (TESLoadAllCell *)[tableView dequeueReusableCellWithIdentifier:kTESLoadAllCellIdentifier];
        }
        
        if(self.healthServicesFiltered)
            cell.label.text = [NSString stringWithFormat:NSLocalizedString(@"load_health_services_for_location_string %@", nil), self.searchString];
        else
            cell.label.text = NSLocalizedString(@"load_all_health_services", nil);
        
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
