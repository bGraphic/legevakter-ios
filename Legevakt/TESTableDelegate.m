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
#import "TESMapViewController.h"
#import "HealthServiceManager.h"
#import "MBProgressHUD.h"

@implementation TESTableDelegate

- (id) initWithNavigationController:(UINavigationController *) navigationController
{
    self = [super init];
    if(self)
    {
        self.navigationController = navigationController;
    }
    
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    TESTableDataSource *healthServicesDataSource = tableView.dataSource;
    UIViewController *viewControllerToBePushed;
    
    if(indexPath.section == 0)
    {
        TESMapViewController *mapView = [sb instantiateViewControllerWithIdentifier:@"mapView"];
        mapView.tableDataSource = healthServicesDataSource;
        viewControllerToBePushed = mapView;
    }
    else if(indexPath.section == 2)
    {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setUserInteractionEnabled:NO];
        [cell setSelected:NO animated:YES];
        [cell setAccessoryView:indicatorView];
        
        [indicatorView startAnimating];
        
        [HealthServiceManager findAllHealthServicesNearLocation:healthServicesDataSource.myLocation withBlock:^(NSArray *healthServices) {
            
            [indicatorView stopAnimating];
            
            if(healthServices)
            {
                healthServicesDataSource.healthServices = healthServices;
                [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
                [tableView reloadData];
            }
        }];
    }
    else
    {
        HealthService *healthService = [healthServicesDataSource healthServiceAtIndexPath:indexPath];
        
        TESDetailViewController *detailView = [sb instantiateViewControllerWithIdentifier:@"detailView"];
        detailView.healthService = healthService;
        
        viewControllerToBePushed = detailView;
    }
        
    if(self.navigationController && viewControllerToBePushed)
        [self.navigationController pushViewController:viewControllerToBePushed animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 || indexPath.section == 2)
        return 50.f;
    else
        return 80.f;
}

@end
