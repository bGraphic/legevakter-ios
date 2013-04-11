//
//  TESHealthServicesTableDelegate.m
//  Legevakt
//
//  Created by Benedicte Raae on 11.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESTableDelegate.h"
#import "TESTableDataSource.h"
#import "TESDetailViewController.h"

@implementation TESTableDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TESTableDataSource *healthServicesDataSource = tableView.dataSource;
    HealthService *healthService = [healthServicesDataSource healthServiceAtIndexPath:indexPath];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    TESDetailViewController *detailView = [sb instantiateViewControllerWithIdentifier:@"detailView"];
    detailView.healthService = healthService;
    
    [self.viewController.navigationController pushViewController:detailView animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

@end
