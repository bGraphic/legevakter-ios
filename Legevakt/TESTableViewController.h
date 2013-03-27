//
//  TESTableViewController.h
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/26/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HealthServiceManager.h"

@interface TESTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, HealthServiceManagerDelegate>

@end
