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
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HealthServiceCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        TESHealthServiceCell *healthServiceCell = (TESHealthServiceCell *)[self.tableView.dataSource tableView:self.tableView cellForRowAtIndexPath:indexPath];
        
        [[segue destinationViewController] setHealthService:healthServiceCell.healthService];
    }
}

- (void)viewDidUnload {
    [self setHealthServiceDataSource:nil];
    [super viewDidUnload];
}
@end
