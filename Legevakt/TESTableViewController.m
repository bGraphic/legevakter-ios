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
#import "TESLegevaktCell.h"
#import "BGInfoNavigationControllerDelegate.h"

@interface TESTableViewController()

@property (nonatomic, strong) BGInfoNavigationControllerDelegate *navDelegate;

@end

@implementation TESTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureInfoButton];
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
    static NSString *CellIdentifier = @"LegevaktCell";
    TESLegevaktCell *cell = (TESLegevaktCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(TESLegevaktCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.myLocation = self.myLocation;
    cell.healthService = (HealthService *)[self.healthServices objectAtIndex:indexPath.row];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HealthService *healthService = [self.healthServices objectAtIndex:indexPath.row];
        
        [[segue destinationViewController] setHealthService:healthService];
    }
}

#pragma mark - Info Button
- (void)configureInfoButton
{
    self.navDelegate = [[BGInfoNavigationControllerDelegate alloc] init];
    self.navigationController.delegate = self.navDelegate;
}

@end
