//
//  TESLoadAllCell.m
//  Legevakt
//
//  Created by Benedicte Raae on 12.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESLoadAllCell.h"

@implementation TESLoadAllCell

UIActivityIndicatorView *indicatorView;

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) startActivity
{
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self setUserInteractionEnabled:NO];
    [self setSelected:NO animated:YES];
    
    indicatorView.frame = self.iconImageView.frame;
    self.iconImageView.hidden = YES;
    
    [self addSubview:indicatorView];
    
    [indicatorView startAnimating];
}

- (void) stopActivity
{
    self.iconImageView.hidden = NO;
    [indicatorView stopAnimating];
}

@end
