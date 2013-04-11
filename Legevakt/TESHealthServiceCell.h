//
//  TESLegevaktCell.h
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthService.h"

@interface TESHealthServiceCell : UITableViewCell

@property (strong, nonatomic) HealthService *healthService;
@property (weak, nonatomic) CLLocation *myLocation;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *openingHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
