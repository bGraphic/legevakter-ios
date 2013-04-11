//
//  TESTableViewController.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/26/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESTableViewController.h"
#import "HealthService.h"
#import "TESDetailViewController.h"
#import "TESHealthServiceCell.h"

@implementation TESTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"TESHealthServiceCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"ItemCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setHealthServices:(NSArray *)healthServices
{
    if(![_healthServices isEqualToArray:healthServices]) {
        _healthServices = healthServices;
        
        [self.tableView reloadData];
    }
}

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
    static NSString *CellIdentifier = @"ItemCell";
    TESHealthServiceCell *cell = (TESHealthServiceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(TESHealthServiceCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.myLocation = self.myLocation;
    cell.healthService = (HealthService *)[self.healthServices objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetailFromTable" sender:self];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetailFromTable"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HealthService *healthService = [self.healthServices objectAtIndex:indexPath.row];
        
        [[segue destinationViewController] setHealthService:healthService];
    }
}

@end
