//
//  TESLegevaktCell.m
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESHealthServiceCell.h"

@implementation TESHealthServiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureViewWithHealthService:(HealthService *) healthService andLocation:(CLLocation *) myLocation
{
    if (healthService) {
        self.nameLabel.text = healthService.displayName;
        self.openingHoursLabel.text = healthService.isOpen?@"Åpent":@"Stengt";
    
        if(myLocation)
            self.distanceLabel.text = [healthService formattedDistanceFromLocation:myLocation];
        else
            self.distanceLabel.text = @"";
        
        self.nameLabel.alpha = healthService.isOpen?1.0f:0.6f;
        self.openingHoursLabel.alpha = healthService.isOpen?1.0f:0.6f;
        self.distanceLabel.alpha = healthService.isOpen?1.0f:0.6f;
        self.iconImageView.alpha = healthService.isOpen?1.0f:0.6f;
        
        self.iconImageView.image = healthService.isOpen?[UIImage imageNamed:@"ER_open"]:[UIImage imageNamed:@"ER_closed"];
    }
}



@end
