//
//  TESDetailViewController.h
//  Legevakt
//
//  Created by Benedicte Raae on 08.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthService.h"

@interface TESDetailViewController : UITableViewController

@property (strong, nonatomic) HealthService *detailItem;

@property (weak, nonatomic) IBOutlet UITableViewCell *phoneNumberCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *AdressCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *WebpageCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *OpeningHoursCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *OpeningHoursCommentCell;



@end
