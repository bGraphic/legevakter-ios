//
//  TESMainViewController.m
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESMainViewController.h"
#import "TESTableViewController.h"
#import "TESMapViewController.h"

@interface TESMainViewController ()

@property (nonatomic, strong) TESTableViewController *tableViewController;
@property (nonatomic, strong) TESMapViewController *mapViewController;

@end

@implementation TESMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mainViewChanged:(id)sender
{
    self.tableView.hidden = !self.tableView.hidden;

}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    
    if([segueName isEqualToString:@"embedTableViewController"])
    {
        self.tableViewController = (TESTableViewController *) segue.destinationViewController;
    }
    
    if([segueName isEqualToString:@"embedMapViewController"])
    {
        self.tableViewController = (TESMapViewController *) segue.destinationViewController;
    }
}

@end
