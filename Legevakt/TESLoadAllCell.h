//
//  TESLoadAllCell.h
//  Legevakt
//
//  Created by Benedicte Raae on 12.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TESLoadAllCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (void) startActivity;
- (void) stopActivity;


@end
