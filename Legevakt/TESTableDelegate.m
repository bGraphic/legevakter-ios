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
#import "TESLoadAllCell.h"

@interface TESTableDelegate ()

@property (strong, nonatomic) TESMapViewController *mapViewController;
@property (strong, nonatomic) TESMapViewController *filterMapViewController;

@end

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
        if(healthServicesDataSource.healthServicesFiltered)
        {
            if(!self.filterMapViewController)
                self.filterMapViewController = [sb instantiateViewControllerWithIdentifier:@"mapView"];
            
            self.filterMapViewController.healthServices = healthServicesDataSource.healthServicesFiltered;
            viewControllerToBePushed = self.filterMapViewController;
        }
        else
        {
            if(!self.mapViewController)
                self.mapViewController = [sb instantiateViewControllerWithIdentifier:@"mapView"];
            
            self.mapViewController.healthServices = healthServicesDataSource.healthServices;
            viewControllerToBePushed = self.mapViewController;

        }
    }
    else if(indexPath.section == 2)
    {
        
        TESLoadAllCell *cell = (TESLoadAllCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        [cell startActivity];
    
        [HealthServiceManager findAllHealthServicesNearLocation:healthServicesDataSource.myLocation withBlock:^(NSArray *healthServices) {
            
            [cell stopActivity];
            
            if(healthServices)
            {
                healthServicesDataSource.healthServices = healthServices;
                [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
                [tableView reloadData];
                
                self.mapViewController.healthServices = healthServices;
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
    if(indexPath.section == 0)
        return 60.f;
    else
        return 80.f;
}

@end
