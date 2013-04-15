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
    [self setUserInteractionEnabled:NO];
    [self setSelected:NO animated:YES];
    
    self.iconImageView.hidden = YES;
 
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame = self.iconImageView.frame;
    indicatorView.hidesWhenStopped = YES;
    [self addSubview:indicatorView];
    [indicatorView startAnimating];
}

- (void) stopActivity
{
    self.label.text = NSLocalizedString(@"cell_error_message", nil);
    
    [self setUserInteractionEnabled:YES];
    
    self.iconImageView.hidden = NO;
    
    [indicatorView stopAnimating];
}

@end
