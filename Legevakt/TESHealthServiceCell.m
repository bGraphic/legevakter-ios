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

- (void)setHealthService:(id)newHealthService
{
    if (_healthService != newHealthService) {
        _healthService = newHealthService;
        
        // Update the view.
        [self configureView];
    }
}

- (void)setMyLocation:(CLLocation *)newMyLocation
{
    if(_myLocation.coordinate.latitude != newMyLocation.coordinate.latitude || _myLocation.coordinate.latitude != newMyLocation.coordinate.latitude)
    {
        _myLocation = newMyLocation;
        
        [self configureView];
    }
}

- (void) configureView
{
    if (self.healthService) {
        self.nameLabel.text = self.healthService.displayName;
        self.openingHoursLabel.text = self.healthService.isOpen?@"Åpent":@"Stengt";
    
        if(self.myLocation)
            self.distanceLabel.text = [self.healthService formattedDistanceFromLocation:self.myLocation];
        else
            self.distanceLabel.text = @"";
        
        self.nameLabel.alpha = self.healthService.isOpen?1.0f:0.6f;
        self.openingHoursLabel.alpha = self.healthService.isOpen?1.0f:0.6f;
        self.distanceLabel.alpha = self.healthService.isOpen?1.0f:0.6f;
        self.iconImageView.alpha = self.healthService.isOpen?1.0f:0.6f;
        
        self.iconImageView.image = self.healthService.isOpen?[UIImage imageNamed:@"ER_open"]:[UIImage imageNamed:@"ER_closed"];
    }
}



@end
