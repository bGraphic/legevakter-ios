//
//  TESMainViewController.h
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthServiceManager.h"
#import "TESTableDataSource.h"
#import "TESTableDelegate.h"

@interface TESMainViewController : UIViewController <CLLocationManagerDelegate, HealthServiceManagerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableView;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (strong, nonatomic) IBOutlet TESTableDataSource *tableDataSource;
@property (strong, nonatomic) IBOutlet TESTableDelegate *tableDelegate;

- (IBAction)mainViewChanged:(id)sender;

@end
